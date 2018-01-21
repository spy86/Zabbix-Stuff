#!/bin/sh

    # backup zabbix config only

    DBNAME=zabbix
    DBUSER=root
    DBPASS=password123

    BK_DEST=/opt/zabbix/

    count=0
    total=15
    pstr="[=======================================================================]"

    count1=0
    total1=15
    pstr1="[=======================================================================]"

    now=$(date +"%m_%d_%Y")

    # zabbix schema
    mysqldump -u$DBUSER  -p"$DBPASS" -B "$DBNAME" --no-data > "$BK_DEST/$DBNAME-0-schema.sql"

while [ $count -lt $total ]; do
  sleep 0.5 # this is work
  count=$(( $count + 1 ))
  pd=$(( $count * 73 / $total ))
  printf "\r%3d.%1d%% %.${pd}s" $(( $count * 100 / $total )) $(( ($count * 1000 / $total) % 10 )) $pstr
done
printf "\nDone DB_Schema has been saved in $BK_DEST$DBNAME-0-schema.sql\n"


    # zabbix config
    mysqldump -u"$DBUSER"  -p"$DBPASS" -B "$DBNAME" --single-transaction --no-create-info --no-create-db \
        --ignore-table="$DBNAME.acknowledges" \
        --ignore-table="$DBNAME.alerts" \
        --ignore-table="$DBNAME.auditlog" \
        --ignore-table="$DBNAME.auditlog_details" \
        --ignore-table="$DBNAME.escalations" \
        --ignore-table="$DBNAME.events" \
        --ignore-table="$DBNAME.history" \
        --ignore-table="$DBNAME.history_log" \
        --ignore-table="$DBNAME.history_str" \
        --ignore-table="$DBNAME.history_str_sync" \
        --ignore-table="$DBNAME.history_sync" \
        --ignore-table="$DBNAME.history_text" \
        --ignore-table="$DBNAME.history_uint" \
        --ignore-table="$DBNAME.history_uint_sync" \
        --ignore-table="$DBNAME.trends" \
        --ignore-table="$DBNAME.trends_uint" \
        > "$BK_DEST/$DBNAME-$(date +%y%m%d)-config.sql"

while [ $count1 -lt $total1 ]; do
  sleep 0.5 # this is work
  count1=$(( $count1 + 1 ))
  pd=$(( $count1 * 73 / $total1 ))
  printf "\r%3d.%1d%% %.${pd}s" $(( $count1 * 100 / $total1 )) $(( ($count1 * 1000 / $total1) % 10 )) $pstr
done
printf "\nDone DB_config has been saved in $BK_DEST$DBNAME-$(date +%y%m%d)-config.sql\n"
tar -zcvf zabbix_backup_database_$now.tar.gz $DBNAME-$(date +%y%m%d)-config.sql $DBNAME-0-schema.sql
mail -s "Zabbix database backup $date" -a zabbix_backup_database.tar.gz  zabbixmonitoring@gmail.com < message

cp zabbix_backup_database_$now.tar.gz /mnt/ZabbixDatabaseBackup

rm -rf $DBNAME-$(date +%y%m%d)-config.sql
rm -rf $DBNAME-0-schema.sql
rm -rf zabbix_backup_database_$now.tar.gz

