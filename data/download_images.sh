#!/bin/bash

cat transcripts.csv | tail -n +2 | tr -d '\r' | while IFS=, read id url
  do
    if [ -n "$id" ] && [ -n "$url" ]
      then
      RENAME="${url//\"/}"
      RENAME="${RENAME//"%0D"/}"
      echo "downloading: ${id}, ${RENAME}"
      if [ "${url}" == '"https://s3.amazonaws.com/oral-history/images/default.png"' ]
        then
        echo "png!"
        wget -O ${id}.png ${RENAME}
        convert ${id}.png ${id}.jpg
        convert ${id}.jpg -resize 100x ${id}.jpg
        convert ${id}.jpg -resize 10x ${id}m.jpg
        rm ${id}.png
      else
        echo "jpg!"
        wget -O ${id}.jpg ${RENAME}
        convert ${id}.jpg -resize 10x ${id}m.jpg
        convert ${id}.jpg -resize 100x ${id}.jpg
      fi
    else
      echo "skipped: ${id}"
    fi
  done
