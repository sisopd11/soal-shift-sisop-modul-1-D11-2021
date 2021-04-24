# soal-shift-sisop-modul-1-D11-2021
Modul 1 - Shell Script, Cron dan AWK 
|Nama|NRP|
|----|-----|
|Afifah Nur Sabrina Syamsudin|05111940000022|
|Dewi Mardani Cristin|05111940000225|
|Avind Pramana Azhari|05111940000226|

## Soal No 1
Ryujin baru saja diterima sebagai IT support di perusahaan Bukapedia. Dia diberikan tugas untuk membuat laporan harian untuk aplikasi internal perusahaan, ticky. Terdapat 2 laporan yang harus dia buat, yaitu laporan daftar peringkat pesan error terbanyak yang dibuat oleh ticky dan laporan penggunaan user pada aplikasi ticky. Untuk membuat laporan tersebut, Ryujin harus melakukan beberapa hal berikut:
(a) Mengumpulkan informasi dari log aplikasi yang terdapat pada file syslog.log. Informasi yang diperlukan antara lain: jenis log (ERROR/INFO), pesan log, dan username pada setiap baris lognya. Karena Ryujin merasa kesulitan jika harus memeriksa satu per satu baris secara manual, dia menggunakan regex untuk mempermudah pekerjaannya. Bantulah Ryujin membuat regex tersebut.
(b) Kemudian, Ryujin harus menampilkan semua pesan error yang muncul beserta jumlah kemunculannya.
(c) Ryujin juga harus dapat menampilkan jumlah kemunculan log ERROR dan INFO untuk setiap user-nya.
Setelah semua informasi yang diperlukan telah disiapkan, kini saatnya Ryujin menuliskan semua informasi tersebut ke dalam laporan dengan format file csv.
(d) Semua informasi yang didapatkan pada poin b dituliskan ke dalam file error_message.csv dengan header Error,Count yang kemudian diikuti oleh daftar pesan error dan jumlah kemunculannya diurutkan berdasarkan jumlah kemunculan pesan error dari yang terbanyak.
Contoh:
```
Error,Count
Permission denied,5
File not found,3
Failed to connect to DB,2
```
(e) Semua informasi yang didapatkan pada poin c dituliskan ke dalam file user_statistic.csv dengan header Username,INFO,ERROR diurutkan berdasarkan username secara ascending.
Contoh:
```
Username,INFO,ERROR
kaori02,6,0
kousei01,2,2
ryujin.1203,1,3
```
**Catatan :**
- Setiap baris pada file syslog.log mengikuti pola berikut:
 ```<time> <hostname> <app_name>: <log_type> <log_message> (<username>)```
- Tidak boleh menggunakan AWK

### a: Jawaban dan Penjelasan
Pada soal bagian a kita diminta untuk menampilkan informasi jenis log (ERROR/INFO), pesan log, dan username pada setiap baris lognya:
```
#!/bin/bash

grep -o '[E|I].*' syslog.log
```
berdasarkan syntax diatas `grep -o` berfungsi untuk mencari dan mencetak string yang cocok, `'[E|I].*'` merupakan syarat dari data yang ingin ditampilkan yakni dimulai dengan huruf E atau I dan diikuti kata apapun (sampai kata terakhir dari tiap baris log), dan terakhir `syslog.log` adalah nama dari file yang ingin diolah atau diambil informasinya.

