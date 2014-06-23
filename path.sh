#!/bin/bash
#-------------------------------------------------------------------------------
# path                                                                         #
# (c) Akulov Evgeniy, Irkutsk, 2014                                            #
#  ver. 1.0                                                                    #
#  date create       22 06 2014                                                #
#  date last edit                                                              #
#-------------------------------------------------------------------------------


#------------------------------- settings --------------------------------------

TAR=$(which tar)
R_START=""
BQ="/home2/bis/quit41d"
TERM=AT386; export TERM 

#-------------------------------------------------------------------------------

if [ "$UID" -ne 0 ]
then
  echo "You not root, run only root"
  exit $E_NOTROOT
fi

#-------------------------------------------------------------------------------

before_path()
{
	$BQ/bq41d stop -by
	sleep 10
	clear
	rfutil /db/v10/bisquit  -C aimage end
	rfutil /db/v10.2/dbrshb -C aimage end
	sleep 10
	$BQ/bq41d truncate
	bqbackup bq41d_2 /bk/backup/ -fast
        bqbackup bq41d_1 /bk/backup/ -fast            #     time: 17 minut
#        bqrestore bq41d_1.121028.1305.f.bk.000 -verify     time: 10 minut
	if [ $R_START = "MENU" ];then menu;fi
}

pl_create()
{
	sh $BQ/bq-lib
}

after_path()
{
	bqbackup bq41d_2 /bk/backup -ai -fast
	bqbackup bq41d_1 /bk/backup -ai -fast
        sleep 10
	$BQ/bq41d_1 cmd kredfo_propath_update
	sleep 5
	$BQ/bq41d start
	sleep 10
	su bank
	sh $BQ/bismark2/mailserv
	sleep 5
	sh $BQ/bismarkb/mailservb	
	sleep 5
	exit
	if [ $R_START = "MENU" ];then menu;fi
}

restore_res_base()
{
	cd /db/res.2
	echo y | prodel dbrshb
	cd /bk/backup 
	bqrestore $(ls bq41d_2*.bk) /db/res.2/dbrshb

	cd /db/res
	echo y | prodel bisquit
	cd /bk/backup 
	bqrestore $(ls bq41d_1*.bk.000) /db/res/bisquit

	if [ $R_START = "MENU" ];then menu;fi
}

menu()
{ 
clear
echo "=========================================================================="
echo "	Path on Server"
echo "=========================================================================="
echo " 1. - Before path (stop base, aimage disable, backup base)"
echo " 1a. - Compilation"
echo " 1b. - PL Create"
echo " 2. - After path (backup base, aimage enable, start base, start bismark)"
echo " 3. - Restore reserv base"
echo " 4. - quit"
echo "=========================================================================="

read sel

case "$sel" in
1)
	before_path
	;;
1b)
	pl_create
	;;
2)
	after_path	
	;;
3)
	restore_res_base
	;;
4)
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
        	;;
	cfg_users_smb) 
		;;
	cfg_prin)
		;;
	copy_base)
		;;	
    esac

else
    R_START="MENU"
    menu
fi

exit 0
