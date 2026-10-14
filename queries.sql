USE `projekt`;

-- ============================================================================
-- CZĘŚĆ A: ZAAWANSOWANE ZAPYTANIA BIZNESOWE (5 ZAPYTAŃ)
-- ============================================================================

-- Zapytanie 1: Ranking najlepszych klientów (VIP) pod względem wydanej kwoty
-- Wykorzystuje: JOIN, GROUP BY, HAVING, funkcje agregujące (COUNT, SUM, AVG)
SELECT 
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS customer_name,
    u.email,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM `users` u
INNER JOIN `orders` o ON u.user_id = o.user_id
INNER JOIN `payments` p ON o.order_id = p.order_id
WHERE p.payment_status = 'completed'
  AND o.order_status != 'cancelled'
GROUP BY u.user_id, u.first_name, u.last_name, u.email
HAVING SUM(o.total_amount) > 500.00
ORDER BY total_spent DESC;

-- Zapytanie 2: Analiza sprzedaży i przychodów według kategorii produktów kuchennych
-- Wykorzystuje: wielokrotny JOIN, GROUP BY, funkcje agregujące (SUM, COUNT)
SELECT 
    c.name AS category_name,
    COUNT(DISTINCT oi.order_id) AS orders_with_category,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.unit_price) AS category_revenue
FROM `categories` c
INNER JOIN `product_categories` pc ON c.category_id = pc.category_id
INNER JOIN `products` p ON pc.product_id = p.product_id
INNER JOIN `order_items` oi ON p.product_id = oi.product_id
INNER JOIN `orders` o ON oi.order_id = o.order_id
WHERE o.order_status IN ('paid', 'processing', 'shipped', 'delivered')
GROUP BY c.category_id, c.name
ORDER BY category_revenue DESC;

-- Zapytanie 3: Produkty premium (droższe niż średnia cena w sklepie) wraz z ich łącznym stanem magazynowym
-- Wykorzystuje: Podzapytanie skalarne (SUBQUERY), LEFT JOIN, GROUP BY, COALESCE
SELECT 
    p.sku,
    p.name AS product_name,
    p.brand,
    p.base_price,
    ROUND((SELECT AVG(base_price) FROM `products`), 2) AS store_avg_price,
    COALESCE(SUM(i.quantity), 0) AS total_available_stock
FROM `products` p
LEFT JOIN `inventory` i ON p.product_id = i.product_id
WHERE p.base_price > (SELECT AVG(base_price) FROM `products`)
GROUP BY p.product_id, p.sku, p.name, p.brand, p.base_price
ORDER BY p.base_price DESC;

-- Zapytanie 4: Raport obciążenia magazynów (wartość zgromadzonego towaru vs. wartość zrealizowanych wysyłek)
-- Wykorzystuje: Podzapytania w klauzuli FROM (Derived Tables), LEFT JOIN
SELECT 
    w.warehouse_id,
    w.name AS warehouse_name,
    w.city,
    COALESCE(stock_stat.total_units_in_stock, 0) AS units_in_stock,
    COALESCE(stock_stat.inventory_value, 0.00) AS inventory_value_pln,
    COALESCE(sales_stat.units_shipped, 0) AS units_sold_from_warehouse,
    COALESCE(sales_stat.sales_value, 0.00) AS sales_value_pln
FROM `warehouses` w
LEFT JOIN (
    SELECT 
        i.warehouse_id,
        SUM(i.quantity) AS total_units_in_stock,
        SUM(i.quantity * p.base_price) AS inventory_value
    FROM `inventory` i
    INNER JOIN `products` p ON i.product_id = p.product_id
    GROUP BY i.warehouse_id
) AS stock_stat ON w.warehouse_id = stock_stat.warehouse_id
LEFT JOIN (
    SELECT 
        oi.warehouse_id,
        SUM(oi.quantity) AS units_shipped,
        SUM(oi.quantity * oi.unit_price) AS sales_value
    FROM `order_items` oi
    GROUP BY oi.warehouse_id
) AS sales_stat ON w.warehouse_id = sales_stat.warehouse_id
ORDER BY sales_value_pln DESC;

