# Online Retail

In this tutorial, we load the product purchase information from Database to Graph Server, and make recommendations using graph algorithms. Since the graph algorithms can run efficiently on Graph Server, we need a Graph Server (= 3-tier deployment) for this use case.

Please setup containers following the instruction [here](https://github.com/ryotayamanaka/oracle-pg/blob/master/README.md).

## Load Data into Database

Download dataset `Online Retail.xlsx` from:

* Original site: http://archive.ics.uci.edu/ml/datasets/online+retail#
* Alternate site: https://www.kaggle.com/jihyeseo/online-retail-data-set-from-uci-ml-repo

Open with Excel and save the file as `data.csv` in CSV format. (Save As > File Format: CSV UTF-8)

Put this file to the `retail` directory.

    $ mv data.csv oracle-pg/graphs/online_retail/
    $ dos2unix data.csv

## Load Data into Database

Run a bash console on `oracle-db` container.

    $ cd oracle-pg/
    $ docker-compose exec oracle-db /bin/bash

Move to the project directory (inside the container).

    $ cd /graphs/online_retail/

Create a database user and `transactions` table, then load the data from the csv files.

    $ sqlplus sys/Welcome1@orclpdb1 as sysdba @create_user.sql

Create `transactions` table.

    $ sqlplus online_retail/Welcome1@orclpdb1 @create_table.sql

Load the data from the CSV file.

    $ sqlldr online_retail/Welcome1@orclpdb1 sqlldr.ctl sqlldr.log sqlldr.bad direct=true

## Convert Data from Tables to Graph

This table can be normalized to create 4 tables (`customers`, `products`, `purchases`, `purchases_distinct`).

    $ sqlplus online_retail/Welcome1@orclpdb1 @create_table_normalized.sql

Exit from the database container.

    $ exit

For pre-loading the graph into Graph Server, add these two entries to `conf/pgx.conf`.

    {
      "authorization": [
        "pgx_permissions": [
        , { "preloaded_graph": "Online Retail", "grant": "READ"}            <--

      "preload_graphs": [
      , {"path": "/graphs/online_retail/config-tables-distinct.json", "name": "Online Retail"}   <--

There are two loading configuration files in the directory, [`config-tables.json`](https://github.com/ryotayamanaka/oracle-pg/blob/master/graphs/retail/config-tables.json) and [`config-tables-distinct.json`](https://github.com/ryotayamanaka/oracle-pg/blob/master/graphs/retail/config-tables-distinct.json). The former counts all duplicated purchases (when customers has purchased the same products multiple times), while such duplicated edges are merged in the latter. We use the distinct version for making recommendations here.

Restart Graph Server.

    $ cd oracle-pg/
    $ docker-compose restart graph-server

Open Graph Visualization (http://localhost:7007/ui) and confirm the graph "Online Retail" is loaded. Import [`highlights.json`](https://github.com/ryotayamanaka/oracle-pg/blob/20.3/graphs/retail/highlights.json) for better highlights.

## Make Recommendations

Open Zeppelin (http://localhost:8080) and import [`zeppelin.json`](https://github.com/ryotayamanaka/oracle-pg/blob/20.3/graphs/online_retail/zeppelin.json) to load the "Online Retail" note.

---

## Appendix 1

Create graph on database.

    $ cd oracle-pg/
    $ docker-compose exec graph-client opg-jshell

    > var jdbcUrl = "jdbc:oracle:thin:@oracle-db:1521/orclpdb1"
    > var conn = DriverManager.getConnection(jdbcUrl, "retail", "Welcome1")
    > conn.setAutoCommit(false)
    > var pgql = PgqlConnection.getConnection(conn)
    > pgql.prepareStatement(Files.readString(Paths.get("/graphs/retail/create_pg.pgql"))).execute()
    $xx ==> false

Alternatively, directly load from tables.

    $ cd oracle-pg/
    $ docker-compose exec graph-client opg-jshell --secret_store /opt/oracle/keystore.p12
    enter password for keystore /opt/oracle/keystore.p12: [oracle]

    > var g = session.readGraphWithProperties("/graphs/retail/config-tables.json");

## Appendix 2

How to store the partitioned graph in CSV format (using Zeppelin).

    %pgx
    graph = session.getGraph("Online Retail")
    config = graph.store(ProviderFormat.PGB, "/graphs/retail/data/");
    new File("/graphs/retail/data/config.json") << config.toString()
