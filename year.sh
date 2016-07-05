#!/bin/bash
#
# year.sh
# (c) 2016 Derrik Walker v2.0
#
# This is intended to build the m3u files for a given year range for a collection of mp3's on a thumb 
# drive for use in a Mazda Connect system. However, this should be easily adaptable to any use of creating m3u files. 
#
# This will build the m3u files assuming the following:
#
#  	1. all songs are in MP3 format. 
#
#  	2. the are arranged as band_name/album_name/song_name{s}.mp3 relative to $CWD
#
#  	3. this is run from the directory level of the band names, which is presumed to be on a thumb drive, possibly
#	   even the root level of the thumbdrive.
#
# This is the scipt goes with the blog post:
#
# http://www.doomd.net/2016/05/creating-m3u-playlist-files-for-mzd.html 
#
# This is licensed for use under the GNU General Pulbic License v2
#
# 2016-06-10	DW2	Initial Version
# 2016-06-25	DW2	Sorted the m3u by song title
#

#
# Handle cmd arguments
#
if [[ $# -lt 1 || $# -gt 2 ]]
then
	echo "ERRR!!! arg error!"
	exit 1
fi

year1=$1
year2=$2

if ! [[ "$year1" =~ ^[0-9]+$ ]]
then
	echo "ERRR!!! Year error!"
	exit 2
fi

if ! [[ "$year2" =~ ^[0-9]+$ ]]
then
	echo "ERRR!!! Year error!"
	exit 3
fi

if [[ $year1 -lt 1900 || $year2 -gt $(date +%Y) || $year1 -gt $year2 ]]
then
	echo "ERRR!!! Year error!"
 	exit 4
fi

echo searching for years $year1 to $year2

if [[ $year1 -eq $year2 ]]
then
	m3u="$year1.m3u"
else
	m3u="$year1-$year2.m3u"
fi

file=$(mktemp)

echo m3u file is $m3u and file is $file

#
# now we can process the mp3 files
#

for band in *
do
	#
	# Ignore any existing m3u files
	#
	if [[ ! $band =~ \.m3u$ ]]
        then
                cd "$band"

                for album in *
                do
                        # unset list
                        # declare -a list

                        if [[ ! $album =~ \.m3u$ ]]
                        then
                                cd "$album"
                                echo processing $band - $album ...

                                for song in *.mp3
                                do

					year=$( eyeD3 --no-color "$song" 2>/dev/null | grep -oP '^recording date: \K\d+' )

					# echo -n $year
					
					if [[ $year -ge $year1 && $year -le $year2 ]]
					then 
						title=$( eyeD3 --no-color "$song" 2>/dev/null | grep  '^title:' )
						echo "${title}+${band}/$album/$song" >> $file
					fi
				done

				cd .. # back to album list
			fi
		done
		
		cd ..	# back to band list
	fi
done

sort -d  $file | awk -F'+' '{print $2}' > $m3u