-- Zapytanie 5: Wyszukiwanie produktów, które nigdy nie zostały jeszcze zamówione lub mają niski stan (< 15 szt.)
-- Wykorzystuje: Podzapytanie z NOT EXISTS, HAVING, funkcje agregujące
SELECT 
    p.product_id,
    p.sku,
    p.name,
    p.brand,
    COALESCE(SUM(i.quantity), 0) AS total_stock,
    CASE 
        WHEN NOT EXISTS (SELECT 1 FROM `order_items` oi WHERE oi.product_id = p.product_id) THEN 'Brak sprzedaży'
        ELSE 'Niski stan magazynowy'
    END AS alert_reason
FROM `products` p
LEFT JOIN `inventory` i ON p.product_id = i.product_id
GROUP BY p.product_id, p.sku, p.name, p.brand
HAVING COALESCE(SUM(i.quantity), 0) < 15
    OR NOT EXISTS (SELECT 1 FROM `order_items` oi WHERE oi.product_id = p.product_id);

-- Zapytanie 6: Miesięczny raport przychodów oraz dynamika sprzedaży (Trend miesięczny)
-- Pokazuje, jak sklep rozwijał się od maja do października 2026 r.
SELECT 
    DATE_FORMAT(o.created_at, '%Y-%m') AS sale_month,
    COUNT(DISTINCT o.order_id) AS orders_count,
    SUM(oi.quantity) AS total_items_sold,
    SUM(oi.quantity * oi.unit_price) AS monthly_revenue_pln,
    ROUND(AVG(o.total_amount), 2) AS avg_basket_value
FROM `orders` o
INNER JOIN `order_items` oi ON o.order_id = oi.order_id
WHERE o.order_status NOT IN ('cancelled', 'pending')
GROUP BY DATE_FORMAT(o.created_at, '%Y-%m')
ORDER BY sale_month ASC;

-- Zapytanie 7: Analiza logistyczna "Split Shipments" – zamówienia kompletowane z więcej niż jednego magazynu
-- Wykrywa zamówienia, które generują wyższe koszty wysyłki (paczki szły z różnych miast)
SELECT 
    o.order_id,
    CONCAT(u.first_name, ' ', u.last_name) AS customer,
    o.total_amount,
    COUNT(DISTINCT oi.warehouse_id) AS warehouses_involved,
    GROUP_CONCAT(DISTINCT w.city ORDER BY w.city SEPARATOR ' + ') AS shipping_cities,
    (SELECT COUNT(*) FROM `shipments` s WHERE s.order_id = o.order_id) AS packages_sent
FROM `orders` o
INNER JOIN `users` u ON o.user_id = u.user_id
INNER JOIN `order_items` oi ON o.order_id = oi.order_id
INNER JOIN `warehouses` w ON oi.warehouse_id = w.warehouse_id
GROUP BY o.order_id, u.first_name, u.last_name, o.total_amount
HAVING COUNT(DISTINCT oi.warehouse_id) > 1
ORDER BY warehouses_involved DESC, o.total_amount DESC;

