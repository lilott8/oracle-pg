# Oracle Property Graph

The docker image build files, sample datasets, and use case exmaples, for Oracle Property Graph.

**The contributions here are my own. Not Oracle's official material.**

## Setup Step 1

### Overview

Let's try loading graph data from files before setting up database in the step 2.

![](https://user-images.githubusercontent.com/4862919/80505829-0da5da80-899f-11ea-9517-3fc51c1600b9.jpg)

### Clone this Repository

    $ git clone https://github.com/ryotayamanaka/oracle-pg.git -b 20.1

(Please use `20.1` branch which is compatible with **Graph Server and Client 20.1**) 

### Download and Extract Packages

Go to the following pages and download the packages.

* [Oracle Graph Server and Client 20.1](https://www.oracle.com/database/technologies/spatialandgraph/property-graph-features/graph-server-and-client/graph-server-and-client-downloads.html)
* [Apache Groovy 2.4.18](https://dl.bintray.com/groovy/maven/apache-groovy-binary-2.4.18.zip)

Put the following files to `oracle-pg/docker/tmp/`
  
- oracle-graph-20.1.0.x86_64.rpm
- oracle-graph-zeppelin-interpreter-20.1.0.zip
- apache-groovy-binary-2.4.18.zip

Run the following script to extract packages:

    $ cd oracle-pg/docker/tmp/
    $ sh extract.sh

### Start Containers

Build and pull images, create containers, and start them.

    $ cd oracle-pg/docker/
    $ docker-compose up -d
    $ docker-compose logs -f

This job takes time. `Cnt+C` to quit showing logs.

Access Graph Visualization and Zeppelin to start graph analytics, e.g. [Customer 360 Analysis](https://github.com/ryotayamanaka/oracle-pg/wiki/Customer-360-Analysis).

* http://localhost:7007/ui/
* http://localhost:8080/#/

To stop, restart, or remove the containers, see [Appendix 1](#appendix-1).

## Setup Step 2

### Overview

In this tutorial, we will create a docker container for Oracle Database as a backend storage of graphs.

![](https://user-images.githubusercontent.com/4862919/80330080-632e9a00-886e-11ea-822e-0a96e40dbbf9.jpg)

### Build Docker Image

Clone `docker-images` repository.

    $ git clone https://github.com/oracle/docker-images.git

Download Oracle Database.

* [Oracle Database 19.3.0 for Linux x86-64 (ZIP)](https://www.oracle.com/database/technologies/oracle-database-software-downloads.html)

Put `LINUX.X64_193000_db_home.zip` under:
* `docker-images/OracleDatabase/SingleInstance/dockerfiles/19.3.0/`

Build the image.

    $ cd docker-images/OracleDatabase/SingleInstance/dockerfiles/
    $ bash buildDockerImage.sh -v 19.3.0 -e

### Start Containers

Start the containers for **Oracle Database** only.

    $ cd oracle-pg/docker/
    $ docker-compose -f docker-compose-rdbms.yml up -d oracle-db
    $ docker-compose -f docker-compose-rdbms.yml logs -f oracle-db

This job **takes time**. `Cnt+C` to quit showing the logs.

### Configure Oracle Database

Connect to the Oracle Database server. See [Appendix 2](#appendix-2) if you get an error.

    $ docker exec -it oracle-db sqlplus sys/Welcome1@orclpdb1 as sysdba

Set max_string_size running [`max_string_size.sql`](https://github.com/ryotayamanaka/oracle-pg/blob/master/docker/rdbms/scripts/max_string_size.sql).

    SQL> @/home/oracle/scripts/max_string_size.sql
    
    ...
    
    NAME              TYPE        VALUE
    ----------------- ----------- ---------
    max_string_size   string      EXTENDED

Next step is [[Create Graph on Database]].

### Load Table Data

Connect the database as "sys" user, and create a user, "customer_360".

    $ docker exec -it oracle-db sqlplus sys/Welcome1@orclpdb1 as sysdba
    SQL> @/graphs/customer_360/create_user.sql

Connect the database as "customer_360" user, and create tables.

    $ docker exec -it oracle-db sqlplus customer_360/Welcome1@orclpdb1
    SQL> @/graphs/customer_360/create_tables.sql

### Create Property Graph

The following DDL creates a property graph (= node table and edge table) from the table data.

![](https://user-images.githubusercontent.com/4862919/80330243-dfc17880-886e-11ea-8523-951045642a22.jpg)

[`create_pg.pgql`](https://github.com/ryotayamanaka/oracle-pg/blob/master/graphs/customer_360/create_pg.pgql)

    CREATE PROPERTY GRAPH customer_360
      VERTEX TABLES (
        customer
          LABEL "Customer"
          PROPERTIES (
            type AS "type"
            ...
          
      EDGE TABLES (
        owned_by
          SOURCE KEY(from_id) REFERENCES account
          DESTINATION KEY(to_id) REFERENCES customer
          LABEL "owned_by"
          PROPERTIES (
            since AS "since"
            ...
          

Using Graph Client, connect to Oracle Database and run the DDL above.

    $ docker exec -it graph-client opg-rdbms-jshell
    
    > var jdbcUrl = "jdbc:oracle:thin:@oracle-db:1521/orclpdb1"
    > var conn = DriverManager.getConnection(jdbcUrl, "customer_360", "Welcome1")
    > conn.setAutoCommit(false)
    > var pgql = PgqlConnection.getConnection(conn)
    > pgql.prepareStatement(Files.readString(Paths.get("/graphs/customer_360/create_pg.pgql"))).execute()
    $xx ==> false

Exit Graph Client. To try running queries, please see [Appendix 3](#appendix-3).

    > /exit

### Loading Configuration

Set the new loading configuration into the list of preload graphs.

![](https://user-images.githubusercontent.com/4862919/80330283-f36cdf00-886e-11ea-824e-8c0d32d23f38.jpg)

`pgx-rdbms.conf`

    $ oracle-pg/docker/conf/pgx-rdbms.conf
    "preload_graphs": [
      {"path": "/graphs/customer_360/rdbms.json", "name": "Customer 360"},

[`rdbms.json`](https://github.com/ryotayamanaka/oracle-pg/blob/master/graphs/customer_360/rdbms.json) (abbreviated)

```
{
  "format":"pg",
  "db_engine":"rdbms",
  "jdbc_url":"jdbc:oracle:thin:@oracle-db:1521/orclpdb1",
  "username":"customer_360",
  "keystore_alias":"database1",
  "max_num_connections":8,
  "name":"customer_360",
  "vertex_props": [
    { "name": "name", "type": "string" },
    { "name": "age", "type": "integer"},
    ...
  ],
  "edge_props": [
    { "name": "amount", "type": "integer" },
    { "name": "date", "type": "string" }
  ],
  "partition_while_loading":"by_label",
  "loading":{
    "load_vertex_labels":true,
    "load_edge_label":true
  }
}
```

Note that vertex labels are also loaded and the graph is partitioned by the labels.

See also [Appendix 4](#appendix-4).

### Start Graph Server

Run Docker containers for Graph Server, Graph Client, and Zeppelin.

    $ cd oracle-pg/docker/
    $ docker-compose -f docker-compose-rdbms.yml restart

See also [Appendix 5](#appendix-5).

Access Graph Visualization and Zeppelin to start graph analytics, e.g. [Customer 360 Analysis](https://github.com/ryotayamanaka/oracle-pg/wiki/Customer-360-Analysis).

* http://localhost:7007/ui/
* http://localhost:8080/

***

### Appendix 1

To start, stop, or restart the containers.

    $ cd oracle-pg/docker/
    $ docker-compose start|stop|restart

To remove the docker containers.

    $ cd oracle-pg/docker/
    $ docker-compose down

### Appendix 2

You will get this error when you try to connect before the database is created.

    $ docker exec -it oracle-db sqlplus sys/Welcome1@localhost:1521/orclpdb1 as sysdba
    ...
    ORA-12514: TNS:listener does not currently know of service requested in connect

To check the progress, see logs.

    $ cd oracle-pg/docker/
    $ docker-compose -f docker-compose-rdbms.yml logs -f oracle-db

`Cnt+C` to quit.

### Appendix 3

You can check the graph by query (= PGQL on RDBMS), e.g. how many nodes are in the new property graph.

    > Consumer<String> query = q -> {
        try(var s = pgql.prepareStatement(q)) {
          s.execute();
          s.getResultSet().print();
        } catch(Exception e) {
          throw new RuntimeException(e);
        }
      }
    > query.accept("select count(v) from customer_360 match (v)")
    +----------+
    | count(v) |
    +----------+
    | 8        |
    +----------+

### Appendix 4

To test loading configuration, you can access to Graph Server and try loading. 

    $ docker exec -it graph-client opg-jshell -b http://graph-server:7007
    > var graph = session.readGraphWithProperties("/graphs/customer_360/rdbms.json")

You can also load the graph to "Graph Client", only because it uses the server package this time.

    $ docker exec -it graph-client opg-rdbms-jshell --secret_store /opt/oracle/keystore.p12
    enter password for keystore /opt/oracle/keystore.p12: [oracle]
    > var graph = session.readGraphWithProperties("/graphs/customer_360/rdbms.json")

### Appendix 5

Start, stop, or restart the containers.

    $ cd oracle-pg/docker/
    $ docker-compose -f docker-compose-rdbms.yml start|stop|restart

Stop the containers and remove them.

    $ cd oracle-pg/docker/
    $ docker-compose -f docker-compose-rdbms.yml down
