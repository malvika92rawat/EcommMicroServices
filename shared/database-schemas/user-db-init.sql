-- User Service Database Schema
CREATE DATABASE IF NOT EXISTS user_db;

USE user_db;

CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'USER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample admin user (password: admin123)
-- BCrypt hash for 'admin123'
INSERT INTO users (username, email, password, role) VALUES
('admin', 'admin@ecommerce.com', '$2a$10$xqY3Z3Z3Z3Z3Z3Z3Z3Z3ZOxCxTxNxGxLxMxNxOxPxQxRxSxTxUxVx', 'ADMIN'),
('user1', 'user1@ecommerce.com', '$2a$10$xqY3Z3Z3Z3Z3Z3Z3Z3Z3ZOxCxTxNxGxLxMxNxOxPxQxRxSxTxUxVx', 'USER')
ON DUPLICATE KEY UPDATE username=username;

