--DROP TABLE customer_360.account;
--DROP TABLE customer_360.customer;
--DROP TABLE customer_360.merchant;
--DROP TABLE customer_360.owned_by;
--DROP TABLE customer_360.parent_of;
--DROP TABLE customer_360.purchased;
--DROP TABLE customer_360.transfer;

CREATE TABLE customer_360.account (
  id NUMBER NOT NULL
, type VARCHAR2(20) 
, account_no VARCHAR2(20)
, balance NUMBER
, CONSTRAINT account_pk PRIMARY KEY (id)
);

INSERT INTO customer_360.account (id,type,account_no,balance) VALUES (201,'account','xxx-yyy-201',1500);
INSERT INTO customer_360.account (id,type,account_no,balance) VALUES (202,'account','xxx-yyy-202',200);
INSERT INTO customer_360.account (id,type,account_no,balance) VALUES (203,'account','xxx-yyy-203',2100);
INSERT INTO customer_360.account (id,type,account_no,balance) VALUES (204,'account','xxx-yyy-204',100);
INSERT INTO customer_360.account (id,type,account_no,balance) VALUES (211,'account','xxx-zzz-204',NULL);
INSERT INTO customer_360.account (id,type,account_no,balance) VALUES (212,'account','xxx-zzz-204',NULL);
COMMIT;

CREATE TABLE customer_360.customer (
  id NUMBER NOT NULL, 
  type VARCHAR2(20), 
  name VARCHAR2(20), 
  age NUMBER, 
  location VARCHAR2(20), 
  gender VARCHAR2(20), 
  student VARCHAR2(20)
, CONSTRAINT customer_pk PRIMARY KEY (id)
);

INSERT INTO customer_360.customer (id,type,name,age,location,gender,student) VALUES (101,'customer','John',10,'Boston',NULL,NULL);
INSERT INTO customer_360.customer (id,type,name,age,location,gender,student) VALUES (102,'customer','Mary',NULL,NULL,'F',NULL);
INSERT INTO customer_360.customer (id,type,name,age,location,gender,student) VALUES (103,'customer','Jill',NULL,'Boston',NULL,NULL);
INSERT INTO customer_360.customer (id,type,name,age,location,gender,student) VALUES (104,'customer','Todd',NULL,NULL,NULL,'true');
COMMIT;

CREATE TABLE customer_360.merchant (
  id NUMBER NOT NULL 
, type VARCHAR2(20) 
, name VARCHAR2(20)
, CONSTRAINT merchant_pk PRIMARY KEY (id)
);

INSERT INTO customer_360.merchant (id,type,name) VALUES (301,'merchant','Apple Store');
INSERT INTO customer_360.merchant (id,type,name) VALUES (302,'merchant','PC Paradise');
INSERT INTO customer_360.merchant (id,type,name) VALUES (303,'merchant','Kindle Store');
INSERT INTO customer_360.merchant (id,type,name) VALUES (304,'merchant','Asia Books');
INSERT INTO customer_360.merchant (id,type,name) VALUES (305,'merchant','ABC Travel');
COMMIT;

CREATE TABLE customer_360.owned_by (
  from_id NUMBER, 
  to_id NUMBER, 
  type VARCHAR2(20), 
  since VARCHAR2(20)
);

INSERT INTO customer_360.owned_by (from_id,to_id,type,since) VALUES (201,101,'owned_by','2015-10-04');
INSERT INTO customer_360.owned_by (from_id,to_id,type,since) VALUES (202,102,'owned_by','2012-09-13');
INSERT INTO customer_360.owned_by (from_id,to_id,type,since) VALUES (203,103,'owned_by','2016-02-04');
INSERT INTO customer_360.owned_by (from_id,to_id,type,since) VALUES (204,104,'owned_by','2018-01-05');
COMMIT;

CREATE TABLE customer_360.parent_of (
  from_id NUMBER
, to_id NUMBER
, type VARCHAR2(20)
);

INSERT INTO customer_360.parent_of (from_id,to_id,type) VALUES (103,104,'parent_of');

CREATE TABLE customer_360.purchased (
  from_id NUMBER, 
  to_id NUMBER, 
  type VARCHAR2(20), 
  amount NUMBER
);

INSERT INTO customer_360.purchased (from_id,to_id,type,amount) VALUES (201,301,'purchased',800);
INSERT INTO customer_360.purchased (from_id,to_id,type,amount) VALUES (201,302,'purchased',15);
INSERT INTO customer_360.purchased (from_id,to_id,type,amount) VALUES (202,301,'purchased',150);
INSERT INTO customer_360.purchased (from_id,to_id,type,amount) VALUES (202,302,'purchased',20);
INSERT INTO customer_360.purchased (from_id,to_id,type,amount) VALUES (202,304,'purchased',10);
INSERT INTO customer_360.purchased (from_id,to_id,type,amount) VALUES (203,301,'purchased',350);
INSERT INTO customer_360.purchased (from_id,to_id,type,amount) VALUES (203,302,'purchased',20);
INSERT INTO customer_360.purchased (from_id,to_id,type,amount) VALUES (203,303,'purchased',15);
INSERT INTO customer_360.purchased (from_id,to_id,type,amount) VALUES (204,303,'purchased',10);
INSERT INTO customer_360.purchased (from_id,to_id,type,amount) VALUES (204,304,'purchased',15);
INSERT INTO customer_360.purchased (from_id,to_id,type,amount) VALUES (204,305,'purchased',450);
COMMIT;

CREATE TABLE customer_360.transfer (
  from_id NUMBER
, to_id NUMBER
, type VARCHAR2(20)
, amount NUMBER
, "DATE" VARCHAR2(20)
);

INSERT INTO customer_360.transfer (from_id,to_id,type,amount,"DATE") VALUES (201,202,'transfer',200,'2018-10-05');
INSERT INTO customer_360.transfer (from_id,to_id,type,amount,"DATE") VALUES (211,202,'transfer',900,'2018-10-06');
INSERT INTO customer_360.transfer (from_id,to_id,type,amount,"DATE") VALUES (202,212,'transfer',850,'2018-10-06');
INSERT INTO customer_360.transfer (from_id,to_id,type,amount,"DATE") VALUES (201,203,'transfer',500,'2018-10-07');
INSERT INTO customer_360.transfer (from_id,to_id,type,amount,"DATE") VALUES (203,204,'transfer',450,'2018-10-08');
INSERT INTO customer_360.transfer (from_id,to_id,type,amount,"DATE") VALUES (204,201,'transfer',400,'2018-10-09');
INSERT INTO customer_360.transfer (from_id,to_id,type,amount,"DATE") VALUES (202,203,'transfer',100,'2018-10-10');
INSERT INTO customer_360.transfer (from_id,to_id,type,amount,"DATE") VALUES (202,201,'transfer',300,'2018-10-10');
COMMIT;
