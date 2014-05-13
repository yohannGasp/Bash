#!/bin/sh
# прописан в crontab под root
# чистим home каталоги
ls /home/| while read line
do   
#    if [[ $line != 'maxpatbis' ]];then
	rm -rf /home/$line/work/*
	rm -rf /home/$line/work2/*  
done
# чистим каталоги бисмарка
rm -f /home2/bis/quit41d/imp-exp/fo/out/pfr/*
rm -f /home2/bis/quit41d/imp-exp/fo/out/soc/*
rm -f /home2/bis/quit41d/imp-exp/fo/out/subsid/* 
rm -f /home2/bis/quit41d/imp-exp/fo/out/zrp_org/* 
rm -f /home2/bis/quit41d/imp-exp/fo/out/bankomat/*

rm -f /home2/bis/tmp/*
rm -f /bk/tmp/*

cd /home2/bis/quit41d/imp-exp/mns/arch/ && tar -cPf archive-$(date +%d%m%Y).tar /home2/bis/quit41d/imp-exp/mns/out/ && gzip archive-$(date +%d%m%Y).tar
# кузьмина оставляет файлы
rm -f /home2/bis/quit41d/imp-exp/mns/out/*

exit 0




