#!/bin/bash

# Convert Sentinel-2 images into tif
# Before using unzip folders with data:
# unzip \*.zip

ls | egrep 'S2[AB]_MSIL1C_\d*' > folders.txt

cat folders.txt | while read line
do
    path=$line'/GRANULE/'$(ls $line'/GRANULE/')'/IMG_DATA'
    arrTST=(${path//_/ })
    pref=${arrTST[5]}_${arrTST[2]}_B0
    prefix=$path/$pref
    gdalbuildvrt -separate TCI.vrt ${prefix}2.jp2 ${prefix}3.jp2 ${prefix}4.jp2
    gdal_translate -ot Byte -co TILED=YES -scale 0 4096 0 255 TCI.vrt $pref.tif

done

