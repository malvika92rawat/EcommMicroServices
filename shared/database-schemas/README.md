# Database Schemas

This directory contains the initialization SQL scripts for each microservice database.

## Database per Service Pattern

Following microservices best practices, each service has its own dedicated database:

### 1. User Database (`user_db`)
- **Service**: User Service
- **Port**: 3306 (user-mysql container)
- **Tables**: users
- **Purpose**: Store user authentication and profile information

### 2. Product Database (`product_db`)
- **Service**: Product Service
- **Port**: 3307 (product-mysql container)
- **Tables**: products
- **Purpose**: Manage product catalog and inventory

### 3. Order Database (`order_db`)
- **Service**: Order Service
- **Port**: 3308 (order-mysql container)
- **Tables**: orders
- **Purpose**: Handle order processing and tracking

## Schema Design Principles

1. **Isolation**: Each database is completely isolated from others
2. **Independence**: Services can evolve their schemas independently
3. **Scalability**: Each database can be scaled separately based on load
4. **Data Consistency**: Managed through service-to-service communication

## Initial Data

Each schema includes sample data for learning and testing purposes:
- Sample users with different roles (admin, user)
- Sample products across different categories
- Sample orders in different states

## Usage

These scripts are automatically executed when the MySQL containers start via Docker Compose.

