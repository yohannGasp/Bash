#!/bin/bash

# Numer patch
ver='87' 


cd /home2/bis/quit41d/


#------------ owners -----------------------------------

chown -R bis:dba rshb_d
chown -R bis:dba devel
chown -R bis:dba rf
chown -R bis:dba $(echo "src_d"$ver"f")
chown -R bis:dba $(echo "src_d"$ver"rf")
chown -R bis:dba $(echo "src_d"$ver"r") 
chown -R bis:dba $(echo "src_d"$ver)
chown -R bis:dba $(echo "r_d"$ver"f")


#------------------ chmod ------------------------------
chmod 755 rshb_d;chmod -R 664 rshb_d/*
chmod 755 devel;chmod -R 664 devel/*
chmod 755 rf;chmod -R 664 rf/*
chmod 755 $(echo "src_d"$ver"f");chmod -R 664 $(echo "src_d"$ver"f")/*
chmod 755 $(echo "src_d"$ver"rf");chmod -R 664 $(echo "src_d"$ver"rf")/*
chmod 755 $(echo "r_d"$ver"f");chmod -R 664 $(echo "r_d"$ver"f")/*
#------------------ 444 -------------------------------
chmod 755 $(echo "src_d"$ver"r");chmod -R 444 $(echo "src_d"$ver"r")/*
chmod 755 $(echo "src_d"$ver);#chmod -R 444 $(echo "src_d"$ver)/*



cd /home2/bis/quit41d/bq_pl/D79/
chown bis:dba bqbis.pl;
chmod 444 bqbis.pl;
cd ../..
chown bis:dba bq41d_1.pl;chown bis:dba bq41d_2.pl
chmod 444 bq41d_1.pl;chmod 444 bq41d_2.pl



echo "Succesfull"
