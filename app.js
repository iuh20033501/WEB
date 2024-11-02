require('dotenv').config();
const express = require('express');
const mysql = require('mysql2');
const path = require('path');
const app = express();
app.use(express.json());

const session = require('express-session');
const db = mysql.createConnection({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
});

app.use(session({
    secret: process.env.SECRET_KEY,
    resave: false,
    saveUninitialized: true,
}));
db.connect((err) => {
    if (err) {
        console.error('Không thể kết nối đến MySQL:', err);
    } else {
        console.log('Đã kết nối đến MySQL');
    }
});

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(express.static('public'));

app.get('/', (req, res) => {
    res.render('index');
});

app.get('/product', (req, res) => {
    const query = `
    SELECT p.id AS product_id, p.name AS product_name, p.price, p.image_url, p.quantity, p.detail, c.name AS category_name 
    FROM products p
    JOIN categories c ON p.category_id = c.id
    `;
    db.query(query, (err, results) => {
        if (err) {
            return res.status(500).send('Lỗi khi lấy dữ liệu sản phẩm');
        }
        console.log("Kết quả truy vấn:", results);
        const productsByCategory = results.reduce((acc, product) => {
            if (!acc[product.category_name]) {
                acc[product.category_name] = [];
            }
            acc[product.category_name].push(product);
            return acc;
        }, {});
        res.render('product', { productsByCategory });
    });
});

app.get('/introduce', (req, res) => {
    res.render('introduce');
});

app.get('/signin', (req, res) => {
    res.render('signin');
});

app.get('/signup', (req, res) => {
    res.render('signup');
});

app.get('/sitemap', (req, res) => {
    res.render('sitemap');
});

app.get('/cart', (req, res) => {
    const cartItems = req.session.cart || [];
    res.render('cart', { cartItems });
});

app.listen(3000, () => {
    console.log('Server chạy tại http://localhost:3000');
});

//them sp vao gio hang
app.post('/add-to-cart', (req, res) => {
    console.log("Dữ liệu nhận được từ client:", req.body);
    const { id, name, price, image_url, requestedQuantity, detail } = req.body;

    const query = `SELECT quantity FROM products WHERE id = ?`;

    db.query(query, [id], (err, results) => {
        if (err) {
            console.error("Lỗi truy vấn cơ sở dữ liệu:", err);
            return res.status(500).json({ success: false, message: "Lỗi server" });
        }
        if (results.length === 0) {
            return res.status(404).json({ success: false, message: "Sản phẩm không tồn tại" });
        }
        const stockQuantity = results[0].quantity;
        if (requestedQuantity > stockQuantity) {
            console.warn("Sản phẩm hết hàng hoặc số lượng yêu cầu vượt quá số lượng tồn kho");
            return res.status(400).json({ success: false, message: "Sản phẩm hết hàng hoặc số lượng yêu cầu vượt quá số lượng tồn kho" });
        }
        if (!req.session.cart) {
            req.session.cart = [];
            console.log("Giỏ hàng mới được tạo.");
        }
        const existingItem = req.session.cart.find(item => item.id === id);
        if (existingItem) {
            console.log("Sản phẩm đã tồn tại trong giỏ hàng.");
            if (existingItem.addQuantity + requestedQuantity > stockQuantity) {
                console.warn("Không thể thêm vì số lượng yêu cầu vượt quá số lượng tồn kho");
                return res.status(400).json({ success: false, message: "Sản phẩm hết hàng hoặc số lượng yêu cầu vượt quá số lượng tồn kho" });
            }
            existingItem.addQuantity += requestedQuantity;
            console.log("Cập nhật số lượng sản phẩm trong giỏ hàng:", existingItem.requestedQuantity);
        } else {
            req.session.cart.push({ id, name, price, image_url, quantity: stockQuantity, addQuantity: requestedQuantity, detail });
            console.log("Thêm sản phẩm mới vào giỏ hàng:", { id, name, price, image_url, quantity: stockQuantity, addQuantity: requestedQuantity });
        }
        req.session.save(err => {
            if (err) {
                console.error("Lỗi khi lưu session:", err);
                return res.status(500).json({ success: false, message: "Không thể thêm vào giỏ hàng" });
            }
            console.log("Sản phẩm đã thêm vào giỏ hàng thành công:", { id, name, price, image_url, quantity: stockQuantity, addQuantity: requestedQuantity, detail });
            res.json({ success: true, message: "Sản phẩm đã thêm vào giỏ hàng" });
        });
    });
});

//xoa sp khoi gio hang
app.post('/remove-from-cart', (req, res) => {
    const { id } = req.body;
    if (!req.session.cart) {
        return res.status(400).json({ success: false, message: "Giỏ hàng hiện đang trống" });
    }
    const itemIndex = req.session.cart.findIndex(item => item.id === id);
    if (itemIndex === -1) {
        return res.status(404).json({ success: false, message: "Sản phẩm không tồn tại trong giỏ hàng" });
    }
    req.session.cart.splice(itemIndex, 1);
    req.session.save(err => {
        if (err) {
            console.error("Lỗi khi lưu session:", err);
            return res.status(500).json({ success: false, message: "Lỗi server khi cập nhật giỏ hàng" });
        }
        console.log("Sản phẩm đã được xóa khỏi giỏ hàng:", id);
        res.json({ success: true, message: "Sản phẩm đã được xóa khỏi giỏ hàng" });
    });
});

