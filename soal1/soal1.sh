#!/bin/bash

#a
# Ambil data kata depan E or I sampe seterusnya bebas dari file syslog.log
grep -o '[E|I].*' syslog.log 
printf "\n"

#b
# Ambil data log Error tapi bagian username di cut, urut abc, sama hitung banyak errornya
grep -o 'E.*' syslog.log | cut -d"(" -f 1| sort | uniq -c
printf "\n"

#c
# Ambil data log error cuma jumlah error sama username
echo Error:
grep -o 'E.*' syslog.log | cut --complement -d"(" -f1 | cut -d")" -f 1 | sort | uniq -c

# Ambil data log info cuma jumlah info sama username
echo Info:
grep -o 'I.*' syslog.log | cut --complement -d"(" -f1 | cut -d")" -f 1 | sort | uniq -c
printf "\n"

#d
# File error_message #OK
printf 'Error, Count\n' > error_message.csv

# Save error message
grep "E.*" syslog.log | cut -d' ' -f7- | cut -d'(' -f1 | sort | uniq -c | sort -nr | tr -d '[0-9]' | sed -e 's/^[[:space:]]*//' > message.csv

# Save count error for each message
grep "E.*" syslog.log | cut -d' ' -f7- | cut -d'(' -f1 | sort | uniq -c | sort -nr | grep -Eo '[0-9]{1,}' > count.csv

# Assign message.csv and count.csv ke f1 dan f2
paste message.csv count.csv | while IFS="$(printf '\t')" read -r f1 f2
do
  printf "$f1,$f2\n"
done >> error_message.csv

#Hapus file temporary
rm message.csv
rm count.csv

#No1_e
#File user_statistic.csv #OK
echo 'Username,INFO,ERROR' > 'error_message.csv'
