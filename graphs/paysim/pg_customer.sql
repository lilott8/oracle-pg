SPOOL data/customer.pg
SET PAGESIZE 0
SET LINESIZE 32767
SET FEEDBACK OFF
SET TRIMSPOOL ON
SET TERMOUT OFF

SELECT DISTINCT *
FROM (
  SELECT
    name_orig
    || ' :customer '
    || 'name:"' || name_orig || '"'
  FROM
    paysim
  WHERE
    name_orig IS NOT NULL
UNION
  SELECT
    name_dest
    || ' :customer '
    || 'name:"' || name_dest
  FROM
    paysim
  WHERE
    name_dest IS NOT NULL
)
;

SPOOL OFF
EXIT
