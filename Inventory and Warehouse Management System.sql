-- Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    reorder_level INT DEFAULT 10
);

-- Warehouses Table
CREATE TABLE Warehouses (
    warehouse_id INT PRIMARY KEY AUTO_INCREMENT,
    warehouse_name VARCHAR(100),
    location VARCHAR(100)
);

-- Suppliers Table
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100),
    contact_info VARCHAR(100)
);

-- Stock Table
CREATE TABLE Stock (
    stock_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    warehouse_id INT,
    quantity INT DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id)
);



-- Insert Sample Data

INSERT INTO Products (product_name, description, reorder_level) VALUES
('Laptop', 'Dell Inspiron', 5),
('Monitor', '24-inch LED', 8);

INSERT INTO Warehouses (warehouse_name, location) VALUES
('Central Warehouse', 'Mumbai'),
('East Warehouse', 'Pune');

INSERT INTO Stock (product_id, warehouse_id, quantity) VALUES
(1, 1, 15),
(2, 1, 5);




-- Check Stock Levels and Reorder Alerts



SELECT 
    p.product_name,
    w.warehouse_name,
    s.quantity,
    p.reorder_level,
    CASE 
        WHEN s.quantity < p.reorder_level THEN 'Reorder Needed'
        ELSE 'Stock Sufficient'
    END AS status
FROM Stock s
JOIN Products p ON s.product_id = p.product_id
JOIN Warehouses w ON s.warehouse_id = w.warehouse_id;





-- Trigger for Low-Stock Notification


DELIMITER $$

CREATE TRIGGER low_stock_alert
AFTER UPDATE ON Stock
FOR EACH ROW
BEGIN
    IF NEW.quantity < (SELECT reorder_level FROM Products WHERE product_id = NEW.product_id) THEN
        INSERT INTO Notifications (message, created_at)
        VALUES (CONCAT('Low stock alert for product ID: ', NEW.product_id), NOW());
    END IF;
END$$

DELIMITER ;



-- Create Notifications table first:



CREATE TABLE Notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);





-- Stored Procedure to Transfer Stock


DELIMITER $$

CREATE PROCEDURE TransferStock(
    IN productId INT,
    IN fromWarehouse INT,
    IN toWarehouse INT,
    IN transferQty INT
)
BEGIN
    START TRANSACTION;
    
    UPDATE Stock
    SET quantity = quantity - transferQty
    WHERE product_id = productId AND warehouse_id = fromWarehouse;
    
    INSERT INTO Stock (product_id, warehouse_id, quantity)
    VALUES (productId, toWarehouse, transferQty)
    ON DUPLICATE KEY UPDATE quantity = quantity + transferQty;
    
    COMMIT;
END$$

DELIMITER ;
