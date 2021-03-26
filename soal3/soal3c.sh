#!/bin/bash

CAT_LINK="https://loremflickr.com/320/240/bunny"
i=1
tanggal=`date +%d-%m-%Y`
mkdir "Kelinci_$tanggal"

while [ $i -le 23 ]
do	
	wget -N --content-disposition $CAT_LINK -a Foto.txt
	i=$((i+1))
done


i=1

for name in `ls | grep jpg$`
do
	mv "$name" "Kelinci_$tanggal"/"Koleksi_$i.jpg"
	i=$((i+1))
done

mv Foto.txt "Kelinci_$tanggal"/
