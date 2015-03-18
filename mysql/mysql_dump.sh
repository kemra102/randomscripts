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
    oldbackup="$BACKUPDIR/$1-$(date --date="$RETENTION days ago" +"%Y%m%d").sql.gz"
  else
    oldbackup="$BACKUPDIR/$1-$(date --date="3 days ago" +"%Y%m%d").sql"
  fi
  if [ -e "$oldbackup" ]; then
    rm -f "$oldbackup"
  fi
}

createdbbackup () {
  if $COMPRESS; then
    mysqldump -h$DBHOST -u$DBUSER -p$DBPASS -cC --add-drop-table --add-locks --quick "$1" | gzip > "$BACKUPDIR/$1-$(date +%Y%m%d).sql.gz"
    mysql -BN -h$DBHOST -u$DBUSER -p$DBPASS -e "SELECT DISTINCT CONCAT('SHOW GRANTS FOR \'', user, '\'@\'', host, '\';') AS query FROM mysql.user" | mysql -h$DBHOST -u$DBUSER -p$DBPASS | sed 's/\(GRANT .*\)/\1;/;s/^\(Grants for .*\)/## \1 ##/;/##/{x;p;x;}' | gzip > "$BACKUPDIR/usergrants-$(date +%Y%m%d).sql.gz"
  else
    mysqldump -h$DBHOST -u$DBUSER -p$DBPASS -cC --add-drop-table --add-locks --quick "$1" > "$BACKUPDIR/$1-$(date +%Y%m%d).sql"
    mysql -BN -h$DBHOST -u$DBUSER -p$DBPASS -e "SELECT DISTINCT CONCAT('SHOW GRANTS FOR \'', user, '\'@\'', host, '\';') AS query FROM mysql.user" | -h$DBHOST -u$DBUSER -p$DBPASS | sed 's/\(GRANT .*\)/\1;/;s/^\(Grants for .*\)/## \1 ##/;/##/{x;p;x;}' > "$BACKUPDIR/usergrants-$(date +%Y%m%d).sql"
  fi
}

for db in "${databases[@]}"; do
  if [ "$db" == 'mysql' ]; then
    continue
  elif [ "$db" == 'information_schema' ]; then
    continue
  fi
  checkexistingbackups "$db"
  createdbbackup "$db"
done
