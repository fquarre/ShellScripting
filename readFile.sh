#!/bin/bash
expectedNum=13
errorFile="errorFile.csv"
goodFile="goodFile.csv"
while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "Text read from file: $line"
	count="grep -o "[,]" <<<"$line" | wc -l"
	 if [ "$count" -gt "$expectedNum" ]; then
		echo "$line" >> $errorFile
	 else
		echo "$line" >> $goodFile
	 fi
done < "$1"
