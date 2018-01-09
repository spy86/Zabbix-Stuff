#!/bin/bash
echo $(date +%d/%m/%Y-%H:%M)

service=zabbix_server

if (( $(ps -ef | grep -v grep | grep $service | wc -l) > 0 ))
then
echo "$service is running!!!"
echo " "
else
echo "Zabbix Server is not running on $HOSTNAME!!!" > /tmp/mail_zabbix_server
mail -s "Zabbix server is down on !!!" root@localhost < /tmp/mail_zabbix_server
/etc/init.d/zabbix-server start
rm -rf /tmp/mail_zabbix_server
fi
