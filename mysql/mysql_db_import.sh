#!/usr/bin/env bash

DBHOST='localhost'
DBUSER='root'
DBPASS=''
DUMPLOC='/backups/mysql/'
GZIPPED=true
MYISAM2INNODB=true

cd $DUMPLOC
databases=(`ls`)

uncompress () {
  if $GZIPPED; then
    gunzip $1
  fi
}

createdb () {
  mysql -h$DBHOST -u$DBUSER -p$DBPASS -e "CREATE DATABASE IF NOT EXISTS $1"
}

2innodb () {
  if $MYISAM2INNODB; then
    sed -ir 's/MyISAM/InnoDB/g' $1
  fi
}

importdb () {
  mysql -h$DBHOST -u$DBUSER -p$DBPASS $1 < $2
}

for db in ${databases[@]}; do
  uncompress $db
  filename="${db/.gz/}"
  dbname="${db/.sql/}"
  if [ "$dbname" == 'mysql' ]; then
    break
  fi
  createdb $dbname
  2innodb $filename
  importdb $dbname $filename
done
