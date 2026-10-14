CREATE DATABASE IF NOT EXISTS `projekt`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_520_ci;

USE `projekt`;

-- 1. Tabela użytkowników
CREATE TABLE `users` (
    `user_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `email` VARCHAR(255) NOT NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `first_name` VARCHAR(100) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    `phone` VARCHAR(30) NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`user_id`),
    UNIQUE KEY `uq_users_email` (`email`)
) ENGINE=InnoDB;

-- 2. Tabela sesji użytkowników
CREATE TABLE `user_sessions` (
    `session_id` VARCHAR(128) NOT NULL,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `ip_address` VARCHAR(45) NULL,
    `user_agent` VARCHAR(512) NULL,
    `is_revoked` TINYINT(1) NOT NULL DEFAULT 0,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_active_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `expires_at` TIMESTAMP NOT NULL,
    PRIMARY KEY (`session_id`),
    KEY `idx_sessions_user_id` (`user_id`),
    KEY `idx_sessions_expires_at` (`expires_at`),
    CONSTRAINT `chk_sessions_revoked` CHECK (`is_revoked` IN (0, 1)),
    CONSTRAINT `fk_sessions_user` FOREIGN KEY (`user_id`) 
        REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 3. Tabela adresów
CREATE TABLE `addresses` (
    `address_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `recipient_name` VARCHAR(150) NOT NULL,
    `street_line1` VARCHAR(255) NOT NULL,
    `street_line2` VARCHAR(255) NULL,
    `city` VARCHAR(100) NOT NULL,
    `state_province` VARCHAR(100) NOT NULL,
    `postal_code` VARCHAR(20) NOT NULL,
    `country_code` CHAR(2) NOT NULL DEFAULT 'PL',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`address_id`),
    KEY `idx_addresses_user_id` (`user_id`),
    CONSTRAINT `fk_addresses_user` FOREIGN KEY (`user_id`) 
        REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 4. Tabela kategorii (hierarchiczna)
