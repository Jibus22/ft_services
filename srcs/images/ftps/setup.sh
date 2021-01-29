#!/bin/sh

telegraf --config etc/telegraf.conf &

#vsftpd server must be ran with config file as parameter to use it. 
#conf uses passive port 21000 for data (& the usual 21 command port)
vsftpd /etc/vsftpd/vsftpd.conf
