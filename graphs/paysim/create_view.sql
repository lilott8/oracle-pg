CREATE TABLE customer (
  name
, CONSTRAINT customer_pk PRIMARY KEY (name)
) AS
SELECT DISTINCT
  name
FROM (
  SELECT name_orig AS name
  FROM paysim
  WHERE name_orig IS NOT NULL
UNION
  SELECT name_dest AS name
  FROM paysim
  WHERE name_dest IS NOT NULL
);

SET ECHO ON
SELECT * FROM customer WHERE ROWNUM <= 5;

EXIT
