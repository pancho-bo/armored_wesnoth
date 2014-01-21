#!/usr/bin/env sh

# This script applies changes to the all units in the dir, and saves it to the destination directory

if [ $# -ne 4 ]
then
		echo "Usage: alter_units.sh {wml_modifier_script} {units_directory} {modify_directory} {destination_directory}"
		exit
fi

if [ ! -f $1 ]
then
		echo "Invalid wml_modifier script: $1"
		exit
fi

if [ ! -d $2 ]
then
		echo "Invalid units directory: $2"
		exit
fi

if [ ! -d $3 ]
then
		echo "Invalid modify directory: $3"
		exit
fi

if [ ! -d $4 ]
then
		echo "Invalid destination directory: $4"
		exit
fi

wml_modifier=$1
units_dir=$2
modify_dir=$3
dest_dir=$4

generic_name="GENERIC.cfg"

if [ -f $modify_dir/$generic_name ]
then
    have_generic=1
fi

for file in ${units_dir}/*.cfg
do
		unit=`basename $file`

		if [ $have_generic ] 
        then
            ${wml_modifier} ${units_dir}/${unit} ${modify_dir}/$generic_name >${dest_dir}/${unit}.tmp
		    ${wml_modifier} ${dest_dir}/${unit}.tmp ${modify_dir}/$unit >${dest_dir}/${unit}
            rm ${dest_dir}/${unit}.tmp
        else
		    ${wml_modifier} ${units_dir}/${unit} ${modify_dir}/$unit >${dest_dir}/${unit}
        fi

done
