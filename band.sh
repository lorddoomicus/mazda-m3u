#!/bin/bash
#
# band.sh
# (c) 2016 Derrik Walker v2.0
#
# This is intended to build the m3u files for each band for a collection of mp3's on a thumb drive for use in a
# Mazda Connect system. However, this should be easily adaptable to any use of creating m3u files.
#
# This will build the m3u files for individule albums assuming the following:
#
#       1. all songs are in MP3 format.
#
#       2. the are arranged as band_name/album_name/song_name{s}.mp3 relative to $CWD
#
#       3. this is run from the directory level of the band names, which is presumed to be on a thumb drive, possibly
#          even the root level of the thumbdrive.
#
#
# This is the scipt used to run the simulated tests from the blog post:
#
# http://www.doomd.net/2016/05/creating-m3u-playlist-files-for-mzd.html 
#
# This is licensed for use under the GNU General Pulbic License v2
#
# 2016-04-18	Initial version
#

echo making band level m3u files ...

for i in *
do 
	if [[ ! $i =~ \.m3u$ ]]
	then 
		echo processing $i ... 	
		cd "$i" 
			find * -name '*.mp3' -print | sort > "$i".m3u
		cd ..
	fi
done 
