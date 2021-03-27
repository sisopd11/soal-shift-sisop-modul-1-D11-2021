# soal-shift-sisop-modul-1-D11-2021

## Soal No 1
Ryujin baru saja diterima sebagai IT support di perusahaan Bukapedia. Dia diberikan tugas untuk membuat laporan harian untuk aplikasi internal perusahaan, ticky. Terdapat 2 laporan yang harus dia buat, yaitu laporan daftar peringkat pesan error terbanyak yang dibuat oleh ticky dan laporan penggunaan user pada aplikasi ticky. Untuk membuat laporan tersebut, Ryujin harus melakukan beberapa hal berikut:
(a) Mengumpulkan informasi dari log aplikasi yang terdapat pada file syslog.log. Informasi yang diperlukan antara lain: jenis log (ERROR/INFO), pesan log, dan username pada setiap baris lognya. Karena Ryujin merasa kesulitan jika harus memeriksa satu per satu baris secara manual, dia menggunakan regex untuk mempermudah pekerjaannya. Bantulah Ryujin membuat regex tersebut.

(b) Kemudian, Ryujin harus menampilkan semua pesan error yang muncul beserta jumlah kemunculannya.

(c) Ryujin juga harus dapat menampilkan jumlah kemunculan log ERROR dan INFO untuk setiap user-nya.

Setelah semua informasi yang diperlukan telah disiapkan, kini saatnya Ryujin menuliskan semua informasi tersebut ke dalam laporan dengan format file csv.

(d) Semua informasi yang didapatkan pada poin b dituliskan ke dalam file error_message.csv dengan header Error,Count yang kemudian diikuti oleh daftar pesan error dan jumlah kemunculannya diurutkan berdasarkan jumlah kemunculan pesan error dari yang terbanyak.
Contoh:
``Error,Count
Permission denied,5
File not found,3
Failed to connect to DB,2
``

(e) Semua informasi yang didapatkan pada poin c dituliskan ke dalam file user_statistic.csv dengan header Username,INFO,ERROR diurutkan berdasarkan username secara ascending.
Contoh:
``Username,INFO,ERROR
kaori02,6,0
kousei01,2,2
ryujin.1203,1,3
**Catatan :**

- Setiap baris pada file syslog.log mengikuti pola berikut:

 ```<time> <hostname> <app_name>: <log_type> <log_message> (<username>)```

- Tidak boleh menggunakan AWK

### Jawaban 1a
```
#!/bin/bash
#No1_a
#Ambil data kata depan Error or Info sampe username dari file syslog.log
grep -o '[E|I].*' syslog.log
```

### Jawaban 1b
```
#!/bin/bash
#No1_b
#Ambil data log Error tapi bagian username di cut, urut abc, sama hitung banyak errornya
grep -o 'E.*' syslog.log | cut -d"(" -f 1| sort | uniq -c
```

### Jawaban 1c
```
#!/bin/bash
#No1_c
#Ambil data log error cuma jumlah error for each username
echo Error:
grep -o 'E.*' syslog.log | cut --complement -d"(" -f 1 | cut -d")" -f 1 | sort | uniq -c
#Ambil data log info cuma jumlah info for each username
echo Info:
grep -o 'I.*' syslog.log | cut --complement -d"(" -f 1 | cut -d")" -f 1 | sort | uniq -c
```

### Jawaban 1d
```
#No1_d
#File error_message #OK
echo 'Error,Count' > 'error_message.csv'

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
```


#SOAL NO.2
a. Pada soal ini, kita akan menghitung perentase keuntungan dimana, dalam penghitungannya kita dapat menggunakan rumus yang telah tersedia, pada soal yakni profit/(sales-profit)x100. Kemudian kita akan menampilkan RowID dari profit terbesar yang telah dihitung.
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
     RowID=$1s}
}
END {
 printf("Transaksi terkahir dengan profit persentase terbesar yaitu %d dengan persentase %d%%\n", RowID, maks)
} ' /home/dewi/SISOP/praktikum1/Laporan-TokoShiSop.tsv >> hasil.txt
```
#No.2B
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
#No.2C
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
#2d
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

### Soal No 3
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

c. Untuk mendownload foto kelinci kodenya sama dengan soal 3a, tetapi linknya diganti. kemudian digabungkan  kedalam satu file Kelinci_[Tanggal] seperti soal 3b, sehingga menjadi:
```shell
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
```
Agar file yang didownload alternate setiap harinya antara kucing dan kelinci, maka crontabnya berupa :
```
0 20 1/2 * * bash soal3a.sh && soal3b.sh
0 20 2/2 * * bash soal3c.sh
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
0 7 * * mon-fri bash soal3d.sh
0 18 * * mon-fri unzip -P `date +%m%d%Y` Koleksi.zip && rm Koleksi.zip
```
