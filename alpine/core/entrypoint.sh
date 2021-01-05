#!/bin/sh

if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
    exec 3>&1
else
    exec 3>/dev/null
fi

set -eu

# create appuser
#
if [ -n "${USER_UID:-}" ]; then

	: ${USER_NAME:=appuser}
	: ${USER_GID:=$USER_UID}
	: ${USER_HOME:=/home/$USER_NAME}
	: ${USER_SHELL:=/sbin/nologin}

	if ! getent group "$USER_NAME"; then
		addgroup -S -g "$USER_GID" "$USER_NAME"
	fi

	if ! getent passwd "$USER_NAME"; then
		opt="-S -D"

		[ ! -d "$USER_HOME" ] || opt="$opt -H"

		adduser $opt \
			-s "$USER_SHELL" -h "$USER_HOME" \
			-G "$USER_NAME" -g "$USER_NAME"  \
			-u "$USER_UID" "$USER_NAME"
	fi
elif [ -s /etc/entrypoint.d/user_env ]; then
	. /etc/entrypoint.d/user_env
fi

: ${USER_NAME:=appuser}
export USER_NAME

# prepare `run-user` helper
#
sed -i -e "s|@@USER_NAME@@|$USER_NAME|g" /usr/bin/run-user

# run-once scripts
#
for x in /etc/entrypoint.d/*; do
	if [ -f "$x" -a -x "$x" ]; then
		echo "$0: $x"
		"$x"
	fi
done

exec 3>&-

exec /usr/bin/supervisord -c /etc/supervisord.conf
