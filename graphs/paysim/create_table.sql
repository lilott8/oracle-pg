--DROP TABLE paysim;
CREATE TABLE paysim (
  step NUMBER(3)
, type VARCHAR2(255)
, amount NUMBER(10,2)
, name_orig VARCHAR2(255)
, old_balance_orig NUMBER(10,2)
, new_balance_orig NUMBER(10,2)
, name_dest VARCHAR2(255)
, old_balance_dest NUMBER(10,2)
, new_balance_dest NUMBER(10,2)
, is_fraud NUMBER(1)
, is_flagged_fraud NUMBER(1)
);
EXIT
