-- Order Service Database Schema
CREATE DATABASE IF NOT EXISTS order_db;

USE order_db;

CREATE TABLE IF NOT EXISTS orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    payment_method VARCHAR(50),
    shipping_address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_product_id (product_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    CHECK (quantity > 0),
    CHECK (total_price > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample orders
INSERT INTO orders (user_id, product_id, quantity, total_price, status, payment_method, shipping_address) VALUES
(1, 1, 1, 249900.00, 'CONFIRMED', 'CREDIT_CARD', '123 Main St, Mumbai, India'),
(1, 3, 2, 59800.00, 'SHIPPED', 'DEBIT_CARD', '123 Main St, Mumbai, India'),
(2, 2, 1, 134900.00, 'DELIVERED', 'UPI', '456 Park Ave, Delhi, India')
ON DUPLICATE KEY UPDATE id=id;

