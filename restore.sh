#!/bin/bash
#-------------------------------------------------------------------------------
# Restore backups                                                              #
# (c) Akulov Evgeniy, Irkutsk, 2011                                                     #
#  ver. 2.0                                                                    #
#  date create  26 01 2011                                                     #
#  date last edit    10 10 2013                                                #
#-------------------------------------------------------------------------------


#------------------------------- settings --------------------------------------

IP_BIS_RES='10.194.40.6'
TAR=$(which tar)
R_START=""
BQ="/home2/bis/quit41d"
TERM=AT386; export TERM # для корректной работы при запуске из cron

#-------------------------------------------------------------------------------

if [ "$UID" -ne 0 ]
then
  echo "You not root, run only root"
  exit $E_NOTROOT
fi

if [ $(hostname -i) != $IP_BIS_RES ] 
then
    echo "Running only on reserv server !!!"
    exit 1
fi

#-------------------------------------------------------------------------------

restore_base()
{
#	echo 2|$BQ/bq41d_1 stop
#	echo 2|$BQ/bq41d_2 stop	
	$BQ/bq41d stop -by
clear
	cd /db/v10
	echo y|prodel bisquit
	sleep 10
	cd /bk/backup 
	bqrestore $(ls bq41d_1*.gz.000) /db/v10/bisquit
	
	cd /db/v10.2
	echo y | prodel dbrshb
	cd /bk/backup 
	bqrestore $(ls bq41d_2*.gz) /db/v10.2/dbrshb
	
	sleep 10
	$BQ/bq41d start
	if [ $R_START = "MENU" ];then menu;fi
}

restore_res_base()
{
	cd /db/res
	prodel bisquit
	cd /bk/backup 
	bqrestore $(ls bq41d_1*.gz.000) /db/res/bisquit

	cd /db/res.2
	prodel dbrshb
	cd /bk/backup 
	bqrestore $(ls bq41d_2*.gz) /db/res.2/dbrshb
	if [ $R_START = "MENU" ];then menu;fi
}

restore_home2()
{
	rm -r /home2
	$TAR -P -zxpf $(ls /bk/backup/bkup_s6600-bs03_home2.*.tgz)
	if [ $R_START = "MENU" ];then menu;fi
}

restore_sysconfig_all()
{
	$TAR -P -zxpf $(ls /bk/backup/bkup_s6600-bs03_sysconfig.*.tgz)
	newaliases
	#reboot
	if [ $R_START = "MENU" ];then menu;fi
}

restore_sysconfig_ps()
{
	$TAR -P -zxpf $(ls /bk/backup/bkup_s6600-bs03_sysconfig.*.tgz) /etc/passwd /etc/shadow /etc/group
	if [ $R_START = "MENU" ];then menu;fi
	# также эти файлы есть в архиве users
}
restore_sysconfig_smb()
{
	$TAR -P -zxpf $(ls /bk/backup/bkup_s6600-bs03_sysconfig.*.tgz) /etc/samba/users.map
	if [ $R_START = "MENU" ];then menu;fi
	# доделать
}
restore_sysconfig_pr()
{
	$TAR -P -zxpf $(ls /bk/backup/bkup_s6600-bs03_sysconfig.*.tgz) /etc/cups/ /etc/hosts
	/etc/init.d/cups restart
	if [ $R_START = "MENU" ];then menu;fi
}

restore_users()
{
	cd /home
	rm -r $(ls /home/ | grep -v dba| grep -v admin| grep -v bis| grep -v admin-go1| grep -v admin-go2)
	$TAR --exclude='admin/*' --exclude='dba/*' -P -zxpf $(ls /bk/backup/bkup_s6600-bs01_users.*.tgz)
	if [ $R_START = "MENU" ];then menu;fi
}
copy_base()
{
#        "Stop roll !!! "	
	echo 2|$BQ/bq41d_1 stop
	echo 2|$BQ/bq41d_2 stop	
clear
	echo y|/usr/dlc/bin/procopy /db/res/bisquit /db/v10/bisquit
	sleep 10
	echo y|/usr/dlc/bin/procopy /db/res.2/dbrshb /db/v10.2/dbrshb
	sleep 10
	$BQ/bq41d start
	if [ $R_START = "MENU" ];then menu;fi
}
menu()
{ 
clear
echo "============================================"
echo "	Restore backups on Server"
echo "============================================"
echo " 1. - Restore base from backup"
echo " 1a.- Restore reserve base from backup"
echo " 2. - Restore home2"
echo " 3. - Restore sysconfig linux all"
echo " 3a.- Restore sysconfig linux /etc/passwd /etc/shadow /etc/group"
echo " 3b.- Restore sysconfig linux samba"
echo " 3c.- Restore sysconfig linux printers"
echo " 4. - Restore users (dont dba admin bis admin-go[1,2])"
echo " 5. - Copy base from reserv"
echo " 6. - quit"
echo "============================================"

read sel

case "$sel" in
1)
	restore_base
	;;
1a)
	restore_res_base
	;;
2)
	restore_home2
	;;
3)
	restore_sysconfig_all
	;;
3a)
	restore_sysconfig_ps
	;;
3b)
	restore_sysconfig_smb
	;;
3c)
	restore_sysconfig_pr
	;;
4)
	restore_users
	;;
5)
	copy_base
	;;	
6)
	clear
	exit 0
;;
esac
}

#-------------------------------------------------------------------------------
# --------------------- start script and command parser ------------------------

if [ $# -ne 0 ]; then

    R_START="COMMAND"
    case $1 in
	cfg_users_ps)
		restore_sysconfig_ps
        	;;
	cfg_users_smb) 
		restore_sysconfig_smb
		;;
	cfg_prin)
		restore_sysconfig_pr 
		;;
	copy_base)
		copy_base
		;;	
    esac

else
    R_START="MENU"
    menu
fi

exit 0
