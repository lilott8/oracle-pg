# Online Retail

In this tutorial, we load the product purchase information from Database to Graph Server, and make recommendations using graph algorithms. Since the graph algorithms can run efficiently on Graph Server, we need a Graph Server (= 3-tier deployment) for this use case.

Please setup containers following the instruction [here](https://github.com/ryotayamanaka/oracle-pg/blob/master/README.md).

## Load Data into Database

Download dataset `Online Retail.xlsx` from:

* Original site: http://archive.ics.uci.edu/ml/datasets/online+retail#
* Alternate site: https://www.kaggle.com/jihyeseo/online-retail-data-set-from-uci-ml-repo

Open with Excel and save the file as `data.csv` in CSV format. (Save As > File Format: CSV UTF-8)

Put this file to the `retail` directory.

    $ mv data.csv oracle-pg/graphs/retail/
    $ dos2unix data.csv

## Load Data into Database

Run a bash console on `oracle-db` container.

    $ docker exec -it oracle-db /bin/bash

Create database user and `transactions` table, then load the data.

    $ cd /graphs/retail/
    $ sqlplus sys/Welcome1@orclpdb1 as sysdba @create_user.sql
    $ sqlplus retail/Welcome1@orclpdb1 @create_table.sql
    $ sqlldr retail/Welcome1@orclpdb1 sqlldr.ctl sqlldr.log sqlldr.bad direct=true

## Convert Data from Tables to Graph 

For creating nodes, this table should be normalized into `customers` table and `products` table.

    $ sqlplus retail/Welcome1@orclpdb1 @create_table_normalized.sql

To pre-load the data into Graph Server, add this entry to `pgx-rdbms.conf`.

    {"path": "/graphs/retail/config-tables.json", "name": "Online Retail"}

[`config-tables.json`](https://github.com/ryotayamanaka/oracle-pg/blob/master/graphs/retail/config-tables.json)

```
{
  "jdbc_url":"jdbc:oracle:thin:@oracle-db:1521/orclpdb1",
  "username":"retail",
  "keystore_alias":"database1",
  "name":"retail",
  "vertex_providers": [
    {
      "name":"Customer",
      ...

  "edge_providers": [
    {
      "name":"has_purchased",
      ...

```

Restart Graph Server (and other components).

    $ docker restart graph-server

Open Graph Visualization (http://localhost:7007/ui) to check the graph "Online Retail" is loaded.


## Make Recommendations

Restart Zeppelin (or recreating the session from the interpreter settings).

    $ docker restart zeppelin

Open Zeppelin (http://localhost:8080) and follow "Online Retail" note.


## Deploy a Sample Application




---

## Appendix 1

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

## Appendix 2

How to store the partitioned graph in CSV format (using Zeppelin).

    %pgx
    graph = session.getGraph("Online Retail")
    config = graph.store(ProviderFormat.PGB, "/graphs/retail/data/");
    new File("/graphs/retail/data/config.json") << config.toString()

