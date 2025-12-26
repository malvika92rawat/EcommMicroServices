-- Product Service Database Schema
CREATE DATABASE IF NOT EXISTS product_db;

USE product_db;

CREATE TABLE IF NOT EXISTS products (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    category VARCHAR(100),
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_name (name),
    CHECK (price > 0),
    CHECK (stock >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample products
INSERT INTO products (name, description, price, stock, category, image_url) VALUES
('MacBook Pro 16"', 'Apple MacBook Pro with M3 chip, 16GB RAM, 512GB SSD', 249900.00, 50, 'Electronics', 'https://example.com/macbook.jpg'),
('iPhone 15 Pro', 'Apple iPhone 15 Pro with 256GB storage', 134900.00, 100, 'Electronics', 'https://example.com/iphone.jpg'),
('Sony WH-1000XM5', 'Wireless Noise-Cancelling Headphones', 29900.00, 75, 'Electronics', 'https://example.com/headphones.jpg'),
('Samsung Galaxy S24', 'Samsung flagship smartphone with 256GB', 89900.00, 80, 'Electronics', 'https://example.com/galaxy.jpg'),
('Dell XPS 15', 'Dell XPS 15 Laptop, Intel i7, 16GB RAM, 1TB SSD', 159900.00, 40, 'Electronics', 'https://example.com/dell.jpg'),
('iPad Air', 'Apple iPad Air with M2 chip, 256GB', 74900.00, 60, 'Electronics', 'https://example.com/ipad.jpg'),
('AirPods Pro', 'Apple AirPods Pro with Active Noise Cancellation', 24900.00, 120, 'Electronics', 'https://example.com/airpods.jpg'),
('Canon EOS R6', 'Canon EOS R6 Mirrorless Camera', 224900.00, 25, 'Cameras', 'https://example.com/canon.jpg'),
('LG OLED TV 55"', 'LG 55-inch 4K OLED Smart TV', 149900.00, 30, 'Electronics', 'https://example.com/tv.jpg'),
('Logitech MX Master 3', 'Wireless Mouse for Professionals', 8900.00, 150, 'Accessories', 'https://example.com/mouse.jpg')
ON DUPLICATE KEY UPDATE name=name;

