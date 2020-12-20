#!/bin/sh

exec >&3
set -eu

U=mysql
R=/var/run/mysqld
D=/var/lib/mysql

[ -d "$R" ] || mkdir /var/run/mysqld
chown -R $U:$U "$R" "$D"

if [ ! -d "$D/mysql" ]; then
	mysql_install_db --user=$U --ldata=$D

	if [ -z "${MYSQL_ROOT_PASSWORD:-}" ]; then
		MYSQL_ROOT_PASSWORD="$(pwgen 16 1)"
	fi

	F=$(mktemp)

	cat <<-EOT > "$F"
	USE mysql
	FLUSH PRIVILEGES ;
	GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
	GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
	SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
	DROP DATABASE IF EXISTS test ;
	FLUSH PRIVILEGES ;
	EOT

	if [ -n "${MYSQL_DATABASE:-}" ]; then

		cat <<-EOT

		CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET ${MYSQL_CHARSET:-utf8} COLLATE ${MYSQL_COLLATION:-utf8_general_ci};"
		EOT

		if [ -n "${MYSQL_USER:-}" ]; then
			cat <<-EOT
			GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '${MYSQL_PASSWORD:-}'
			EOT
		fi
	fi >> "$F"

	/usr/bin/mysqld_safe --user=$U --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < "$F"
fi
