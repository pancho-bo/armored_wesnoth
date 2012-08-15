#!/usr/bin/env sh

# This script applies changes to the all units in the dir, and saves it to the destination directory

if [ $# -ne 2 ]
then
		echo "Usage: install_units.sh {units_directory} {destination_directory}"
		exit
fi

if [ ! -d $1 ]
then
		echo "Invalid units directory: $1"
		exit
fi

if [ ! -d $2 ]
then
		echo "Invalid destination directory: $2"
		exit
fi

units_dir=$1
dest_dir=$2

for file in ${units_dir}/*.cfg
do
		install $file ${dest_dir}
done
