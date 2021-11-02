-- 0. Get all the users
SELECT * FROM customers;
-- above is an example

-- BASE MODE

-- 1. Get all customers and their addresses.
SELECT * FROM "customers" 
JOIN "addresses" ON "addresses"."customer_id" = "customers"."id";

-- 2. Get all orders and their line items (orders, quantity and product).
SELECT * FROM "orders"
JOIN "line_items" ON "line_items"."order_id" = "orders"."id";
ORDER BY "orders"."id"; -- The last line is to ensure that the orders stay together

-- But if we also wanted to see the names of the procudcts, we should do:
SELECT * FROM "orders"
JOIN "line_items" ON "line_items"."order_id" = "orders"."id"
JOIN "products" ON "line_items"."product_id" = "products"."id"
ORDER BY "orders"."id";

-- 3. Which warehouses have cheetos?
SELECT "warehouse"."warehouse" FROM "warehouse_product" -- This will only show the warehouse name; else use * or select col names
JOIN "warehouse" ON "warehouse_product"."warehouse_id" = "warehouse"."id"
JOIN "products" ON "warehouse_product"."product_id" = "products"."id"
WHERE "products"."description" = 'cheetos'
ORDER BY "warehouse"."id";

-- 4. Which warehouses have diet pepsi?
SELECT "warehouse"."warehouse" FROM "warehouse_product" -- This will only show the warehouse name; else use * or select col names
JOIN "warehouse" ON "warehouse_product"."warehouse_id" = "warehouse"."id"
JOIN "products" ON "warehouse_product"."product_id" = "products"."id"
WHERE "products"."description" = 'diet pepsi'
ORDER BY "warehouse"."id";

-- 5. Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.
SELECT "customers"."first_name", "customers"."last_name", COUNT("addresses"."customer_id") AS "number_of_orders" FROM "orders"
JOIN "addresses" ON "orders"."address_id" = "addresses"."id"
JOIN "customers" ON "customers"."id" = "addresses"."customer_id"
GROUP BY "customers"."first_name", "customers"."last_name";

-- 6. How many customers do we have?
SELECT COUNT("customers") AS "number_of_customers" FROM "customers";

-- If we want to know how many customers we have that are currently on orders, we can do:
SELECT COUNT(DISTINCT "addresses"."customer_id") FROM "orders"
JOIN "addresses" ON "addresses"."id" = "orders"."address_id";

-- 7. How many products do we carry?
SELECT COUNT("products") AS "number_of_products" FROM "products";

-- 8. What is the total available on-hand quantity of diet pepsi?
SELECT SUM("warehouse_product"."on_hand") AS "diet_pepsi_on_hand" FROM "warehouse_product"
JOIN "products" ON "products"."id" = "warehouse_product"."product_id"
WHERE "products"."description" = 'diet pepsi';

-- STRETCH MODE

-- 9. How much was the total cost for each order?
SELECT "orders"."id", SUM("line_items"."quantity" * "products"."unit_price") FROM "orders"
JOIN "line_items" ON "line_items"."order_id" = "orders"."id"
JOIN "products" ON "line_items"."product_id" = "products"."id"
GROUP BY "orders"."id";

-- 10. How much has each customer spent in total?
SELECT "customers"."first_name", "customers"."last_name", SUM("line_items"."quantity" * "products"."unit_price") FROM "orders"
JOIN "line_items" ON "line_items"."order_id" = "orders"."id"
JOIN "products" ON "line_items"."product_id" = "products"."id"
JOIN "addresses" ON "addresses"."id" = "orders"."address_id"
JOIN "customers" ON "customers"."id" = "addresses"."customer_id"
GROUP BY "customers"."first_name", "customers"."last_name"
ORDER BY "customers"."first_name";

-- 11. How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).
SELECT "customers"."first_name", "customers"."last_name", COALESCE(SUM("line_items"."quantity" * "products"."unit_price"), 0) FROM "orders"
JOIN "line_items" ON "line_items"."order_id" = "orders"."id"
JOIN "products" ON "line_items"."product_id" = "products"."id"
JOIN "addresses" ON "addresses"."id" = "orders"."address_id"
FULL JOIN "customers" ON "customers"."id" = "addresses"."customer_id"
GROUP BY "customers"."first_name", "customers"."last_name"
ORDER BY "customers"."first_name";