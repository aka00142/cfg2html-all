#!/bin/sh

CRON_PATH=/var/spool/cron/crontabs

for i in `ls $CRON_PATH`; do

     echo "\n-=[ Crontab entry for user $i ]=-\n"
     crontab -l $i  # does not work with HPUX 10.xx

done

#
