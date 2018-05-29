#!/bin/bash
echo "Welcome to photoMover."

dir=$1
date=$2

if [ -d "$dir" ]; then
echo "This is  a valid directory"
else
echo "This is not a valid directory, please try again."
exit
fi

#run through dir
for i in "$dir"/*
do

#get filename
filename="${i##*/}"

#get creation date
creationdate=$(ls -l --time-style='+%d-%m-%y' "$i" | awk '{print $6}')
weeknum=$(date -d "$creationdate" +%V)
monthnum=$(date -d "$creationdate" +%m)

#check if file is older than a week 
if [ "$date" == "week" ]; then
if [[ $(find "$filename" -mtime +7 -print) ]]; then

#make directory
if [ ! -d "$dir/week/$weeknum" ]; then
mkdir "$dir/week/$weeknum"
fi

#copy file
cp "$i" "$dir/week/$weeknum/$filename"

#get hash
originalhash=$(md5sum "$i" | cut -d " " -f1)
movedhash=$(md5sum "$dir/week/$weeknum/$filename" | cut -d " " -f1)

#check hash and remove original file
if [ "$originalhash" == "$movedhash" ]; then
rm "$i"
fi

fi
fi

#check if file is older than a month
if [ "$date" == "month" ]; then
if [[ $(find "$filename" -mtime +30 -print ]]; then

#make directory
if [ ! -d "$dir/month/$monthnum" ]; then
mkdir "$dir/month/$monthnum"
fi

#copy file
cp "$i" "$dir/month/$monthnum/$filename"

#get hash
originalhash=$(md5sum "$i" | cut -d " " -f1)
movedhash=$(md5sum "$dir/month/$monthnum/$filename" | cut -d " " -f1)

#check hash and remove original file
if [ "$originalhash" == "$movedhash" ]; then
rm "$i"
fi

fi
fi

done
