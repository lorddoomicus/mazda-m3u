#!/bin/bash
#
# album.sh                                                                                                                  
# (c) 2016 Derrik Walker v2.0
#
# This is intended to build the m3u files for individual albums for a collection of mp3's on a thumb drive for use in a     
# Mazda Connect system. However, this should be easily adaptable to any use of creating m3u files. 
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
# This is the scipt goes with the blog post:
#
# http://www.doomd.net/2016/05/creating-m3u-playlist-files-for-mzd.html 
#
# This is licensed for use under the GNU General Pulbic License v2
#
# 2016-04-24	DW2	Initial Version
# 2016-05-28	DW2	Added nulling files before building
# 2017-10-26	dw2	Added support for pls files from Rhythmbox
#

for band in *
do
	#
	# First, ignore any existing m3u files
	#
	if [[ ! $band =~ \.m3u$  && ! $band =~ \.pls ]]
	then 
		cd "$band"

		for album in *
		do
			unset list
			declare -a list	

			if [[ ! $album =~ \.m3u$ ]]
			then
				cd "$album"
				echo processing $band - $album ... 	

				for song in *.mp3
				do
					track=$( eyeD3 --no-color "$song" 2>/dev/null | grep -oP '^track: \K\d+' )
					disc=$( eyeD3 --no-color "$song" 2>/dev/null | grep -oP '^disc: \K\d+' )

					#
					# this is a clever trick to make sure that albums with multiple discs are listed
					# in the correct order so that higher numbered discs follow lower numbered ones 
					#
					if [ -z $disc ]; then disc=1 ; fi	# incase there is no disc information 

					index=$(( disc*100 + track )) 
					list[$index]="$song"
				done

				> "$album".m3u 	# incase it alreay exists for some reason

				#
				# have to get the list of indexes for the list, and sort them in numerical order
				# so that the tracks are put in the correct order
				#
				for i in $( echo ${!list[@]} | sort -n )
				do
				 	echo "${list[$i]}" >> "$album".m3u
				done
		
				cd ..	# back to album list
			fi
		done

		cd ..	# back to band list
	fi
done 
