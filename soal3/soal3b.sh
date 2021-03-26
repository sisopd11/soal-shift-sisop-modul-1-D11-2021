#!/bin/bash


tanggal=`date +%d-%m-%Y`
mkdir "Kucing_$tanggal"
i=1

for name in `ls | grep jpg$`
do
	mv "$name" "Kucing_$tanggal"/
	i=$((i+1))
done

mv Foto.txt "Kucing_$tanggal"/
