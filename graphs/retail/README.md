# Online Retail

Download dataset (an Excel file) and save it as `data.csv` in CSV format.

* http://archive.ics.uci.edu/ml/datasets/online+retail#

Run a bash console on `oracle-db` container.

    $ docker exec -it oracle-db /bin/bash

Create database user and `transactions` table, then load the data.

    $ cd /graphs/retail/
    $ sqlplus sys/Welcome1@orclpdb1 as sysdba @create_user.sql
    $ sqlplus retail/Welcome1@orclpdb1 @create_table.sql
    $ sqlldr retail/Welcome1@orclpdb1 sqlldr.ctl sqlldr.log sqlldr.bad direct=true

For creating nodes, this table should be normalized into `customers` table and `products` table.

    $ sqlplus retail/Welcome1@orclpdb1 @create_table_normalized.sql

To load the data directly into Graph Server, add this entry to `pgx-rdbms.conf`.

    {"path": "/graphs/retail/config-tables.json", "name": "Online Retail"}

Restart Graph Server (and other components).

    $ docker restart graph-server

Open Graph Visualization (http://localhost:7007/ui) to check the graph is loaded.

Restart Zeppelin (or recreating the session from the interpreter settings).

    $ docker restart zeppelin

Open Zeppelin (http://localhost:8080) and go to "Online Retail".

---

## Appendix

Create graph on database. (However, this loading has performance issue.)

    $ docker exec -it graph-client opg-jshell

    > var jdbcUrl = "jdbc:oracle:thin:@oracle-db:1521/orclpdb1"
    > var conn = DriverManager.getConnection(jdbcUrl, "retail", "Welcome1")
    > conn.setAutoCommit(false)
    > var pgql = PgqlConnection.getConnection(conn)
    > pgql.prepareStatement(Files.readString(Paths.get("/graphs/retail/create_pg.pgql"))).execute()
    $xx ==> false

Alternatively, directly load from tables.

    $ docker exec -it graph-client opg-jshell --secret_store /opt/oracle/keystore.p12
    enter password for keystore /opt/oracle/keystore.p12: [oracle]

    > var g = session.readGraphWithProperties("/graphs/retail/config-tables.json");




