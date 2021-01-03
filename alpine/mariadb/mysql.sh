#!/bin/sh

exec >&3
set -eu

U=mysql
R=/var/run/mysqld
D=/var/lib/mysql
H=$(hostname)

[ -d "$R" ] || mkdir "$R"
chown -R $U:$U "$R" "$D"

escape() {
	echo "$1" | sed -e 's|\([;"\\]\)|\\\1|g' -e "s|'|''|g"
}

if [ ! -d "$D/mysql" ]; then

	: ${MYSQL_ROOT_PASSWORD:="$(pwgen 16 1)"}

	F=$(mktemp)

	cat <<-EOT > "$F"
	USE mysql;
	FLUSH PRIVILEGES;

	GRANT ALL ON *.* TO 'root'@'%' identified by '$(escape "$MYSQL_ROOT_PASSWORD")' WITH GRANT OPTION;
	DELETE FROM user WHERE host = '$H';
	DELETE FROM proxies_priv WHERE host = '$H';
	EOT

	if [ -n "${MYSQL_DATABASE:-}" ]; then

		: ${MYSQL_CHARSET:=utf8}
		: ${MYSQL_COLLATION:=utf8_general_ci}

		cat <<-EOT

		CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET $MYSQL_CHARSET COLLATE $MYSQL_COLLATION;
		EOT

		if [ -n "${MYSQL_USER:-}" ]; then

			: ${MYSQL_PASSWORD:=}

			cat <<-EOT
			GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%' identified by '$(escape "$MYSQL_PASSWORD")';
			EOT
		fi
	fi >> "$F"

	cat <<-EOT >> "$F"
	FLUSH PRIVILEGES;
	DROP DATABASE IF EXISTS test;
	EOT

	grep -hn ^ "$F"
	set -x
	mysql_install_db --user="$U" > /dev/null
	exec mysqld --user "$U" --bootstrap < "$F"
fi
