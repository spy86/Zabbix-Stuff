## Configuration
1. Install and configure Zabbix agent (https://www.zabbix.com/download)

2. Copy user parameters file
```
> /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf
```

3. Provide MySQL credentials and set correct permissions (example for Ubuntu)
```
cat /etc/zabbix/.my.cnf
[client]
user     = readonlyuser
password = P@ssw0rd_123

chmod 640 /etc/zabbix/.my.cnf
chown root:zabbix /etc/zabbix/.my.cnf
```
4. Restart Zabbix agent and test commands
```
systemctl restart zabbix-agent

zabbix_agentd -t "mysql.slave_status[Slave_SQL_Running]"
zabbix_agentd -t "mysql.extended_status[Com_delete]"
```

5. Import template, review and link it to a MySQL server