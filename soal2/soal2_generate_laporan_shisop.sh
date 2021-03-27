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

#2b
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

#2c
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

#2d
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

