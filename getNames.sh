#! /bin/sh


COM="##"
IFS='
'

dir="/multimedia/audio/music"
albf="albums.txt"
globf="allmusic.txt"

# move the old files
[ -f "$albf" ] && mv "$albf" "$albf.ret"
[ -f "$globf" ] && mv "$globf" "$globf.ret"

# introduce the new meta files
printf "${COM} album tags and names of all music files in my control\n" >> "$albf"
printf "${COM} this file is automagically generated, do not edit\n\n\n" >> "$albf"

printf "${COM} names of all music files in my control\n" >> "$globf"
printf "${COM} this file is automagically generated, do not edit\n\n\n" >> "$globf"

# append all the albums
printf "%s\n" "${COM} albums" >> "$albf"
for aldir in `find "$dir" -type d -links 2 | sort`; do
  album=`expr "$aldir" : "$dir/\(.*\)"`
  printf "%s\n" "[$album]" >> "$albf"
done
printf "\n\n${COM} songs\n" >> "$albf"

# iterate over all leaf music directories
for aldir in `find "$dir" -type d -links 2 | sort`; do
  # get the album name
  album=`expr "$aldir" : "$dir/\(.*\)"`
  # append the song names
  printf "%s\n" "[$album]" >> "$albf"
  ls -w 1 "$aldir"/* | sed 's/\/.*\///g' >> "$albf"
  ls -w 1 "$aldir"/* | sed 's/\/.*\///g' >> "$globf"
  printf "\n" >> "$albf"
done

# sort the glob file
cat "$globf" | sed "4q" >> "$globf.head"
cat "$globf" | tail -n +5 | sort >> "$globf.tail"
cat "$globf.head" "$globf.tail" > "$globf"
[ -f "$globf.head" ] && rm "$globf.head"
[ -f "$globf.tail" ] && rm "$globf.tail"

