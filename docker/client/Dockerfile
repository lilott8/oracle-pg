FROM openjdk:11-oracle
COPY V986461-01.rpm /tmp
RUN rpm -ivh /tmp/V986461-01.rpm
ENV PATH=$PATH:/opt/oracle/graph/bin
WORKDIR /opt/oracle/graph/bin