CREATE TABLE `categories` (
    `category_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `parent_id` INT UNSIGNED NULL,
    `name` VARCHAR(100) NOT NULL,
    `slug` VARCHAR(120) NOT NULL,
    PRIMARY KEY (`category_id`),
    UNIQUE KEY `uq_categories_slug` (`slug`),
    KEY `idx_categories_parent` (`parent_id`),
    CONSTRAINT `fk_categories_parent` FOREIGN KEY (`parent_id`) 
        REFERENCES `categories` (`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 5. Tabela produktów (zasoby i akcesoria kuchenne)
CREATE TABLE `products` (
    `product_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `sku` VARCHAR(64) NOT NULL,
    `name` VARCHAR(200) NOT NULL,
    `brand` VARCHAR(100) NOT NULL,
    `material` VARCHAR(100) NULL,
    `description` TEXT NULL,
    `base_price` DECIMAL(10, 2) NOT NULL,
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`product_id`),
    UNIQUE KEY `uq_products_sku` (`sku`),
    KEY `idx_products_name` (`name`),
    KEY `idx_products_brand` (`brand`),
    CONSTRAINT `chk_products_price` CHECK (`base_price` > 0),
    CONSTRAINT `chk_products_active` CHECK (`is_active` IN (0, 1))
) ENGINE=InnoDB;

-- 6. Tabela łącząca produkty z kategoriami (N:M)
CREATE TABLE `product_categories` (
    `product_id` BIGINT UNSIGNED NOT NULL,
    `category_id` INT UNSIGNED NOT NULL,
    PRIMARY KEY (`product_id`, `category_id`),
    CONSTRAINT `fk_pc_product` FOREIGN KEY (`product_id`) 
        REFERENCES `products` (`product_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_pc_category` FOREIGN KEY (`category_id`) 
        REFERENCES `categories` (`category_id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 7. Tabela magazynów
CREATE TABLE `warehouses` (
    `warehouse_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `street_line1` VARCHAR(255) NOT NULL,
    `city` VARCHAR(100) NOT NULL,
    `postal_code` VARCHAR(20) NOT NULL,
    `country_code` CHAR(2) NOT NULL DEFAULT 'PL',
    `is_active` TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (`warehouse_id`),
    CONSTRAINT `chk_warehouses_active` CHECK (`is_active` IN (0, 1))
) ENGINE=InnoDB;

-- 8. Tabela stanów magazynowych
CREATE TABLE `inventory` (
    `warehouse_id` INT UNSIGNED NOT NULL,
    `product_id` BIGINT UNSIGNED NOT NULL,
    `quantity` INT NOT NULL DEFAULT 0,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`warehouse_id`, `product_id`),
    CONSTRAINT `chk_inventory_quantity` CHECK (`quantity` >= 0),
    CONSTRAINT `fk_inv_warehouse` FOREIGN KEY (`warehouse_id`) 
        REFERENCES `warehouses` (`warehouse_id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_inv_product` FOREIGN KEY (`product_id`) 
        REFERENCES `products` (`product_id`) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 9. Tabela zamówień
CREATE TABLE `orders` (
    `order_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `shipping_address_id` BIGINT UNSIGNED NOT NULL,
    `billing_address_id` BIGINT UNSIGNED NOT NULL,
    `order_status` ENUM('pending', 'paid', 'processing', 'shipped', 'delivered', 'cancelled') NOT NULL DEFAULT 'pending',
    `total_amount` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`order_id`),
    KEY `idx_orders_user` (`user_id`),
    KEY `idx_orders_status` (`order_status`),
    KEY `idx_orders_created_at` (`created_at`),
    CONSTRAINT `chk_orders_total` CHECK (`total_amount` >= 0),
    CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) 
        REFERENCES `users` (`user_id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_orders_shipping_addr` FOREIGN KEY (`shipping_address_id`) 
        REFERENCES `addresses` (`address_id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_orders_billing_addr` FOREIGN KEY (`billing_address_id`) 
        REFERENCES `addresses` (`address_id`) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 10. Tabela pozycji zamówienia
CREATE TABLE `order_items` (
    `order_item_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `order_id` BIGINT UNSIGNED NOT NULL,
    `product_id` BIGINT UNSIGNED NOT NULL,
    `warehouse_id` INT UNSIGNED NOT NULL,
    `quantity` INT UNSIGNED NOT NULL,
    `unit_price` DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (`order_item_id`),
    UNIQUE KEY `uq_order_product_wh` (`order_id`, `product_id`, `warehouse_id`),
    CONSTRAINT `chk_items_quantity` CHECK (`quantity` > 0),
    CONSTRAINT `chk_items_unit_price` CHECK (`unit_price` >= 0),
    CONSTRAINT `fk_items_order` FOREIGN KEY (`order_id`) 
        REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_items_product` FOREIGN KEY (`product_id`) 
        REFERENCES `products` (`product_id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_items_warehouse` FOREIGN KEY (`warehouse_id`) 
        REFERENCES `warehouses` (`warehouse_id`) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 11. Tabela płatności
CREATE TABLE `payments` (
    `payment_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `order_id` BIGINT UNSIGNED NOT NULL,
    `payment_method` ENUM('credit_card', 'paypal', 'bank_transfer', 'stripe', 'blik') NOT NULL,
    `transaction_reference` VARCHAR(255) NOT NULL,
    `amount` DECIMAL(10, 2) NOT NULL,
    `payment_status` ENUM('initiated', 'completed', 'failed', 'refunded') NOT NULL DEFAULT 'initiated',
    `paid_at` TIMESTAMP NULL,
    PRIMARY KEY (`payment_id`),
    UNIQUE KEY `uq_transaction_ref` (`transaction_reference`),
    KEY `idx_payments_order` (`order_id`),
    CONSTRAINT `chk_payments_amount` CHECK (`amount` > 0),
    CONSTRAINT `fk_payments_order` FOREIGN KEY (`order_id`) 
        REFERENCES `orders` (`order_id`) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 12. Tabela przesyłek
CREATE TABLE `shipments` (
    `shipment_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `order_id` BIGINT UNSIGNED NOT NULL,
    `carrier` VARCHAR(100) NOT NULL,
    `tracking_number` VARCHAR(150) NULL,
    `shipment_status` ENUM('label_created', 'in_transit', 'out_for_delivery', 'delivered') NOT NULL DEFAULT 'label_created',
    `shipped_at` TIMESTAMP NULL,
    `delivered_at` TIMESTAMP NULL,
    PRIMARY KEY (`shipment_id`),
    UNIQUE KEY `uq_shipments_tracking` (`tracking_number`),
    KEY `idx_shipments_order` (`order_id`),
    CONSTRAINT `fk_shipments_order` FOREIGN KEY (`order_id`) 
        REFERENCES `orders` (`order_id`) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Widok raportowy prezentujący pełny stan magazynowy produktów kuchennych
CREATE OR REPLACE VIEW `v_product_stock_summary` AS
SELECT 
    p.product_id,
    p.sku,
    p.name AS product_name,
    p.brand,
    p.material,
    p.base_price,
    COALESCE(SUM(i.quantity), 0) AS total_stock,
    COUNT(DISTINCT i.warehouse_id) AS warehouses_count
FROM `products` p
LEFT JOIN `inventory` i ON p.product_id = i.product_id
GROUP BY p.product_id, p.sku, p.name, p.brand, p.material, p.base_price;