Output:
- ![Gambar output bagian a](https://github.com/sisopd11/soal-shift-sisop-modul-1-D11-2021/blob/main/soal1/Screenshot%20from%202021-04-01%2013-47-29.png)

### b: Jawaban dan Penjelasan
Pada soal bagian b kita diminta untuk menampilkan peson error beserta jumlah dari tiap pesan error:
```
#!/bin/bash

grep -o 'E.*' syslog.log | cut -d"(" -f1 | sort | uniq -c
```
berdasarkan syntax diatas `grep -o` berfungsi untuk mencari dan mencetak string yang cocok, `'E.*'` merupakan syarat dari data yang ingin ditampilkan yakni dimulai dengan huruf E dan diikuti oleh kata apapun sampai kata terakhir untuk tiap baris log, `cut -d"(" -f1` digunakan untuk memotong data dimulai dengan `(` hingga seterusnya (username), `sort` berfungsi untuk mengurutkan data secara ascending (default), terakhir `uniq -c` digunakan untuk menghitung jumlah error tiap error message dan di cetak sebagai prefix.

Output:
- ![Gambar output bagian b](https://github.com/sisopd11/soal-shift-sisop-modul-1-D11-2021/blob/main/soal1/Screenshot%20from%202021-04-01%2013-49-03.png)

### c: Jawaban dan Penjelasan
Pada soal bagian c diminta untuk menampilkan jumlah log ERROR dan INFO untuk setiap user yang ada:
```
#!/bin/bash

echo Error:
grep -o 'E.*' syslog.log | cut --complement -d"(" -f1 | cut -d")" -f1 | sort | uniq -c

echo Info:
grep -o 'I.*' syslog.log | cut --complement -d"(" -f1 | cut -d")" -f1 | sort | uniq -c
```
Berdasarkan syntax diatas
- `grep -o` : mencari dan mencetak string yang cocok
- `'E.*'` : data yang ingin diambil diawali huruf E dan diikuti kata apapun (log ERROR)
- `'I.*'` : data yang ingin diambil diawali huruf I dan diikuti kata apapun (log INFO)
- `cut --complement -d"(" -f1` : memotong data yang dimulai dengan `(` namun mengambil data lengkap setelah nya.
- `cut -d")" -f1` : memotong data sampai batasan akhir
- `sort` : mengurutkan data secara ascending (default)
- `uniq -c` : menghitung jumlah error tiap error message dan di cetak sebagai prefix

Output:
- ![Gambar output bagian c](https://github.com/sisopd11/soal-shift-sisop-modul-1-D11-2021/blob/main/soal1/Screenshot%20from%202021-04-01%2013-49-33.png)

### d: Jawaban dan Penjelasan
Pada soal bagian d diminta untuk menuliskan data pada bagian b ke dalam file error_message.csv dengan header Error,Count yang kemudian diikuti oleh daftar pesan error dan jumlah kemunculannya diurutkan berdasarkan jumlah kemunculan pesan error dari yang terbanyak:
```
#!/bin/bash

printf 'Error, Count\n' > error_message.csv

grep "E.*" syslog.log | cut -d' ' -f7- | cut -d'(' -f1 | sort | uniq -c | sort -nr | tr -d '[0-9]' | sed -e 's/^[[:space:]]*//' > message.csv
grep "E.*" syslog.log | cut -d' ' -f7- | cut -d'(' -f1 | sort | uniq -c | sort -nr | grep -Eo '[0-9]{1,}' > count.csv

paste message.csv count.csv | while IFS="$(printf '\t')" read -r f1 f2
do
  printf "$f1,$f2\n"
done >> error_message.csv

rm message.csv
rm count.csv
```
berdasarkan syntax diatas:
membuat dan mengambil data
- `printf 'Error, Count\n' > error_message.csv` : assign header ke dalam file `error_message.csv`
- `sort -nr` : mengurutkan data secara descending (nilai terbesar >> nilai terkecil)
- `tr -d '[0-9]'` : mengabaikan data yang berupa angka
- `sed -e 's/^[[:space:]]*//' > message.csv` : menghapus spasi pada awal kalimat error message dan menyimpan ke `message.csv` 
- `grep -Eo '[0-9]{1,}' > count.csv ` : mengambil data berupa angka dan menyimpan ke file `count.csv`
- `rm` : menghapus file yang sudah tidak dibutuhkan, contohnya message.csv dan count.csv

menginputkan ke dalam file `error_message.csv`
- `paste message.csv count.csv` : menduplikat data yang ada di file
- `while IFS="$(printf '\t')" read -r f1 f2` : data yang telah di copy di assign (simpan) ke dalam variabel `f1` dan `f2`
```
do
  printf "$f1,$f2\n"
done >> error_message.csv 
```
- menampilkan data yang ada pada variabel `f1` dan `f2`, kemudian di simpan ke dalam file `error_message.csv`

Output:
- ![Gambar output bagian d](https://github.com/sisopd11/soal-shift-sisop-modul-1-D11-2021/blob/main/soal1/Screenshot%20from%202021-04-01%2013-46-18.png)

### e: Jawaban dan Penjelasan
Pada soal bagian e diminta untuk menuliskan bagian e dituliskan ke dalam file user_statistic.csv dengan header Username,INFO,ERROR diurutkan berdasarkan username secara ascending.
```
#!/bin/bash

printf 'Username, INFO, ERROR\n' > user_statistic.csv

cat syslog.log | cut -d'(' -f2- | cut -d')' -f1 | sort | uniq -c | sort -nr | tr -d '[0-9]' | sed -e 's/^[[:space:]]*//' > user.csv
grep "E.*" syslog.log | cut -d'(' -f2- | cut -d')' -f1 | sort | uniq -c | sort -nr | grep -Eo '[0-9]{1,}' > count_error.csv
grep "E.*" syslog.log | cut -d'(' -f2- | cut -d')' -f1 | sort | uniq -c | sort -nr | tr -d '[0-9]' | sed -e 's/^[[:space:]]*//' > user_error.csv
grep "I.*" syslog.log | cut -d'(' -f2 | cut -d')' -f1 | sort | uniq -c | sort -nr | grep -Eo '[0-9]{1,}' > count_info.csv
grep "I.*" syslog.log | cut -d'(' -f2 | cut -d')' -f1 | sort | uniq -c | sort -nr | tr -d '[0-9]' | sed -e 's/^[[:space:]]*//' > user_info.csv

while read username
do
  user="$username"
  info=0
  error=0
  
  paste count_error.csv user_error.csv | (while read counterror usererror
  do
    if [ "$user" == "$usererror" ]
     then 
         error=$counterror 
         break
    fi
  done
  
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

rm user.csv
rm count_error.csv
rm user_error.csv
rm count_info.csv
rm user_info.csv
```
berdasarkan syntax diatas:
mencari data username, jumlah error dan info, dan username yang memiliki data error atau info
- `line 5` : mengambil username dan menyimpan di `user.csv`
- `line 6` : menghitung jumlah error dan menyimpan di `count_error.csv`
- `line 7` : mengambil username yang memiliki data log ERROR dan menyimpan di `user_error.csv`
- `line 8` : menghitung jumlah info dan menyimpan di `count_info.csv`
- `line 9` : mengambil username yang memiliki data log ERROR dan menyimpan di `user_info.csv`

mengolah data
```
user="$username"
info=0
error=0
```
- inisialisasi variabel user dengan data username
- inisialisasi nilai awal dari error dan info sama dengan `0`.

```
paste count_error.csv user_error.csv | (while read counterror usererror
do
   if [ "$user" == "$usererror" ]
    then
        error=$counterror 
        break
   fi
done
```
- menduplikat data yang ada di file `count_error.csv` dan `user_error.csv`
- memeriksa jika data username yang memiliki data error sama dengan data username maka akan assign jumlah info ke info

```
paste count_info.csv user_info.csv | (while read countinfo userinfo
do
  if [ "$user" == "$userinfo" ]
   then 
       info=$countinfo 
       break
  fi
done
```
- menduplikat data yang ada di file `count_info.csv` dan `user_info.csv`
- memeriksa jika data username yang memiliki data info sama dengan data username maka akan meng assign jumlah error ke error

`printf "$user,$info,$error\n" >> user_statistic.csv`
- menampilkan data yang ada pada variabel `user`, `info` dan `error`, kemudian di simpan ke dalam file `user_statistic.csv`

Output:
- ![Gambar output bagian e](https://github.com/sisopd11/soal-shift-sisop-modul-1-D11-2021/blob/main/soal1/Screenshot%20from%202021-04-01%2013-45-46.png)

## Kendala yang dihadapi
1. Tidak bisa melakukan inisialisasi data dan penggunaan regex gagal sehingga menggunakan perintah grep
2. Pada soal bagian a, ketika menukar urutan syarat `'[E|I].*'` menjadi `'[I|E].*'` hanya dimunculkan huruf I dan E secara random.
3. Saat menghitung jumlah error tanpa `sort` yang dimunculkan adalah total error
4. Pada bagian d dan e, saat ingin menyimpan jawaban bagian b dan c dengan variabel tidak ada data yang muncul pada file csv.
