#!/bin/sh

##
# set -x for debug output
set
+x



##
# Variables
currentDate=$(date +%Y-%m-%d)

cp "$1" "./copybook_tmp_$currentDate.txt"
file="./copybook_tmp_$currentDate.txt"
previousLevel="-1"

#Pile is a FILO
pile=""
operation=""

while read line; do

	#Only work on lines which have leading numbering
 	currentLevel=$(echo "$line" | sed 's/^[ \t]*\([0-9]*\).*$/\1/')

	if [ "$currentLevel" != "" ]; then
		#Level
		if [ "$currentLevel" -eq "$previousLevel" ]; then
			#echo -n "+"
			operation="$operation+"
		elif [ "$currentLevel" -lt "$previousLevel" ]; then
			topPile=""
			while [ "$topPile" != "$currentLevel" ]; do
				topPile=$(echo $pile | cut -d: -f1)
				pile=$(echo "$pile" | sed 's/[0-9]*:\(.*\)/\1/')
				#echo -n ")"
				operation="$operation)"
			done
			#echo -n "+"
			operation="$operation+"
		fi

		previousLevel=$currentLevel

		#Data line
		if [ "$(echo "$line" | grep "(")" != "" ]; then
			#echo -n "$line" | sed 's/.*(\(.*\))\.*$/\1/'
			operation="$operation$(echo -n "$line" | sed 's/.*(\(.*\)).*\.*$/\1/')"
		#Level/Occurence line
		else
			#Level or Occurrence line?
			occurrence="1"
			if [ "$(echo "$line" | grep "TIMES")" != "" ]; then
				occurrence="$(echo "$line" | sed 's/[0-9]*.* \([0-9]*\) TIMES\.*$/\1/')"
			fi
			#echo -n "$occurrence*("

			operation="$operation$occurrence*("
			pile="$currentLevel:$pile"
		fi
	fi

done < "$file"



#need to close the )

while [ "$pile" != "" ]; do
	pile=$(echo "$pile" | sed 's/[0-9]*:\(.*\)/\1/')
	#echo -n ")"
	operation="$operation)"
done


echo -en "\nOperation breakdown: $operation\nPayload size: $(echo "$operation" | bc)"
