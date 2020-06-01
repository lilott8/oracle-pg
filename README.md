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

It takes some time. To check the progress, see [Appendix 1](#appendix-1).

Access Graph Visualization.

* http://localhost:7007/ui/

Access to Zeppelin and start graph analytics, e.g. [[Customer 360 Analysis]].

* http://localhost:8080/#/

To stop, restart, or remove the containers, see [Appendix 2](#appendix-2).

***

### Appendix 1

To check the progress, see logs.

    $ cd oracle-pg/docker/
    $ docker-compose logs -f

`Cnt+C` to quit.

### Appendix 2

To start, stop, or restart the containers.

    $ cd oracle-pg/docker/
    $ docker-compose start|stop|restart

To remove the docker containers.

    $ cd oracle-pg/docker/
    $ docker-compose down
