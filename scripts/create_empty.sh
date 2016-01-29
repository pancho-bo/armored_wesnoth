#!/usr/bin/env sh

# This script creates empty units entries for editing

if [ $# -ne 2 ]
then
	echo "Usage: create_empty.sh {unit_dir} {destination_directory}"
	exit
fi

if [ ! -d $1 ]
then
		echo "Invalid unit directory: $1"
	exit
fi

if [ ! -d $2 ]
then
	echo "Invalid wesnoth destination directory: $2"
	exit
fi

unit_dir=$1
dest_dir=$2


if [ ! -d $dest_dir ]
then
		mkdir $dest_dir
fi

ls $unit_dir | while read file
do
		#b=`echo $a | sed st/t_t` 
		#b=`echo $a | sed -E st.*/tt` 

        if [ ! -f ${dest_dir}/${b}.cfg ]
        then
		    touch ${dest_dir}/${file}
        fi

done
touch ${dest_dir}/GENERIC.cfg