-- Zapytanie 8: Skuteczność metod płatności (Conversion & Failure Rate)
-- Wykorzystuje agregację warunkową (SUM + CASE WHEN) do policzenia odsetka odrzuconych płatności
SELECT 
    p.payment_method,
    COUNT(*) AS total_attempts,
    SUM(CASE WHEN p.payment_status = 'completed' THEN 1 ELSE 0 END) AS successful_payments,
    SUM(CASE WHEN p.payment_status = 'failed' THEN 1 ELSE 0 END) AS failed_payments,
    SUM(CASE WHEN p.payment_status = 'refunded' THEN 1 ELSE 0 END) AS refunded_payments,
    ROUND(SUM(CASE WHEN p.payment_status = 'completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS success_rate_pct,
    SUM(CASE WHEN p.payment_status = 'completed' THEN p.amount ELSE 0.00 END) AS collected_revenue
FROM `payments` p
GROUP BY p.payment_method
ORDER BY collected_revenue DESC;

-- Zapytanie 9: Pełne drzewo kategorii (Relacja rekurencyjna / Self-Join) wraz z liczbą produktów i średnią ceną
SELECT 
    COALESCE(parent.name, '--- Kategoria Główna ---') AS parent_category,
    child.name AS category_name,
    COUNT(DISTINCT pc.product_id) AS products_count,
    COALESCE(ROUND(AVG(pr.base_price), 2), 0.00) AS avg_product_price
FROM `categories` child
LEFT JOIN `categories` parent ON child.parent_id = parent.category_id
LEFT JOIN `product_categories` pc ON child.category_id = pc.category_id
LEFT JOIN `products` pr ON pc.product_id = pr.product_id
GROUP BY parent.name, child.category_id, child.name
ORDER BY parent_category, child.name;


-- ============================================================================
-- CZĘŚĆ B: WYZWALACZE (TRIGGERS)
-- ============================================================================

DELIMITER $$

-- Trigger 1: Przed dodaniem pozycji zamówienia sprawdza dostępność w magazynie
-- oraz automatycznie pobiera aktualną cenę katalogową produktu, jeśli podano 0
CREATE TRIGGER `trg_before_order_item_insert`
BEFORE INSERT ON `order_items`
FOR EACH ROW
BEGIN
    DECLARE v_available_qty INT DEFAULT 0;
    DECLARE v_catalog_price DECIMAL(10, 2);

    -- Sprawdzenie dostępnej ilości w wybranym magazynie
    SELECT `quantity` INTO v_available_qty
    FROM `inventory`
    WHERE `warehouse_id` = NEW.warehouse_id
      AND `product_id` = NEW.product_id;

    IF v_available_qty IS NULL OR v_available_qty < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Błąd: Niewystarczająca ilość produktu w wybranym magazynie!';
    END IF;

    -- Jeśli cena jednostkowa = 0, ustaw cenę katalogową z tabeli products
    IF NEW.unit_price = 0 THEN
        SELECT `base_price` INTO v_catalog_price
        FROM `products`
        WHERE `product_id` = NEW.product_id;
        SET NEW.unit_price = v_catalog_price;
    END IF;
END$$

-- Trigger 2: Po dodaniu pozycji zamówienia automatycznie zmniejsza stan magazynowy
-- oraz aktualizuje łączną kwotę zamówienia (total_amount) w tabeli orders
CREATE TRIGGER `trg_after_order_item_insert`
AFTER INSERT ON `order_items`
FOR EACH ROW
BEGIN
    -- Pomniejszenie stanu magazynowego
    UPDATE `inventory`
    SET `quantity` = `quantity` - NEW.quantity
    WHERE `warehouse_id` = NEW.warehouse_id
      AND `product_id` = NEW.product_id;

    -- Przeliczenie wartości zamówienia
    UPDATE `orders`
    SET `total_amount` = (
        SELECT COALESCE(SUM(`quantity` * `unit_price`), 0.00)
        FROM `order_items`
        WHERE `order_id` = NEW.order_id
    )
    WHERE `order_id` = NEW.order_id;
END$$  DELIMITER ;   -- ============================================================================ -- CZĘŚĆ C: PROCEDURA SKŁADOWANA (STORED PROCEDURE) -- ============================================================================  DELIMITER $$

-- Procedura składania nowego zamówienia na artykuł kuchenny wraz z obsługą transakcyjną
CREATE PROCEDURE `sp_place_single_product_order`(
    IN p_user_id BIGINT UNSIGNED,
    IN p_shipping_address_id BIGINT UNSIGNED,
    IN p_billing_address_id BIGINT UNSIGNED,
    IN p_product_id BIGINT UNSIGNED,
    IN p_warehouse_id INT UNSIGNED,
    IN p_quantity INT UNSIGNED,
    IN p_payment_method ENUM('credit_card', 'paypal', 'bank_transfer', 'stripe', 'blik'),
    OUT p_new_order_id BIGINT UNSIGNED
)
BEGIN
    DECLARE v_unit_price DECIMAL(10, 2);
    DECLARE v_total DECIMAL(10, 2);

    -- Obsługa błędów SQL: wycofanie transakcji w razie jakiegokolwiek wyjątku
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    -- Pobranie ceny produktu
    SELECT `base_price` INTO v_unit_price
    FROM `products`
    WHERE `product_id` = p_product_id AND `is_active` = 1
     FOR UPDATE;

    IF v_unit_price IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Błąd: Produkt nie istnieje lub jest nieaktywny.';
    END IF;

    SET v_total = v_unit_price * p_quantity;

    -- 1. Utworzenie nagłówka zamówienia
    INSERT INTO `orders` (`user_id`, `shipping_address_id`, `billing_address_id`, `order_status`, `total_amount`)
    VALUES (p_user_id, p_shipping_address_id, p_billing_address_id, 'pending', 0.00);

    SET p_new_order_id = LAST_INSERT_ID();

    -- 2. Dodanie pozycji zamówienia (uruchamia triggery sprawdzające i zmniejszające stan magazynowy)
    INSERT INTO `order_items` (`order_id`, `product_id`, `warehouse_id`, `quantity`, `unit_price`)
    VALUES (p_new_order_id, p_product_id, p_warehouse_id, p_quantity, v_unit_price);

    -- 3. Inicjacja płatności
    INSERT INTO `payments` (`order_id`, `payment_method`, `transaction_reference`, `amount`, `payment_status`)
    VALUES (
        p_new_order_id,
        p_payment_method,
        CONCAT('TXN-AUTO-', p_new_order_id, '-', UNIX_TIMESTAMP()),
        v_total,
        'initiated'
    );

    COMMIT;
END$$

DELIMITER ;


-- ============================================================================
-- CZĘŚĆ D: DEMONSTRACJA TRANSAKCJI (COMMIT ORAZ ROLLBACK)
-- ============================================================================

-- Scenariusz 1: Pomyślne wywołanie procedury (zatwierdzone przez COMMIT wewnątrz procedury)
CALL `sp_place_single_product_order`(4, 4, 4, 1, 1, 2, 'blik', @utworzone_zamowienie);
SELECT @utworzone_zamowienie AS nowe_id_zamowienia;

-- Scenariusz 2: Jawna transakcja zakończona ROLLBACK (np. anulowanie zamówienia i wycofanie operacji)
START TRANSACTION;

    -- Aktualizacja statusu płatności i zamówienia
    UPDATE `payments`
    SET `payment_status` = 'completed', `paid_at` = NOW()
    WHERE `order_id` = 5;

    UPDATE `orders`
    SET `order_status` = 'paid'
    WHERE `order_id` = 5;

    -- Symulacja wykrycia błędu weryfikacji płatności -> wycofujemy wszystkie zmiany
ROLLBACK;

-- Scenariusz 3: Jawna transakcja zakończona COMMIT (zaksięgowanie wpłaty i utworzenie listu przewozowego)
START TRANSACTION;

    UPDATE `payments`
    SET `payment_status` = 'completed', `paid_at` = NOW()
    WHERE `order_id` = 5;

    UPDATE `orders`
    SET `order_status` = 'paid'
    WHERE `order_id` = 5;

    INSERT INTO `shipments` (`order_id`, `carrier`, `tracking_number`, `shipment_status`)
    VALUES (5, 'InPost Paczkomaty', 'INP-20261014-5555', 'label_created');

COMMIT;
