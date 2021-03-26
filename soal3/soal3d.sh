#!/bin/bash

tanggal=`date +%m%d%Y`

for FILE in `ls | grep 'Kelinci_\|Kucing_'`
do
	zip -rm -P $tanggal "Koleksi.zip" $FILE
	rm
done


