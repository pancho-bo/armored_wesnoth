#!/usr/bin/env sh

# This script creates empty units entries for editing

if [ $# -ne 2 ]
then
	echo "Usage: create_empty.sh {unit_list} {destination_directory}"
	exit
fi

if [ ! -f $1 ]
then
		echo "Invalid wesnoth unit list file: $1"
	exit
fi

if [ ! -d $2 ]
then
	echo "Invalid wesnoth destination directory: $2"
	exit
fi

unit_list=$1
dest_dir=$2


if [ ! -d $dest_dir ]
then
		mkdir $dest_dir
fi

cat $unit_list | while read a
do
		#b=`echo $a | sed st/t_t` 
		b=`echo $a | sed -E st.*/tt` 
		touch ${dest_dir}/${b}.cfg
done
