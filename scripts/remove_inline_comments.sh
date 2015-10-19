#!/usr/bin/env sh

# This script will remove inline comments from unit files, as it still can not be handled properly by wml_action

if [ $# -ne 1 ]
then
		echo "Usage: remove_inline_comments.sh {units_directory}" 
		exit
fi

if [ ! -d $1 ]
then
		echo "Invalid units directory: $1"
		exit
fi


units_dir=$1

for file in ${units_dir}/*.cfg
do
  sed -e "s/# wmllint.*$//g" -i "" ${file}
  sed -e "s/### .*$//g" -i "" ${file}
done
