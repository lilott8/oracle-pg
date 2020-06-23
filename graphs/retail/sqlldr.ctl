OPTIONS (SKIP=1)
LOAD DATA
CHARACTERSET UTF8
INFILE '/graphs/retail/data.csv'
TRUNCATE INTO TABLE transactions
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
(
  invoice_no
, stock_code
, description
, quantity
, invoice_date
, unit_price
, customer_id
, country
)
