#!/bin/bash
git clone https://github.com/oracle/db-sample-schemas.git
cd db-sample-schemas
perl -p -i.bak -e 's#__SUB__CWD__#/graphs/hr/db-sample-schemas#g' *.sql */*.sql */*.dat
echo "EXIT" >> mksample.sql
docker exec -it oracle-db sqlplus system/Welcome1@oracle-db:1521/orclpdb1 @/graphs/hr/db-sample-schemas/mksample Welcome1 Welcome1 Welcome1 Welcome1 Welcome1 Welcome1 Welcome1 Welcome1 users temp /graphs/hr/log/ oracle-db:1521/orclpdb1
echo "\ninstall.sh: Completed!\n"
