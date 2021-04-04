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
![Gambar output bagian a](https://github.com/sisopd11/soal-shift-sisop-modul-1-D11-2021/blob/main/soal1/Screenshot%20from%202021-04-01%2013-47-29.png)

### b: Jawaban dan Penjelasan
Pada soal bagian b kita diminta untuk menampilkan peson error beserta jumlah dari tiap pesan error:
```
#!/bin/bash

grep -o 'E.*' syslog.log | cut -d"(" -f1 | sort | uniq -c
```
berdasarkan syntax diatas `grep -o` berfungsi untuk mencari dan mencetak string yang cocok, `'E.*'` merupakan syarat dari data yang ingin ditampilkan yakni dimulai dengan huruf E dan diikuti oleh kata apapun sampai kata terakhir untuk tiap baris log, `cut -d"(" -f1` digunakan untuk memotong data dimulai dengan `(` hingga seterusnya (username), `sort` berfungsi untuk mengurutkan data secara ascending (default), terakhir `uniq -c` digunakan untuk menghitung jumlah error tiap error message dan di cetak sebagai prefix.

Output:
![Gambar output bagian b](https://github.com/sisopd11/soal-shift-sisop-modul-1-D11-2021/blob/main/soal1/Screenshot%20from%202021-04-01%2013-49-03.png)

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
![Gambar output bagian c](https://github.com/sisopd11/soal-shift-sisop-modul-1-D11-2021/blob/main/soal1/Screenshot%20from%202021-04-01%2013-49-33.png)

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
![Gambar output bagian d](https://github.com/sisopd11/soal-shift-sisop-modul-1-D11-2021/blob/main/soal1/Screenshot%20from%202021-04-01%2013-46-18.png)

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
![Gambar output bagian e](https://github.com/sisopd11/soal-shift-sisop-modul-1-D11-2021/blob/main/soal1/Screenshot%20from%202021-04-01%2013-45-46.png)

## Kendala yang dihadapi
1. Tidak bisa melakukan inisialisasi data dan penggunaan regex gagal sehingga menggunakan perintah grep
2. Pada soal bagian a, ketika menukar urutan syarat `'[E|I].*'` menjadi `'[I|E].*'` hanya dimunculkan huruf I dan E secara random.
3. Saat menghitung jumlah error tanpa `sort` yang dimunculkan adalah total error
4. Pada bagian d dan e, saat ingin menyimpan jawaban bagian b dan c dengan variabel tidak ada data yang muncul pada file csv.

# SOAL No.2
Steven dan Manis mendirikan sebuah startup bernama “TokoShiSop”. Sedangkan kamu dan Clemong adalah karyawan pertama dari TokoShiSop. Setelah tiga tahun bekerja, Clemong diangkat menjadi manajer penjualan TokoShiSop, sedangkan kamu menjadi kepala gudang yang mengatur keluar masuknya barang.

Tiap tahunnya, TokoShiSop mengadakan Rapat Kerja yang membahas bagaimana hasil penjualan dan strategi kedepannya yang akan diterapkan. Kamu sudah sangat menyiapkan sangat matang untuk raker tahun ini. Tetapi tiba-tiba, Steven, Manis, dan Clemong meminta kamu untuk mencari beberapa kesimpulan dari data penjualan “Laporan-TokoShiSop.tsv”.

a. Steven ingin mengapresiasi kinerja karyawannya selama ini dengan mengetahui Row ID dan profit percentage terbesar (jika hasil profit percentage terbesar lebih dari 1, maka ambil Row ID yang paling besar). Karena kamu bingung, Clemong memberikan definisi dari profit percentage, yaitu:
	Profit Percentage = (Profit Cost Price) 100
Cost Price didapatkan dari pengurangan Sales dengan Profit. (Quantity diabaikan).

b. Clemong memiliki rencana promosi di Albuquerque menggunakan metode MLM. Oleh karena itu, Clemong membutuhkan daftar nama customer pada transaksi tahun 2017 di Albuquerque.

c. TokoShiSop berfokus tiga segment customer, antara lain: Home Office, Customer, dan Corporate. Clemong ingin meningkatkan penjualan pada segmen customer yang paling sedikit. Oleh karena itu, Clemong membutuhkan segment customer dan jumlah transaksinya yang paling sedikit.

d. TokoShiSop membagi wilayah bagian (region) penjualan menjadi empat bagian, antara lain: Central, East, South, dan West. Manis ingin mencari wilayah bagian (region) yang memiliki total keuntungan (profit) paling sedikit dan total keuntungan wilayah tersebut.

# Jawaban
## No.2A

Pada soal ini, kita akan menghitung perentase keuntungan dimana, dalam penghitungannya kita dapat menggunakan rumus yang telah tersedia, pada soal yakni profit/(sales-profit)x100. Kemudian kita akan menampilkan RowID dari profit terbesar yang telah dihitung.
```
export LC_ALL=C
awk '
BEGIN{FS="\t"}
{
  profit=$21;
  costPrice=$18-$21;
 profitpersentase=profit/costPrice*100
   if(maks<=profitpersentase){
     maks=profitpersentase
     RowID=$1}
}
END {
 printf("Transaksi terkahir dengan profit persentase terbesar yaitu %d dengan persentase %d%%\n", RowID, maks)
} ' /home/dewi/SISOP/praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt
```
- FS="\t" = Untuk memberitahu field bahwa separator yang digunakan adalah Tab.
- Variabel profit = untuk menampung data yang ada pada kolom ke 21 yaitu data profit.
- Variabel costPrice = untuk menampung hasil pengurangan dari $18 dengan $21 dimana $18 merupakan kolom sales sedangkan $21 merupakan profit.
- profitpersentase = (profit/costPrice.100) : Untuk mencari persentase profit terbesar maka kita dapat membagi profit dengan costPrice lalu dikali dengan 100.
- if(maks<=profitpersentase) = Untuk mencari persentase profit terbesar
- profit persentase terbesar akan disimpan di variabel maks dan IDnya akan disimpan kedalam variabel RowID.
- END = Setelah selesai pengecekan maka kita akan mencetak RowID dan persentase profit terbesarnya.
- /home/dewi/SISOP/praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt = hasil output dari directori /home/dewi/SISOP/praktikum1/Laporan-TokoShiSop.tsv dikirim ke file hasil.txt, jika file sudah ada maka isinya akan ditambah di akhir file.

## No.2B
Pada soal ini kita akan menampilkan nama seluruh customer yang melakukan transaksi pada tahun 2017 di Albuquerque
```
export LC_ALL=
awk '
BEGIN{FS="\t"}
{
  tahun=$2;
  city=$10;
  if(tahun~"2017" && city=="Albuquerque"){
    arrlist[$7]++
  }
}
END{
  print "\nDaftar nama customer di Alburquerque pada tahun 2017 antara lain :"
  for(customerName in arrlist)
  {print customerName}
}' /home/dewi/SISOP/praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt
```
##Penjelasan :
- FS="\t" = Untuk memberi tahu field bahwa separator yang akan digunakan adalah Tab.
- Variabel tahun = Untuk menyimpan data dari kolom kedua yakni Order ID.
- if(tahun~"2017" && city=="Albuquerque") = Untuk mengecek data yg OrderIDnya 2017 dan Citynya adalah Albuquerque.
- arrlist[$7]++ = Menyimpan nama customer yang memenuhi kodisi if diatas kedalam arrlist.
- End = Setelah selesai pengecekan kita akan mencetak nama-nama customer yang ada pada arrlist.
- /home/dewi/SISOP/praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt = hasil output dari directori /home/dewi/SISOP/praktikum1/Laporan-TokoShiSop.tsv dikirim ke file hasil.txt, jika file sudah ada maka isinya akan ditambah di akhir file.

## No.2C
Pada soal ini kita akan menampilkan jumlah transaksi yang paling sedikit dari tiga segment customer
```
export LC_ALL=C
awk '
BEGIN{FS="\t"}
{
   if(NR!=1){
    segment[$8]++
  }
}
END {
  minSales=10000
  for(temp in segment){
    if(minSales > segment[temp]){
      minSales = segment[temp]
      sum = temp;
    }
  }
  printf("\nTipe segment customer yang penjualannya paling sedikit adalah %s dengan segment %.1f\n", sum, minSales)
}' /home/dewi/SISOP/praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt
```
##Penjelasan
- FS="\t" = Untuk memberitahukan kepada field bahwa separator yang digunakan adalah Tab.
- if(NR!=1) = Untuk kondisi dimana number of Record yang akan digunakan tidak sama dengan 1 karena NR=1 adalah keterangan penamaan tabel.
- segment[$8]++ = Untuk menyimpan segment customer beserta jumlah transaksinya yang ada pada kolom kedelapan ke dalam suatu array bernama segment.
- END = kita akan mencari segment customer yang melakkukan transaksi paling sedikit.Oleh karena itu, pertama kita akan melakukan loop kemudian kita bandingkan dengan nilai minimum, jumlah transaksi yang paling kecil akan disimpan kedalam minSales dimana variabel ini berisi nama Segment dengan indek transaksi terkecil sementara itu, variabel sum akan menyimpan temp yang merupakan jumlah penjualan paling sedikit, kemudian nama segment dengan penjualan paling sedikit dan jumlah penjualannya akan dicetak.
- /home/dewi/SISOP/praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt = hasil output dari directori /home/dewi/SISOP/praktikum1/Laporan-TokoShiSop.tsv dikirim ke file hasil.txt, jika file sudah ada maka isinya akan ditambah di akhir file.

## 2d
Pada soal ini kita akan mencari wilayah bagian atau region yang memiliki profit paling sedikit dan kita akan menampilkan total keuntungan dari region yang telah kita cari sebelumnya.
```
export LC_ALL=C
awk '
BEGIN{FS="\t"}
{
   if(NR!=1){
    listRegion[$13]+=$21
  }
}
END {
  regmin=99999
  for(k in listRegion){
    if (listRegion[k] < regmin){
      regmin = listRegion[k]
      minwil = k
    }
  }
  printf("\nWilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %.1f\n", minwil, regmin);
}' /home/dewi/SISOP/praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt
```
## Penjelasan
- FS="\t" = Untuk memberi tahu field bahwa separator yang digunakan adalah Tab.
- if(NR!=1) = Untuk kondisi dimana number of Record yang akan digunakan tidak sama dengan 1 karena NR=1 adalah keterangan penamaan tabel.
- listRegion[$13]+=$21 = Untuk menghitung profit(tabel ke-21) berdasarkan wilayahnya, wilayah(tabel ke-13). Sehingga total profit setiap wilayah akan tersimpan ke dalam array listRegion.
- END = Sama halnya dengan No.2C, kita akan mengecek nilai-nilai dalam array listRegion dan akan kita bandingkan terus dengan regmin untuk mendapatkan region dengan profit paling sedikit.Kemudian, region dengan profit paling sedikit akan disimpan kedalam variabel minwil dan total keuntungannya akan disimpan ke dalam variabel regmin. Setelah itu, kita bisa mencetak minwil dan regminnya.
- /home/dewi/SISOP/praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt = hasil output dari directori /home/dewi/SISOP/praktikum1/Laporan-TokoShiSop.tsv dikirim ke file hasil.txt, jika file sudah ada maka isinya akan ditambah di akhir file.

## 2E
Output :
untuk melihat hasil dari penngerjaan nomor 2A - 2D kita dapat menjalankan nano hasil.txt, dan berikut ini merupakan outputnya
![output 1](https://user-images.githubusercontent.com/80894892/113500144-486ca700-954e-11eb-9859-ce7961906e28.png)

## Kesulitan :
Kesulitan yang saya alami saat mengerjakan soal ini adalah kurang hapal terhadap syntax command dan spasi pada shell lumayan cukup membuat rumit.

## Soal No 3
a. Pada soal ini, kita diminta untuk mendownload gambar dari https://loremflickr.com/320/240/kitten sebanyak 23 buah tanpa ada gambar yang sama. Kemudian memasukkan log dari download tersebut kedalam file Foto.log. Kode yang saya gunakan yaitu:

```shell
#!/bin/bash

CAT_LINK="https://loremflickr.com/320/240/kitten"
i=1

while [ $i -le 23 ]
do	
	wget -N --content-disposition $CAT_LINK -a Foto.txt
	i=$((i+1))
done


i=1
for name in `ls | grep jpg$`
do
	mv "$name" "Koleksi_$i.jpg"
	i=$((i+1))
done
```
Disini, loop while akan melakukan `wget` untuk mendownload file dari link sebanyak 23 kali. Pada line `wget`, saya menggunakan option:
- `-N` (--timestamping) : berfungsi agar `wget` tidak mendownload file yang bernama sama, kecuali file tersebut yang ada pada server dilakukan modifikasi.
- `--content-disposition` : berfungsi agar nama file yang didownload disamakan dengan nama file yang berada di server.
- `-a [FILE]` (append) : berfungsi agar log dari wget ditambahkan kedalam `[FILE]`

Kemudian, digunakan for loop dengan daftar itemnya berupa file yang mempunyai format jpg dapat dipilih dengan menggunakan ``
`ls | grep jpg$`
``. Isi dari loop yaitu merubah nama nama file tersebut yang awalnya mengambil nama server, menjadi bentuk Koleksi_N (Koleksi_1, Koleksi_2, dst) menggunakan `mv`.

b. Agar foto-foto dan file log dimasukkan ke dalam suatu folder, digunakan :

```shell
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
```

Agar nama dari file menjadi berupa tanggal dengan format dd-mm-yyyy, digunakan `date +%d-%m-%Y`. Selanjutanya dengan loop for yang sama dengan sebelumnya, foto dan lognya dimasukkan kedalam file  Kucing_[tanggal].
Crontab agar scriptnya berjalan hanya pada jam 8 malam setiap tanggal 1 dengan increment 7 dan tanggal 2 dengan increment 4, maka digunakan :
```shell
0 20 1/7 * * bash soal3a.sh && soal3b.sh
0 20 2/4 * * bash soal3a.sh && soal3b.sh
```

c. Untuk mendownload foto kelinci kodenya sama dengan soal 3a, tetapi linknya diganti. kemudian digabungkan  kedalam satu file Kelinci_[Tanggal] seperti soal 3b. Agar file jenis gambar yang didownload alternate, maka digunakan cariable yang memanggil tanggal dengna `date`. Kemudian dicek apabile tanggal tersebut berupa genap atau ganjil dengan menggunakan mod.Code terakhir menjadi:
```shell
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
```


d. Untuk menjadikan semua folder Kucing_ dan Kelinci_ menjadi 1 file zip dengan password sesuai dengan tanggal, maka digunakan :
```shell
  
#!/bin/bash

tanggal=`date +%m%d%Y`

for FILE in `ls | grep 'Kelinci_\|Kucing_'`
do
	zip -rm -P $tanggal "Koleksi.zip" $FILE
done
```
Karena passwordnya merupakan tanggal dengan format mmddyyy, maka digunakan `date +%m%d%Y`. Selanjutan, agar semua file berawalan Kelinci_ dan Kucing_ menjadi list dalam loop for, digunakan ``
`ls | grep 'Kelinci_\|Kucing_'`
``
. File-file tersebut kemudian dimasukkan kedalam zip dengan menggunakan opstion :
- `-rm` : agar file yang sudah dimasukkan ke dalam zip dihapus
- `-P [Password]` : agar file zip terlindungi password [Password]

e. Agar semua file koleksi tersebut hanya dizip setiap jam 7 pagi dan diunzip pada jam 6 malam setiap harinya kecuali hari sabtu dan minggu, digunakan crontab berikut :
```shell
0 7 * * mon-fri /bin/bash /home/avind/Desktop/Soal3_shift1_sisopD/soal3d.sh
0 18 * * mon-fri /bin/bash /home/avind/Desktop/Soal3_shift1_sisopD/soal3e.sh
```
untuk men-unzip file, crontab akan menjalankan soal3e.sh yang berisikan :
```shell
#!/bin/bash

unzip -P `date +%m%d%Y` -o /home/avind/Desktop/Soal3_shift1_sisopD/Koleksi.zip -d /home/avind/Desktop/Soal3_shift1_sisopD
rm /home/avind/Desktop/Soal3_shift1_sisopD/Koleksi.zip
```
