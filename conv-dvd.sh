#!/bin/bash

for f in *.mts; do
  ffmpeg -i $f -target ntsc-dvd -ab 192k ${f/\.mts/.mpg} && rm -v $f
done

