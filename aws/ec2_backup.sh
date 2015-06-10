#!/usr/bin/env bash

VOLUMES=()
RETENTION=3
AWS_ACCESS_KEY_ID=''
AWS_SECRET_ACCESS_KEY=''
AWS_DEFAULT_REGION=''

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_REGION

# Snapshot defined volumes
for volume in "${VOLUMES[@]}"; do
  aws ec2 create-snapshot --volume-id "$volume" --description "backup-script"
done

# Delete snapshots older than $RETENTION
for snapshot in $(aws ec2 describe-snapshots --filters Name=description.Values=backup-script | jq .Snapshots[].SnapshotId | sed 's/\"//g'); do
  SNAPSHOTDATE=$(aws ec2 describe-snapshots --filters Name=snapshot-id.Values="$snapshot" | jq .Snapshots[].StartTime | cut -d T -f1 | sed 's/\"//g')
  STARTDATE=$(date +%s)
  ENDDATE=$(date -d "$SNAPSHOTDATE" +%s)
  INTERVAL=$(( (STARTDATE - ENDDATE) / (60*60*24) ))
  if (( INTERVAL > RETENTION )); then
    aws ec2 delete-snapshot --snapshot-id "$snapshot"
  fi
done

