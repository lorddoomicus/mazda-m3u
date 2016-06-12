# Playlists for the Mazda Connect Infotainment System in the Mazda 3

These are some example scripts for creating m3u playlist files on the Mazda Connect System.  

For more information, see this blog post:

http://www.doomd.net/2016/05/creating-m3u-playlist-files-for-mzd.html

## Assumptions for these to work correctly

- All songs are in MP3 format

- The are arranged as band_name/album_name/song_name{s}.mp3 relative to $CWD

- This is run from the directory level of the band names, which is presumed to    be on a thumb drive, possibly even the root level of the thumb drive.

- These are run on a relatively modern Linux system with eyeD3 installed.

## Files

- everything.sh
	- This will create two playlists: 1) a list of every mp3 and 2) a 'random' list with files optionally removed from the everything list

- band.sh
	- This will create a list of everything by a given band and leave it in the folder for the band.  

- album.sh  
	- This will create one m3u file per album, for every album in $PWD.

- year.sh
	- This will create a m3u file for a specied range of years in the same level as everything.sh does

- remall.sh
	- this will clean up all the m3u files from $PWD down.

## Final Thoughts
While this is being developed for use with the Mazda Connect system in my car, there is no reason why it can't be easily adapted to almost any use where playlist files in the m3u format are needed.

## License

All files are covered under the GNU General Public License v2.

(c) 2016 Derrik Walker v2.0, dwalker@doomd.net
