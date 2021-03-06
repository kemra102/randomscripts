#!/usr/bin/env bash

DBHOST='localhost'
DBUSER='root'
DBPASS=''
DUMPLOC='/backups/mysql'
GZIPPED=true
MYISAM2INNODB=true

cd $DUMPLOC
databases=($(ls))

createmydb () {
  mysql -h$DBHOST -u$DBUSER -p$DBPASS -e "CREATE DATABASE IF NOT EXISTS $1"
}

2innodb () {
  if $MYISAM2INNODB; then
    sed -i -r 's/MyISAM/InnoDB/g' "$1"
  fi
}

importdb () {
  if $GZIPPED; then
    gunzip < "$2" | mysql -h$DBHOST -u$DBUSER -p$DBPASS "$1" < "$2"
  else
    mysql -h$DBHOST -u$DBUSER -p$DBPASS "$1" < "$2"
  fi
}

for db in "${databases[@]}"; do
  filename="${db/.gz/}"
  dbname="${db/.sql/}"
  if [ "$dbname" == 'mysql' ]; then
    continue
  fi
  createmydb "$dbname"
  2innodb "$filename"
  importdb "$dbname" "$filename"
done
