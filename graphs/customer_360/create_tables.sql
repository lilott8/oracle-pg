DROP TABLE customer_360.account;
DROP TABLE customer_360.customer;
DROP TABLE customer_360.owned_by;

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

INSERT INTO customer_360.customer (id,type,name,age,location,gender,student) values (101,'customer','John',10,'Boston',NULL,NULL);
INSERT INTO customer_360.customer (id,type,name,age,location,gender,student) values (102,'customer','Mary',NULL,NULL,'F',NULL);
INSERT INTO customer_360.customer (id,type,name,age,location,gender,student) values (103,'customer','Jill',NULL,'Boston',NULL,NULL);
INSERT INTO customer_360.customer (id,type,name,age,location,gender,student) values (104,'customer','Todd',NULL,NULL,NULL,'true');

CREATE TABLE customer_360.owned_by (
  from_id NUMBER, 
  to_id NUMBER, 
  type VARCHAR2(20), 
  since VARCHAR2(20)
);

INSERT INTO customer_360.owned_by (from_id,to_id,type,since) values (201,101,'owned_by','2015-10-04');
INSERT INTO customer_360.owned_by (from_id,to_id,type,since) values (202,102,'owned_by','2012-09-13');
INSERT INTO customer_360.owned_by (from_id,to_id,type,since) values (203,103,'owned_by','2016-02-04');
INSERT INTO customer_360.owned_by (from_id,to_id,type,since) values (204,104,'owned_by','2018-01-05');

COMMIT;
