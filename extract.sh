#!/bin/bash

OV=20.4.0 # Oracle Graph Server and Client Version
AV=2.4.20 # Apache Groovy Version

rm -rf ./scripts/oracle-graph-plsql
unzip ./packages/oracle-graph-plsql-$OV.zip -d ./scripts/oracle-graph-plsql

rm -rf ./zeppelin/interpreter/pgx
mkdir -p ./zeppelin/interpreter/pgx
unzip ./packages/oracle-graph-zeppelin-interpreter-$OV.zip -d ./zeppelin/interpreter/pgx/
unzip ./packages/apache-groovy-binary-$AV.zip -d ./packages/
cp ./packages/groovy-$AV/lib/*.jar ./zeppelin/interpreter/pgx/
rm -rf ./packages/groovy-$AV