//cap nhat so luong
app.post('/update-cart', (req, res) => {
    const { id, newQuantity } = req.body;

    if (!req.session.cart) {
        return res.status(400).json({ success: false, message: "Giỏ hàng trống." });
    }
    const item = req.session.cart.find(product => product.id === id);
    if (!item) {
        return res.status(404).json({ success: false, message: "Sản phẩm không tồn tại trong giỏ hàng." });
    }
    const query = `SELECT quantity FROM products WHERE id = ?`;
    db.query(query, [id], (err, results) => {
        if (err) {
            console.error("Lỗi truy vấn cơ sở dữ liệu:", err);
            return res.status(500).json({ success: false, message: "Lỗi server" });
        }
        const stockQuantity = results[0].quantity;
        if (newQuantity > stockQuantity) {
            return res.status(400).json({ success: false, message: "Số lượng yêu cầu vượt quá số lượng tồn kho" });
        }
        item.addQuantity = newQuantity;
        req.session.save(err => {
            if (err) {
                console.error("Lỗi khi lưu session:", err);
                return res.status(500).json({ success: false, message: "Không thể cập nhật giỏ hàng" });
            }
            res.json({ success: true, message: "Cập nhật số lượng thành công", newQuantity });
        });
    });
});

//tinh tong tien
app.get('/cart-summary', (req, res) => {
    if (!req.session.cart) {
        return res.json({ subtotal: 0, total: 0, items: [] });
    }
    const items = req.session.cart.map(item => ({
        price: item.price,
        quantity: item.addQuantity,
        total: item.price * item.addQuantity
    }));
    const subtotal = items.reduce((sum, item) => sum + item.total, 0);
    const total = subtotal;
    res.json({ subtotal, total, items });
});

//xac nhan dat hang
app.post('/checkout', (req, res) => {
    const { customerName, phoneNumber, email, shippingAddress, city, additionalInfo, cartItems, totalPrice } = req.body;
    if (!cartItems || cartItems.length === 0) {
        return res.status(400).json({ success: false, message: "Giỏ hàng rỗng, không thể tạo hóa đơn" });
    }
    db.beginTransaction((err) => {
        if (err) {
            console.error("Lỗi khi bắt đầu giao dịch:", err);
            return res.status(500).json({ success: false, message: "Lỗi khi bắt đầu giao dịch" });
        }
        const invoiceQuery = `
            INSERT INTO invoices (customer_name, phone_number, email, shipping_address, city, additional_info, total_price)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        `;
        db.query(invoiceQuery, [customerName, phoneNumber, email, shippingAddress, city, additionalInfo, totalPrice], (err, result) => {
            if (err) {
                return db.rollback(() => {
                    console.error("Lỗi khi thêm hóa đơn:", err);
                    res.status(500).json({ success: false, message: "Lỗi khi thêm hóa đơn" });
                });
            }
            const invoiceId = result.insertId; 
            let errorOccurred = false;
            cartItems.forEach((item) => {
                const { product_id, addQuantity } = item;
                const invoiceProductQuery = `
                    INSERT INTO invoice_products (invoice_id, product_id, quantity)
                    VALUES (?, ?, ?)
                `;
                db.query(invoiceProductQuery, [invoiceId, product_id, addQuantity], (err) => {
                    if (err) {
                        errorOccurred = true;
                        return db.rollback(() => {
                            console.error("Lỗi khi thêm chi tiết sản phẩm vào hóa đơn:", err);
                            res.status(500).json({ success: false, message: "Lỗi khi thêm chi tiết sản phẩm vào hóa đơn" });
                        });
                    }
                });
            });
            if (errorOccurred) return;
            cartItems.forEach((item) => {
                const { product_id, addQuantity } = item;
                const updateQuantityQuery = `
                    UPDATE products SET quantity = quantity - ? WHERE id = ? AND quantity >= ?
                `;
                db.query(updateQuantityQuery, [addQuantity, product_id, addQuantity], (err, updateResult) => {
                    if (err || updateResult.affectedRows === 0) {
                        errorOccurred = true;
                        return db.rollback(() => {
                            console.error("Lỗi khi cập nhật số lượng sản phẩm hoặc số lượng không đủ:", err);
                            res.status(400).json({ success: false, message: "Lỗi khi cập nhật số lượng sản phẩm" });
                        });
                    }
                });
            });
            if (errorOccurred) return;
            db.commit((err) => {
                if (err) {
                    console.error("Lỗi khi commit giao dịch:", err);
                    return res.status(500).json({ success: false, message: "Lỗi khi hoàn tất giao dịch" });
                }
                res.json({ success: true, message: "Thanh toán thành công" });
            });
        });
    });
});

//clear gio hang
app.post('/clear-cart', (req, res) => {
    req.session.cart = []; 

    req.session.save(err => {
        if (err) {
            console.error("Lỗi khi xóa giỏ hàng:", err);
            return res.status(500).json({ success: false, message: "Lỗi khi xóa giỏ hàng" });
        }
        res.json({ success: true, message: "Đã xóa giỏ hàng thành công" });
    });
});