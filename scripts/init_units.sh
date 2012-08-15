#!/usr/bin/env sh

# This script renames units in directory to ARERA_unit and changes its ID

if [ $# -ne 1 ]
then
	echo "Usage: init_units.sh {directory}"
	exit
fi

if [ ! -d $1 ]
then
	echo "Invalid directory: $1"
	exit
fi

prev_dir=`pwd`
dir=$1

cd $dir

for i in *
do
		if echo $i | grep -q "ARERA"
		then
				continue
		fi
		if [ -f ARERA_$i ]
		then
				rm $i
				continue
		fi
		cat $i | sed -E "s/id=(ARERA_)?/id=ARERA_/g" >ARERA_$i
		rm $i
done

cd $prev_dir
