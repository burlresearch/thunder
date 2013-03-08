#!/bin/bash

# SRC: '/Volumes/SONY 3/PRIVATE/AVCHD/BDMV/STREAM'
# DST: '/Volumes/GoFlex Home Public/ThunderBayVideo'

if [ -n "$1" ]; then
  dest=$1
else
  dest=mp4
fi

PS3='Codec: '
select codec in "mpeg4" "libx264" "mpeg4_fast" "mpeg_480"; do
  case $codec in
    "mpeg4") codec="-qscale 5 -b 10010 -r 25 -s hd720 -ab 128k" ;;
    "libx264") codec="-vcodec libx264 -vpre thunder -s hd720 -r 25 -ab 128k" ;;
    "mpeg4_fast") codec="-qscale 9 -b 10010 -r 25 -s hd720 -ab 128k" ;;
    "mpeg_480") codec="-qscale 9 -b 10010 -r 25 -s hd480 -ab 128k" ;;
  esac
  break
done

mkdir -p $dest
for f in *mts; do
  mp4=${f/\.mts/.mp4}
  mp4=$dest/${mp4// /_}
  [ ! -f $mp4 ] && ffmpeg -i "$f" $codec $mp4
done

