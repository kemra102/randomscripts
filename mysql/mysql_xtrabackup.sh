#!/usr/bin/env bash

DBHOST='localhost'
DBUSER='root'
DBPASS=''
BACKUPDIR='/backups/mysql'
COMPRESS=true
RETENTION=3

if $COMPRESS; then
  oldbackup="$BACKUPDIR/$(date --date="$RETENTION days ago" +"%Y%m%d").tar.gz"
else
  oldbackup="$BACKUPDIR/$(date --date="$RETENTION days ago" +"%Y%m%d")"
fi
if [ -e "$oldbackup" ]; then
  rm -f "$oldbackup"
fi

innobackupex --host=$DBHOST --user=$DBUSER --password=$DBPASS --no-timestamp $BACKUPDIR/"$(date +%Y%m%d)"
innobackupex --apply-log $BACKUPDIR/"$(date --date=%Y%m%d)"
if $COMPRESS; then
  tar -czf $BACKUPDIR/"$(date +%Y%m%d)".tar.gz $BACKUPDIR/"$(date +%Y%m%d)"
  rm -rf ${BACKUPDIR:?}/"$(date +%Y%m%d)"
fi
