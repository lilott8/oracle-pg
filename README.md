# Oracle Property Graph

The docker image build files, sample datasets, and use case exmaples, for Oracle Property Graph.

**The scripts here are my own. Not Oracle's official material.**

Architecture:

![](https://user-images.githubusercontent.com/4862919/80330080-632e9a00-886e-11ea-822e-0a96e40dbbf9.jpg)

## Build Docker Image for Oracle Database

Clone `docker-images` repository.

    $ cd <your-work-directory>
    $ git clone https://github.com/oracle/docker-images.git

Download Oracle Database.

* [Oracle Database 19.3.0 for Linux x86-64 (ZIP)](https://www.oracle.com/database/technologies/oracle-database-software-downloads.html)

Put `LINUX.X64_193000_db_home.zip` under:
* `docker-images/OracleDatabase/SingleInstance/dockerfiles/19.3.0/`

Build the image.

    $ cd docker-images/OracleDatabase/SingleInstance/dockerfiles/
    $ bash buildDockerImage.sh -v 19.3.0 -e

## Clone this Repository

    $ cd <your-work-directory>
    $ git clone https://github.com/ryotayamanaka/oracle-pg.git

### Download and Extract Packages

Go to the following pages and download the packages.

* [Oracle Graph Server and Client 20.3](https://www.oracle.com/database/technologies/spatialandgraph/property-graph-features/graph-server-and-client/graph-server-and-client-downloads.html)
* [Apache Groovy 2.4.18](https://dl.bintray.com/groovy/maven/apache-groovy-binary-2.4.18.zip)

Put the following files to `oracle-pg/packages/`
 
- oracle-graph-20.3.0.x86_64.rpm
- oracle-graph-client-20.3.0.zip
- oracle-graph-zeppelin-interpreter-20.3.0.zip
- oracle-graph-plsql-20.3.0.zip
- apache-groovy-binary-2.4.18.zip

Run the following script to extract packages:

    $ cd oracle-pg/packages/
    $ sh extract.sh

### Start Containers

Start the containers for **Oracle Database** only first.

    $ cd oracle-pg/
    $ docker-compose up oracle-db
    ...
    oracle-db       | Completing Database Creation
    ...
    oracle-db       | #########################
    oracle-db       | DATABASE IS READY TO USE!
    oracle-db       | #########################

**This job takes time.**

### Configure Oracle Database

Connect to the Oracle Database server. See [Appendix 1](#appendix-1) if you get an error.

    $ docker exec -it oracle-db sqlplus sys/Welcome1@orclpdb1 as sysdba

Configure Property Graph features.

    SQL> @/home/oracle/scripts/oracle-graph-plsql/19c_and_above/catopg.sql

Craete user roles and users.

    SQL> @/home/oracle/scripts/create_users.sql
    SQL> EXIT

### Start Containers for Graph Server, Graph Client, and Zeppelin

Build and pull images, create containers, and start them.

    $ cd oracle-pg/
    $ docker-compose up

**This job takes time.** `Cnt+C` to stop all containers.

Access Graph Visualization and Zeppelin to start graph analytics, e.g. [Customer 360 Analysis](https://github.com/ryotayamanaka/oracle-pg/wiki/Customer-360-Analysis).

* Graph Visualization - http://localhost:7007/ui/ (User: graph_dev, Password: Welcome1)
* Zeppelin - http://localhost:8080/#/

To stop, restart, or remove the containers, see [Appendix 2](#appendix-2).

## Appendix 1

You need to start the container if it is stopped.

    $ cd oracle-pg/
    $ docker-compose start oracle-db

You will get this error when you try to connect before the database is created.

    $ docker exec -it oracle-db sqlplus sys/Welcome1@localhost:1521/orclpdb1 as sysdba
    ...
    ORA-12514: TNS:listener does not currently know of service requested in connect

To check the progress, see logs.

    $ cd oracle-pg/
    $ docker-compose logs -f oracle-db

`Cnt+C` to quit.

## Appendix 2

To start, stop, or restart the containers.

    $ cd oracle-pg/
    $ docker-compose start|stop|restart

To remove the docker containers.

    $ cd oracle-pg/
    $ docker-compose down
