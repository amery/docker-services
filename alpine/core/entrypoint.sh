#!/bin/sh

if [ -z "${ENTRYPOINT_QUIET_LOGS:-}" ]; then
    exec 3>&1
else
    exec 3>/dev/null
fi

set -eu
for x in /etc/entrypoint.d/*; do
	if [ -f "$x" -a -x "$x" ]; then
		echo "$0: $x"
		"$x"
	fi
done

exec 3>&-

exec /usr/bin/supervisord -c /etc/supervisord.conf
