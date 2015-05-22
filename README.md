# Random Scripts

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
