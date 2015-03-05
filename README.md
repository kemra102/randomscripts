# Random Scripts

## MySQL

Scripts under the `mysql/` direcotry are related somehow to MySQL/MariaDB/Percona.

### mysql_db_import.sh

This script is for either migration of databases or for use in disaster recovery. It takes a directory full of DB dumps and imports them.

It has the following features:

* Can uncompress dumps if they are compressed.
* Can change tables types from MyISAM to InnoDB.

