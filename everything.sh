#!/bin/bash
#
# everything.sh
# (c) 2016 Derrik Walker v2.0
#
# This is intended to build the m3u files for everything in a collection of mp3's on a thumb drive for use in a     
# Mazda Connect system. However, this should be easily adaptable to any use of creating m3u files.
#
# This one makes the everything.m3u and random.m3u files in the root level of $PWD
#
# This will build the m3u files for individule albums assuming the following:
#
#  	1. all songs are in MP3 format. 
#
#  	2. the are arranged as band_name/album_name/song_name{s}.mp3 relative to $CWD
#
#  	3. this is run from the directory level of the band names, which is presumed to be on a thumb drive, possibly
#	   even the root level of the thumbdrive.
#
#
# This is the scipt goes with the blog post:
#
# http://www.doomd.net/2016/05/creating-m3u-playlist-files-for-mzd.html 
#
# This is licensed for use under the GNU General Pulbic License v2
#
# 2016-04-18	DW2	Initial version
# 2016-06-10	DW2	Made the random playlist "random"	
# 2016-06-26	DW2	Sorted the "everything" m3u by song title
#

#
# stuff to be excluded from random playlist
#
excl="(live) (demo) '[demo]' '[live]'"
exlf=/tmp/e.txt
echo $excl | tr  " " "\n" > $exlf 

echo making everything ...
file=$(mktemp)

for song in */*/*.mp3
do
	title=$( eyeD3 --no-color "$song" 2>/dev/null | grep  '^title:' )
	echo "${title}+${song}" >> $file
done

sort -d $file | awk -F'+' '{print $2}' > everything.m3u	

echo making random ...

find * -name "*.mp3" -print | grep -i -v -f $exlf | sort -R > random.m3u
