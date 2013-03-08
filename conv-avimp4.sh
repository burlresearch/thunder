#!/bin/bash

dest=mp4
if [ -n "$1" ]; then
  dest=$1
fi

mkdir -p $dest
for f in *avi; do
  mp4=${f/\.avi/.mp4}
  mp4=$dest/${mp4// /_}
  [ ! -f $mp4 ] && ffmpeg -y -i "$f" -vcodec libx264 -vpre thunder -aspect 3:2 -deinterlace -ab 157K "$mp4"
  # ffmpeg -i $f -qscale 5 -b 10010 -r 25 -ab 94K $mp4
  # ffmpeg -i $f -vcodec libx264 -vpre thunder -ab 128k -y $mp4
done
