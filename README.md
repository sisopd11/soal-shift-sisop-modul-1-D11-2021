# soal-shift-sisop-modul-1-D11-2021
Modul 1 - Daemon dan Proses 
|Nama|NRP|
|----|-----|
|Afifah Nur Sabrina Syamsudin|05111940000022|
|Dewi Mardani Cristin|05111940000225|
|Avind Pramana Azhari|05111940000226|

## Soal No 1
Ranora adalah mahasiswa Teknik Informatika yang saat ini sedang menjalani magang di perusahan ternama yang bernama “FakeKos Corp.”, perusahaan yang bergerak dibidang keamanan data. Karena Ranora masih magang, maka beban tugasnya tidak sebesar beban tugas pekerja tetap perusahaan. Di hari pertama Ranora bekerja, pembimbing magang Ranora memberi tugas pertamanya untuk membuat sebuah program. 

(a) Membuat sebuah program C yang dimana setiap 40 detik membuat sebuah direktori dengan nama sesuai timestamp **[YYYY-mm-dd_HH:ii:ss]**.

(b) Tiap-tiap folder lalu diisi dengan 10 gambar yang di download dari
**https://picsum.photos/**, dimana tiap gambar di download setiap 5 detik. Tiap
gambar berbentuk persegi dengan ukuran _**(t%1000)+50**_ piksel dimana t adalah
detik Epoch Unix. Gambar tersebut diberi nama dengan format timestamp **[YYYY-
mm-dd_HH:ii:ss]**.

(c) Setelah direktori telah terisi dengan 10 gambar, program tersebut akan membuat sebuah file **“status.txt”**,
dimana didalamnya berisi pesan **“Download Success”** yang terenkripsi dengan teknik Caesar Cipher dan dengan shift 5.
Caesar Cipher adalah Teknik enkripsi sederhana yang dimana dapat melakukan enkripsi string sesuai dengan shift/key yang kita tentukan.
Misal huruf “A” akan dienkripsi dengan shift 4 maka akan menjadi “E”. Karena Ranora orangnya perfeksionis dan rapi,
dia ingin setelah file tersebut dibuat, direktori akan di zip dan direktori akan didelete, sehingga menyisakan hanya file zip saja.

(d) Untuk mempermudah pengendalian program, pembimbing magang Ranora ingin program tersebut akan men-generate sebuah program “Killer” yang executable,
dimana program tersebut akan menterminasi semua proses program yang sedang berjalan dan akan menghapus dirinya sendiri setelah program dijalankan.
Karena Ranora menyukai sesuatu hal yang baru, maka Ranora memiliki ide untuk program “Killer” yang dibuat nantinya harus merupakan **program bash**.

(e) Pembimbing magang Ranora juga ingin nantinya program utama yang dibuat Ranora dapat dijalankan di dalam dua mode.
Untuk mengaktifkan mode pertama, program harus dijalankan dengan argumen -z, dan Ketika dijalankan dalam mode pertama,
program utama akan langsung menghentikan semua operasinya Ketika program Killer dijalankan.
Sedangkan untuk mengaktifkan mode kedua, program harus dijalankan dengan argumen -x, dan Ketika dijalankan dalam mode kedua, program utama akan berhenti namun membiarkan proses
di setiap direktori yang masih berjalan hingga selesai
(Direktori yang sudah dibuat akan mendownload gambar sampai selesai dan membuat file txt, lalu zip dan delete direktori).

Ranora meminta bantuanmu untuk membantunya dalam membuat program tersebut. Karena kamu anak baik dan rajin menabung,
bantulah Ranora dalam membuat program tersebut!
Note:
- Tidak boleh menggunakan system() dan mkdir()
- Program utama merupakan **SEBUAH PROGRAM C**
- Wajib memuat algoritma Caesar Cipher pada program utama yang dibuat

### a: Jawaban dan Penjelasan
Pada soal bagian a kita diminta untuk Membuat sebuah program C yang dimana setiap 40 detik membuat sebuah direktori dengan nama sesuai timestamp **[YYYY-mm-dd_HH:ii:ss]**.
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
