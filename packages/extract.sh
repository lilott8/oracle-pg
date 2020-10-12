#!/bin/bash

OV=20.4.0 # Oracle Graph Server and Client Version
AV=2.4.20 # Apache Groovy Version


#unzip oracle-graph-client-$OV.zip -d ./oracle-graph-client
#cp ./oracle-graph-client/*.jar ../zeppelin/interpreter/pgx/
#rm -r ./oracle-graph-client

rm -r ../scripts/oracle-graph-plsql
unzip oracle-graph-plsql-$OV.zip -d ../scripts/oracle-graph-plsql

unzip oracle-graph-zeppelin-interpreter-$OV.zip -d ./oracle-graph-zeppelin-interpreter
rm ../zeppelin/interpreter/pgx/*
cp ./oracle-graph-zeppelin-interpreter/* ../zeppelin/interpreter/pgx/
rm -r ./oracle-graph-zeppelin-interpreter

unzip apache-groovy-binary-$AV.zip
cp ./groovy-$AV/lib/*.jar ../zeppelin/interpreter/pgx/
rm -r ./groovy-$AV
