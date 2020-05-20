# paysim

Run a bash console on `oracle-db` container.

    $ docker exec -it oracle-db /bin/bash

Create database user and `paysim` table, then load the data.

    $ cd /graphs/paysim/
    $ sqlplus sys/Welcome1@orclpdb1 as sysdba @create_user.sql
    $ sqlplus paysim/Welcome1@orclpdb1 @create_table.sql
    $ sqlldr paysim/Welcome1@orclpdb1 sqlldr.ctl sqlldr.log sqlldr.bad direct=true


    $ sqlplus paysim/Welcome1@orclpdb1 @create_view.sql

Create graph on database.

    $ docker exec -it graph-client opg-jshell

    > var jdbcUrl = "jdbc:oracle:thin:@oracle-db:1521/orclpdb1"
    > var conn = DriverManager.getConnection(jdbcUrl, "paysim", "paysim")
    > conn.setAutoCommit(false)
    > var pgql = PgqlConnection.getConnection(conn)
    > pgql.prepareStatement(Files.readString(Paths.get("/graphs/paysim/create_pg.pgql"))).execute()
$xx ==> false
