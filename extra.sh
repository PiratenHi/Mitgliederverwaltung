#!/bin/sh

./filterkreis.sh test_NDS_20120203.csv Stade > u_kvstd_20120203.csv
./filterkreis.sh test_NDS_20120203.csv Wilhelmshaven > u_kvwhv_20120203.csv
./filterkreis.sh test_NDS_20120203.csv Osnabr.ck > u_kvos_20120203.csv
./filterkreis.sh test_NDS_20120203.csv G.ttingen > u_kvgoe_20120203.csv
./filterkreis.sh test_NDS_20120203.csv Hannover > u_hannover_20120203.csv
./filterkreis.sh test_NDS_20120203.csv Hildesheim > u_kvhi_20120203.csv
./filterkreis.sh test_NDS_20120203.csv Peine > u_kvpe_20120203.csv
./filterkreis.sh test_NDS_20120203.csv Hameln-Pyrmont > u_kvhm_20120203.csv
./filterkreis.sh test_NDS_20120203.csv Goslar > u_kvgs_20120203.csv
./filterkreis.sh test_NDS_20120203.csv Delmenhorst > u_kvdel_20120203.csv
./filterkreis.sh test_NDS_20120203.csv Braunschweig > u_kvbs_20120203.csv
./filterkreis.sh test_NDS_20120203.csv Wolfsburg > u_kvwob_20120203.csv

./filterkreis.sh test_NDS_20120203.csv Harburg > u_kvno1_20120203.csv
./filterkreis.sh test_NDS_20120203.csv L.neburg > u_kvno2_20120203.csv
./filterkreis.sh test_NDS_20120203.csv Uelzen > u_kvno3_20120203.csv

cat u_kvno1_20120203.csv u_kvno2_20120203.csv u_kvno3_20120203.csv > u_kvno_20120203.csv

./filterkreis.sh test_NDS_20120203.csv Wolfenb.ttel > u_kvwf1_20120203.csv
./filterkreis.sh test_NDS_20120203.csv Salzgitter > u_kvwf2_20120203.csv

cat u_kvwf1_20120203.csv u_kvwf2_20120203.csv > u_kvwf_20120203.csv




# read xxx

for ii in hannover kvbs kvdel kvgoe kvgs kvhi kvhm kvos kvpe kvstd kvwf kvwhv kvwob kvno ; do
       
csv2ods --encoding=iso8859-1 -i u_${ii}_20120203.csv -o u_${ii}_20120203.ods

echo "$ii done"

done
