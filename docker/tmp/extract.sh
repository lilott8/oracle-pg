#!/bin/bash

OV=20.2.0   # Oracle Graph Server and Client Version
AV=2.4.18 # Apache Groovy Version

rm ../zeppelin/interpreter/pgx/*.jar

unzip oracle-graph-zeppelin-interpreter-$OV.zip -d ./oracle-graph-zeppelin-interpreter
cp ./oracle-graph-zeppelin-interpreter/*.jar ../zeppelin/interpreter/pgx/
rm -r ./oracle-graph-zeppelin-interpreter

unzip apache-groovy-binary-$AV.zip
cp ./groovy-$AV/lib/*.jar ../zeppelin/interpreter/pgx/
rm -r ./groovy-$AV
