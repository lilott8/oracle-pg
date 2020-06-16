#!/bin/bash
COUNT=1
while [ $COUNT -le 1000 ]
do
  echo $COUNT,\"Account\"
  let COUNT++
done
