# WEB
môi trường cần có : NodeJS
down cái của nợ này ở đây → https://nodejs.org/en 

hoặc check xem có NodeJS trong máy không

mở terminal và chạy cái của nợ này ↓

![image](https://github.com/user-attachments/assets/c78efff5-0e14-4daf-9d1c-094b1b543bae)

![image](https://github.com/user-attachments/assets/26b54a07-3f2c-4808-b293-68d444ececdb)

Dùng Visual Studio Code mở project lên ở thư mục gốc

mở terminal và chạy cái của nợ nàyyyyy ↓

npm install express mysql2 express-session body-parser dotenv ejs

nếu mà đéo chạy được thì tự npm install từng cái nhé =))

![image](https://github.com/user-attachments/assets/0dc3c0d1-9fb9-4d8d-8f43-878e3b9f84e1)

tiếp tục với cái của nợ này ↓ (cái chóa này để auto reload sever, lâu lâu vẫn crash như thường)

nếu báo crash thì → "Ctrl + C" 2 lần kill nó rồi chạy lại npm start / nodemon app.js

npm install -g nodemon

otey tiếp tục thì copy script này vào file package.json ↓

"scripts": {
  "start": "node app.js",
  "dev": "nodemon app.js"
}
![image](https://github.com/user-attachments/assets/8b5ca4ec-dbd4-4ada-b977-49c8415e1940)

mở file .env lên và cấu hình môi trường : (ở đây dùng MySQL port 3306)

SECRET_KEY = "thích gì đặt đó" (vì không dùng aws cloud nên vô tư)

![image](https://github.com/user-attachments/assets/5d87d0c1-a18d-4ecc-8b05-c64a32af874e)

setup xong thì chứ phang nodemon app.js mà giã

chúc vui với cái web lỏ này.

