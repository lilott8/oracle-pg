# paysim

Run a bash console on `oracle-db` container.

    $ docker exec -it oracle-db /bin/bash

Create database user and `paysim` table, then load the data.

    $ cd /graphs/paysim/
    $ sqlplus sys/Welcome1@orclpdb1 as sysdba @create_user.sql
    $ sqlplus paysim/paysim@orclpdb1 @create_table.sql
    $ sqlldr paysim/paysim@orclpdb1 sqlldr.ctl sqlldr.log sqlldr.bad direct=true


