#!/bin/bash

cat neighborhoods.csv | tail -n +2 | tr -d '\r' | while IFS=, read id url
  do
    if [ -n "$id" ] && [ -n "$url" ]
      then
      RENAME="${url//\"/}"
      RENAME="${RENAME//"%0D"/}"
      echo "downloading: ${id}, ${RENAME}"
      wget -O n${id}.jpg ${RENAME}
      convert n${id}.jpg -resize 10x n${id}m.jpg
      convert n${id}.jpg -resize 100x n${id}.jpg
    else
      echo "skipped: ${id}"
    fi
  done
