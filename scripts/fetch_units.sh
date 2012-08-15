#!/usr/bin/env sh

# This script fetches the units from the game directory to "../units"

if [ $# -ne 2 ]
then
		echo "Usage: fetch_units.sh {wesnoth_data_directory} {destination_directory}"
		exit
fi

if [ ! -d $1 ]
then
		echo "Invalid wesnoth data directory: $1"
		exit
fi

if [ ! -d $2 ]
then
		echo "Invalid wesnoth destination directory: $2"
		exit
fi

data_dir=$1
dest_dir=$2

cat unit_list| while read unit    
do
		if [ `find $data_dir | grep "/{$unit}.cfg" | wc -l` -gt 1 ]
		then
				echo "Warning! Ambigious unit $unit"
		fi

		if [ ! -f ${dest_dir}/${unit}.cfg ]
		then
			unit_file=`find $data_dir | grep "/${unit}.cfg"`
			#extended_unit_name=`echo ${unit_file} | sed "s%${data_dir}%%g" | sed st/t_t`
			cp ${unit_file} ${dest_dir}
		fi
done
