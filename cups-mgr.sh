#!/bin/bash
# в crontab под lp

case $1 in
pr) 
    echo "Cancel all jobs printer "+$2
    lpstat $2 | while read line
    do
        cancel $2
    done
;;
all) 
    lpstat -o | awk '{print $1}'| while read line
    do
        cancel $line
#        echo "Cancel job "+$line >> /var/log/bank/rf/cups.log 2>&1
    done
        
;;
printers_on)
   lpstat -p | grep disabled | awk '{print $2}' |  while read line
   do
    /usr/bin/enable $line
   done
;;
*) 
    echo "Script managment jobs CUPS "
    echo " "
    echo "cups-mgr.sh <parametr> [<nameprinter>]"
    echo " "
    echo "parametr:"
    echo "pr - Cancel all jobs printer <nameprinter>"
    echo "all - Cancel all jobs all printers"
    echo "printers_off - "
    echo " "
;;
esac

#  lpstat -p | grep disabled | awk '{print $2}' | grep -v 10LJ2016 | while read line      для исключения 

exit 0



