-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.32-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for shopdongho
CREATE DATABASE IF NOT EXISTS `shopdongho` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `shopdongho`;

-- Dumping structure for table shopdongho.categories
CREATE TABLE IF NOT EXISTS `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table shopdongho.categories: ~3 rows (approximately)
REPLACE INTO `categories` (`id`, `name`) VALUES
	(1, 'For men'),
	(2, 'For women'),
	(3, 'For kid');

-- Dumping structure for table shopdongho.invoices
CREATE TABLE IF NOT EXISTS `invoices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_name` varchar(255) NOT NULL,
  `phone_number` varchar(20) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `shipping_address` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `additional_info` text DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `total_price` decimal(10,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `invoices_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table shopdongho.invoices: ~0 rows (approximately)

-- Dumping structure for table shopdongho.invoice_products
CREATE TABLE IF NOT EXISTS `invoice_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoice_id` (`invoice_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `invoice_products_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`),
  CONSTRAINT `invoice_products_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table shopdongho.invoice_products: ~0 rows (approximately)

-- Dumping structure for table shopdongho.products
CREATE TABLE IF NOT EXISTS `products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `quantity` int(11) DEFAULT 0,
  `detail` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dumping data for table shopdongho.products: ~28 rows (approximately)
REPLACE INTO `products` (`id`, `category_id`, `name`, `price`, `image_url`, `quantity`, `detail`) VALUES
	(1, 1, 'Casio MTP-1302D-7A1VDF', 1300000.00, '../img/product/p1.webp', 20, 'Casio MTP-1302D-7A1VDF – Nam – Quartz (Pin) – Mặt Số 38.5mm, Viền Khía, Chống Nước 5ATM'),
	(2, 1, 'Casio AE-1200WHD-1AVDF', 1300000.00, '../img/product/p2.webp', 20, 'Casio World Time AE-1200WHD-1AVDF – Nam – Quartz (Pin) – Mặt số thiên hướng không quân đương đại – Dây đeo kim loại bền bỉ'),
	(3, 1, 'G-Shock GBA-800-9ADR', 4220000.00, '../img/product/p3.webp', 20, 'G-Shock G-SQUAD GBA-800-9ADR – Nam – Quartz (Pin) – Mặt Số 48.6mm, Bộ Bấm Giờ, Chống Nước 20ATM'),
	(4, 1, 'Casio W-215H-7A2VDF', 716000.00, '../img/product/p4.webp', 20, 'Casio W-215H-7A2VDF – Nam – Kính Nhựa – Quartz (Pin) – Dây Cao Su'),
	(5, 1, 'Casio AE-1000W-4BVDF', 987000.00, '../img/product/p5.webp', 20, 'Casio AE-1000W-4BVDF – Nam – Kính Nhựa – Quartz (Pin) – Mặt Số 43.7mm, Bộ Bấm Giờ, Chống Nước 10ATM'),
	(6, 1, 'Casio AE-1200WH-1BVDF', 1086000.00, '../img/product/p6.webp', 20, 'Casio AE-1200WH-1BVDF – Nam – Kính Nhựa – Quartz (Pin) – Mặt Số 45mm, Chống Nước 10ATM, Giờ Thế Giới'),
	(7, 1, 'Casio EFV-550D-1AVUDF', 3529000.00, '../img/product/p7.webp', 20, 'Casio EFV-550D-1AVUDF – Nam – Quartz (Pin) – Mặt Số 47mm, Chronograph, Chống Nước 10ATM'),
	(8, 1, 'Casio MCW-100H-9A2VDF', 2222000.00, '../img/product/p8.webp', 20, 'Casio MCW-100H-9A2VDF – Nam – Kính Nhựa – Quartz (Pin) – Mặt Số 49.3mm, Chronograph, Chống Nước 10ATM'),
	(9, 1, 'Casio EFV-540D-2AVUDFF', 3500000.00, '../img/product/p9.webp', 20, 'Casio Edifice EFV-540D-2AVUDF – Nam – Quartz (Pin) – Mặt Số 43.8 mm, Chronograph, Chống Nước 10 ATM'),
	(10, 1, 'Casio–Quartz', 1086000.00, '../img/product/p10.webp', 20, 'Casio Quartz MTP-E149L-2BVDF với thiết kế mặt xanh lịch lãm, dây da cao cấp, bộ máy Quartz bền bỉ, chống nước 3 ATM, phù hợp cho mọi dịp'),
	(11, 1, 'Casio ETD-310D-9AVUDF', 7540000.00, '../img/product/p11.webp', 20, 'Casio ETD-310D-9AVUDF – Nam – Quartz (Pin) – Dây Kim Loại'),
	(12, 1, 'Casio MTP-V300G-1AUDF', 2050000.00, '../img/product/p12.webp', 20, 'Casio MTP-V300G-1AUDF – Nam – Quartz (Pin) – Mặt Số 40mm, Kính Cứng, Chống Nước 3ATM'),
	(13, 2, 'Fouetté OR-FAIRY I Sapphire', 25500000.00, '../img/product/p13.webp', 20, 'Fouetté OR-FAIRY I – Nữ – Kính Sapphire – Quartz (Pin) – Mặt Số 38mm, Máy Ronda Thụy Sỹ, Limited Edition'),
	(14, 2, 'Baby-G BGD-560-4DR', 2920000.00, '../img/product/p14.webp', 20, 'Baby-G BGD-560-4DR – Nữ – Quartz (Pin) – Dây Cao Su'),
	(15, 2, 'Daniel Wellington DW00100319', 3000000.00, '../img/product/p15.webp', 20, 'Daniel Wellington DW00100319 – Nữ – Quartz (Pin) – Dây Vải – Mặt Số 28mm'),
	(16, 2, 'Michael Kors', 7000000.00, '../img/product/p16.webp', 20, 'Đồng hồ Michael Kors thiết kế thời thượng, mặt số đính đá tinh xảo, dây kim loại màu vàng hồng sang trọng, bộ máy Quartz, phù hợp cho các quý cô yêu thích phong cách đẳng cấp'),
	(17, 2, 'Casio LRW-200H-1EVDF', 800000.00, '../img/product/p17.webp', 20, 'Casio LRW-200H-1EVDF – Nữ – Kính Nhựa – Quartz (Pin) – Dây Cao Su'),
	(18, 2, 'Citizen EW9822-83D', 8200000.00, '../img/product/p18.webp', 20, 'Citizen EW9822-83D – Nữ – Eco-Drive (Năng Lượng Ánh Sáng) – Dây Kim Loại'),
	(19, 2, 'Daniel Wellington DW00100515', 4000000.00, '../img/product/p19.webp', 20, 'Daniel Wellington MOP Classic Petite Special Edition (DW00100515) – Nữ – Quartz (Pin) – Mặt Số 32mm, Siêu Mỏng 6mm, Mặt Xà Cừ'),
	(20, 2, 'Seiko SUP427P1', 9090000.00, '../img/product/p20.webp', 20, 'Seiko SUP427P1 – Nữ – Solar (Năng Lượng Ánh Sáng) – Dây Kim Loại – Mặt Số 25mm'),
	(21, 2, 'Casio SHE-4538GL-7BUDF', 3970000.00, '../img/product/p21.webp', 20, 'Casio SHE-4538GL-7BUDF – Nữ – Kính Sapphire – Quartz (Pin) – Dây Da – Mặt Số 21mm'),
	(22, 2, 'Casio LRW-200H-2E2VDR', 815000.00, '../img/product/p22.webp', 20, 'Casio LRW-200H-2E2VDR – Nữ – Kính Nhựa – Quartz (Pin) – Dây Cao Su – Mặt Số 32mm'),
	(23, 2, 'Daniel Wellington DW00100415', 6600000.00, '../img/product/p23.webp', 20, 'Daniel Wellington Iconic Link DW00100415 – Nữ – Quartz (Pin) – Mặt Số 28mm, Kính Cứng, Chống Nước 3ATM'),
	(24, 2, 'Fossil ES4535', 3940000.00, '../img/product/p24.webp', 20, 'Fossil ES4535 – Nữ – Quartz (Pin) – Mặt Số 36mm, Khảm Xà Cừ, Đính Đá'),
	(25, 3, 'SMILE KID 44 mm', 200000.00, '../img/product/p25.jpg', 20, 'Đồng hồ SMILE KID 44 mm, thiết kế đơn giản, màu sắc tươi sáng, kích thước phù hợp cho trẻ em, nhẹ nhàng và thoải mái khi đeo'),
	(26, 3, 'SMILE KID SL090-02', 175000.00, '../img/product/p26.jpg', 20, 'Đồng hồ trẻ em SMILE KID SL090-02 màu trắng chủ đạo, trang trí hình thú dễ thương, đường kính 39x43mm, dây nhựa PU nhẹ, khung nhựa ABS bền chắc, kháng nước 5 ATM'),
	(27, 3, 'SMILE KID SL219LM-2', 160000.00, '../img/product/p27.jpg', 20, 'Đồng hồ trẻ em thiết kế năng động, phối màu xanh dương-vàng ấn tượng, mặt kính Acrylic 39mm bền bỉ, khung nhựa cứng, dây cao su mềm đàn hồi tốt, kháng nước 5 ATM'),
	(28, 3, 'SKMEI SK-1095', 100000.00, '../img/product/p28.jpg', 20, 'Đồng hồ điện tử trẻ em SKMEI digital, đường kính 42mm, mặt kính nhựa Resin, dây cao su 18.3mm, khung nhựa PC, độ dày 16.9mm, pin sử dụng khoảng 1 năm,');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
