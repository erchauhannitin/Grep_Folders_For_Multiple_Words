#!/bin/bash

INPUT_FILE=Input_file.txt
OUTPUT_FILE=Output_file-$(date +%m%d%Y_%H%M%S).txt
REPO_PATH=<-- folder path -->

start=`date +%s`
counter=0
lines=$(wc -l $INPUT_FILE | awk '{ print $1 }')
echo "Number of operations to check" $lines

while [ $counter -lt $lines ]; do
  let counter=counter+1
  operationName=$(nl $INPUT_FILE | awk "NR==$counter" | awk '{print $2}' | awk -F '/' '{print $1}') 
  version=$(nl $INPUT_FILE | awk "NR==$counter" | awk '{print $2}' | awk -F '/' '{print $2}')
  versionName=$(echo "$version" | sed 's,\.,_,' | awk -F '.' '{print $1}')
  apiType=$(echo "$version" | awk -F '.' '{print $3}')
  
  operationName=${operationName^}
  
  if egrep -q -rle "$versionName"".*""$apiType"".*""$operationName" $REPO_PATH --include=*.java --exclude=*Test.java; then
    echo Operation name is $operationName, version is $versionName and apiType is $apiType >> $OUTPUT_FILE
  else
    echo not found $operationName
  fi
  
done

end=`date +%s`
runtime=$((end-start))
echo Total execution time is $runtime seconds