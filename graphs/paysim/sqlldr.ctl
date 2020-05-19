OPTIONS (SKIP=1)
LOAD DATA
CHARACTERSET UTF8
INFILE 'PS_20174392719_1491204439457_log.csv'
TRUNCATE INTO TABLE paysim
FIELDS TERMINATED BY ','
(
  step
, type
, amount
, name_orig
, old_balance_orig
, new_balance_orig
, name_dest
, old_balance_dest
, new_balance_dest
, is_fraud
, is_flagged_fraud
)
