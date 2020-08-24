#!/bin/bash
cd /graphs/retail/
sqlplus sys/Welcome1@orclpdb1 as sysdba @create_user.sql
sqlplus retail/Welcome1@orclpdb1 @create_table.sql
sqlldr retail/Welcome1@orclpdb1 sqlldr.ctl sqlldr.log sqlldr.bad direct=true
sqlplus retail/Welcome1@orclpdb1 @create_table_normalized.sql
