#!/bin/bash

#No1_a
#Ambil data kata depan E or I sampe seterusnya bebas dari file syslog.log
grep -o '[E|I].*' syslog.log

#No1_b
#Ambil data log Error tapi bagian username di cut, urut abc, sama hitung banyak errornya
grep -o 'E.*' syslog.log | cut -d"(" -f 1| sort | uniq -c

#No1_c
#Ambil data log error cuma jumlah error sama username
echo Error:
grep -o 'E.*' syslog.log | cut --complement -d"(" -f 1 | cut -d")" -f 1 | sort | uniq -c
#Ambil data log info cuma jumlah info sama username
echo Info:
grep -o 'I.*' syslog.log | cut --complement -d"(" -f 1 | cut -d")" -f 1 | sort | uniq -c

#No1_d
#File error_message #OK
echo 'Error, Count' > 'error_message.csv'

#Ambil error messages sama jumlah #FAIL
grep -o 'E.*' syslog.log | sort | uniq -c | sort -nr while read myfile
#Divide error sama jumlah
do
	#ambil error
	error=($(echo $myfile | cut =d " " -f 2-)
	#ambil jumlah
	count=($(echo $myfile | cut -d " " -f 1 )
	echo "$error, $count"
done >> 'error_message.csv' 
#No1_e
