SPOOL data/transaction.pg
SET PAGESIZE 0
SET LINESIZE 32767
SET FEEDBACK OFF
SET TRIMSPOOL ON
SET TERMOUT OFF

SELECT
  name_orig
  || ' -> '
  || name_dest
  || ' :' || LOWER(type) || ' '
  || 'step:"' || step || '" '
  || 'amount:"' || amount || '" '
  || 'name_orig:"' || name_orig || '" '
  || 'old_balance_orig:"' || old_balance_orig || '" '
  || 'new_balance_orig:"' || new_balance_orig || '" '
  || 'name_dest:"' || name_dest || '" '
  || 'old_balance_dest:"' || old_balance_dest || '" '
  || 'new_balance_dest:"' || new_balance_dest || '" '
  || 'is_fraud:"' || is_fraud || '" '
  || 'is_flagged_fraud:"' || is_flagged_fraud || '" '
FROM
  paysim
WHERE
    name_orig IS NOT NULL
AND name_dest IS NOT NULL
AND type IS NOT NULL
;

SPOOL OFF
EXIT
