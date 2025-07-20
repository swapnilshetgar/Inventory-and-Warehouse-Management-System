#  Inventory and Warehouse Management System

##  Objective
Design a SQL backend to track inventory levels across warehouses, monitor stock status, and manage stock transfers using **MySQL** and **DBeaver**.

---

##  Tools Used
- MySQL
- DBeaver (GUI for database management)

---

##  Database Schema

###  Tables
1. **Products**
   - `product_id` (Primary Key)
   - `product_name`
   - `description`
   - `reorder_level`

2. **Warehouses**
   - `warehouse_id` (Primary Key)
   - `warehouse_name`
   - `location`

3. **Suppliers**
   - `supplier_id` (Primary Key)
   - `supplier_name`
   - `contact_info`

4. **Stock**
   - `stock_id` (Primary Key)
   - `product_id` (FK)
   - `warehouse_id` (FK)
   - `quantity`
   - `last_updated`

5. **Notifications**
   - `id` (Primary Key)
   - `message`
   - `created_at`

---

##  Sample Data Insert

```sql
INSERT INTO Products (product_name, description, reorder_level) VALUES
('Laptop', 'Dell Inspiron', 5),
('Monitor', '24-inch LED', 8);

INSERT INTO Warehouses (warehouse_name, location) VALUES
('Central Warehouse', 'Mumbai'),
('East Warehouse', 'Pune');

INSERT INTO Stock (product_id, warehouse_id, quantity) VALUES
(1, 1, 15),
(2, 1, 5);
