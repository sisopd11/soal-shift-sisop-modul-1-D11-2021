#!/bin/bash

#a
# Ambil data kata depan E or I sampe seterusnya bebas dari file syslog.log
grep -o '[E|I].*' syslog.log 
printf "\n"

#b
# Ambil data log Error tapi bagian username di cut, urut abc, sama hitung banyak errornya
grep -o 'E.*' syslog.log | cut -d"(" -f1| sort | uniq -c
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

#e
# File user_statistic.csv #OKKK
printf 'Username, INFO, ERROR\n' > user_statistic.csv

# Save user ke user.csv
cat syslog.log | cut -d'(' -f2- | cut -d')' -f1 | sort | uniq -c | sort -nr | tr -d '[0-9]' | sed -e 's/^[[:space:]]*//' > user.csv
# Save hasil count error for each user ke count_error.csv
grep "E.*" syslog.log | cut -d'(' -f2- | cut -d')' -f1 | sort | uniq -c | sort -nr | grep -Eo '[0-9]{1,}' > count_error.csv
# Save user yang memiliki error ke user_error.csv
grep "E.*" syslog.log | cut -d'(' -f2- | cut -d')' -f1 | sort | uniq -c | sort -nr | tr -d '[0-9]' | sed -e 's/^[[:space:]]*//' > user_error.csv
# Save hasil count info for each user ke count_info.csv
grep "I.*" syslog.log | cut -d'(' -f2 | cut -d')' -f1 | sort | uniq -c | sort -nr | grep -Eo '[0-9]{1,}' > count_info.csv
# Save user yang memiliki info ke user_info.csv
grep "I.*" syslog.log | cut -d'(' -f2 | cut -d')' -f1 | sort | uniq -c | sort -nr | tr -d '[0-9]' | sed -e 's/^[[:space:]]*//' > user_info.csv
while read username
do
  user="$username"
  info=0
  error=0
  #compare user yang memiliki error dengan data user only
  paste count_error.csv user_error.csv | (while read counterror usererror
  do
    if [ "$user" == "$usererror" ]
     then 
         error=$counterror 
         break
    fi
  done
  #compare user yang memiliki info dengan data user only 
  paste count_info.csv user_info.csv | (while read countinfo userinfo
  do
    if [ "$user" == "$userinfo" ]
     then 
         info=$countinfo 
         break
    fi
  done

 printf "$user,$info,$error\n" >> user_statistic.csv))
done < user.csv

#Hapus file temporary
rm user.csv
rm count_error.csv
rm user_error.csv
rm count_info.csv
rm user_info.csv
