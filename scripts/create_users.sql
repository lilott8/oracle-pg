CREATE ROLE graph_developer;
CREATE ROLE graph_administrator;

CREATE USER graph_dev IDENTIFIED BY Welcome1 
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;
GRANT connect, resource TO graph_dev;

CREATE USER graph_admin IDENTIFIED BY Welcome1 
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;
GRANT connect, resource TO graph_admin;

GRANT graph_developer TO graph_dev;
GRANT graph_administrator TO graph_admin;
