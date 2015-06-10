# Random Scripts

## AWS

Scripts under the `aws/` direcotry are related somehow to Amazon Web Services.

### ec2_backup.sh

This script takes a list of EBS volumes and snapshots them, pruning old snapshots as it does so.

The script:

* Takes an array of EBS Volume ID's and snapshots them.
* Prunes old snapshots created by this script (default older than 3 days).

You need to provide the following details to make the script work:

* Space seperated list of EBS Volumes to be snapshotted.
* AWS Access Key ID
* AWS Secret Access Key
* AWS Default Region

If you launch the EC2 instance that is running this script with a suitable IAM role it is not necessary to include the Access Keys in the script. For this script to work you should have an IAM Role/User with the following access:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:Describe*",
                "ec2:CreateSnapshot",
                "ec2:DeleteSnapshot"
            ],
            "Resource": "*"
        }
    ]
}
```

## MySQL

Scripts under the `mysql/` direcotry are related somehow to MySQL/MariaDB/Percona.

### mysql_db_import.sh

This script is for either migration of databases or for use in disaster recovery. It takes a directory full of DB dumps and imports them.

It has the following features:

* Can uncompress dumps if they are compressed.
* Can change tables types from MyISAM to InnoDB.

### mysql_dump.sh

This script dumps all MySQL databases (with the exception of the `mysql` database) on the taregt server.

It has the following features:

* Can compress dumps as they are being performed (saving on disk space immediately).
* Has a retention policy (default is 3 days) keeping the *x* latest days of dumps for each database.

### mysql_xtrabackup.sh

This script does a backup of an entire MySQL database instance using Percona's Xtrabackup utility.

* Can compress dumps as they are being performed (saving on disk space immediately).
* Has a retention policy (default is 3 days) keeping the *x* latest days of dumps for each database.
