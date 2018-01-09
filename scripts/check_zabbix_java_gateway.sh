
#!/bin/bash

echo $(date +%d/%m/%Y-%H:%M)

service zabbix-java-gateway status > status__zabbix_java_gateway

if grep  "is running..." status
then
    echo "zabbix-java-gateway is runnign on $HOSTNAME"
    echo " "
else

echo "zabbix-java-gateway is stopped on $HOSTNAME"
echo " "
output=`ps aux|grep zabbix_java`
set -- $output
pid=$2
kill $pid
sleep 2
kill -9 $pid >/dev/null 2>&1

echo "zabbix-java-gateway is stopped on $HOSTNAME!!!" > /tmp/mail_zabbix_java_gateway
mail -s "Zabbix Java Gateway is down on !!!" root@localhost < /tmp/mail_zabbix_java_gateway
/etc/init.d/zabbix-java-gateway restart
rm -rf /tmp/mail_zabbix_java_gateway
rm -rf /tmp/status__zabbix_java_gateway

fi

