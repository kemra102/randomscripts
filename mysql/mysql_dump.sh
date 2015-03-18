#!/usr/bin/env bash

DBHOST='localhost'
DBUSER='root'
DBPASS=''
BACKUPDIR='/backups/mysql'
COMPRESS=true
RETENTION=3

databases=($(mysql -BN -e "show databases"))

checkexistingbackups () {
  if $COMPRESS; then
    oldbackup="$BACKUPDIR/$db-$(date --date="$RETENTION days ago" +"%Y%m%d").sql.gz"
  else
    oldbackup="$BACKUPDIR/$db-$(date --date="3 days ago" +"%Y%m%d").sql"
  fi
  if [ -e "$oldbackup" ]; then
    rm -f "$oldbackup"
  fi
}

createdbbackup () {
  if $COMPRESS; then
    mysqldump -h$DBHOST -u$DBUSER -p$DBPASS "$db" | gzip > "$BACKUPDIR/$db-$(date +%Y+%m+%d).sql.gz"
    mysql -BN -h"$1" -u"$2" -p"$3" -e "SELECT DISTINCT CONCAT('SHOW GRANTS FOR \'', user, '\'@\'', host, '\';') AS query FROM mysql.user" | mysql -h"$1" -u"$2" -p"$3" | sed 's/\(GRANT .*\)/\1;/;s/^\(Grants for .*\)/## \1 ##/;/##/{x;p;x;}' | gzip > "$BACKUPDIR/usergrants-$(date +%Y+%m+%d).sql.gz"
  else
    mysqldump -h$DBHOST -u$DBUSER -p$DBPASS "$db" > "$BACKUPDIR/$db-$(date +%Y+%m+%d).sql"
    mysql -BN -h"$1" -u"$2" -p"$3" -e "SELECT DISTINCT CONCAT('SHOW GRANTS FOR \'', user, '\'@\'', host, '\';') AS query FROM mysql.user" | mysql -h"$1" -u"$2" -p"$3" | sed 's/\(GRANT .*\)/\1;/;s/^\(Grants for .*\)/## \1 ##/;/##/{x;p;x;}' > "$BACKUPDIR/usergrants-$(date +%Y+%m+%d).sql"
  fi
}

for db in "${databases[@]}"; do
  if [ "$db" == 'mysql' ]; then
    continue
  fi
  checkexistingbackups "$db"
  createdbbackup "$db"
done
