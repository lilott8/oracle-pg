CREATE TABLE customers (
  customer_id
, CONSTRAINT customers_pk PRIMARY KEY (customer_id)
) AS
SELECT DISTINCT
  'cust_' || customer_id
FROM transactions
WHERE customer_id IS NOT NULL
;

SET ECHO ON
SELECT * FROM customers WHERE ROWNUM <= 5;

CREATE TABLE products (
  stock_code
, CONSTRAINT product_pk PRIMARY KEY (stock_code)
) AS
SELECT DISTINCT
  'prod_' || stock_code
FROM transactions
WHERE stock_code IS NOT NULL
;

SET ECHO ON
SELECT * FROM products WHERE ROWNUM <= 5;

CREATE TABLE purchases (
  purchase_id
, stock_code
, customer_id
, quantity
, unit_price
) AS
SELECT
  ROWNUM AS purchase_id
, 'prod_' || stock_code
, 'cust_' || customer_id
, quantity
, unit_price
FROM transactions
WHERE
    stock_code IS NOT NULL
AND customer_id IS NOT NULL
;

SET ECHO ON
SELECT * FROM purchases WHERE ROWNUM <= 5;

EXIT
