#!/bin/bash


tanggal=`date +%d-%m-%Y`
CURDAY=`date +%d`


if [ $(( $CURDAY % 2 )) -eq 1 ]
then
	CAT_LINK="https://loremflickr.com/320/240/bunny"
	mkdir "Kelinci_$tanggal"
	i=1

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

else
	CAT_LINK="https://loremflickr.com/320/240/kitten"
	mkdir "Kucing_$tanggal"
	i=1

	while [ $i -le 23 ]
	do	
		wget -N --content-disposition $CAT_LINK -a Foto.txt
		i=$((i+1))
	done


	i=1

	for name in `ls | grep jpg$`
	do
		mv "$name" "Kucing_$tanggal"/"Koleksi_$i.jpg"
		i=$((i+1))
	done

	mv Foto.txt "Kucing_$tanggal"/
fi
