# soal-shift-sisop-modul-1-D11-2021








# 3.
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
- `__-N__ `(--timestamping) : berfungsi agar `wget` tidak mendownload file yang bernama sama, kecuali file tersebut yang ada pada server dilakukan modifikasi.
- `__--content-disposition__` : berfungsi agar nama file yang didownload disamakan dengan nama file yang berada di server.
- `__-a [FILE]__` (append) : berfungsi agar log dari wget ditambahkan kedalam `[FILE]`
