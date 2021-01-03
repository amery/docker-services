#!/bin/sh

if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
    exec 3>&1
else
    exec 3>/dev/null
fi

set -eu

if [ -n "${USER_UID:-}" ]; then
	export USER_NAME="${USER_NAME:-appuser}"
	export USER_GID="${USER_GID:-$USER_UID}"
	export USER_HOME="${USER_HOME:-/home/$USER_NAME}"
	export USER_SHELL="${USER_SHELL:-/sbin/nologin}"

	addgroup -S -g "$USER_GID" "$USER_NAME"

	opt="-S -D"
	[ ! -d "$USER_HOME" ] || opt="$opt -H"

	adduser $opt \
		-s "$USER_SHELL" -h "$USER_HOME" \
		-G "$USER_NAME" -g "$USER_NAME"  \
		-u "$USER_UID" "$USER_NAME"
fi

for x in /etc/entrypoint.d/*; do
	if [ -f "$x" -a -x "$x" ]; then
		echo "$0: $x"
		. "$x"
	fi
done

exec 3>&-

exec /usr/bin/supervisord -c /etc/supervisord.conf
