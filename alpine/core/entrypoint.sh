#!/bin/sh

set -eu
for x in /etc/entrypoint.d/*; do
	if [ -f "$x" -a -x "$x" ]; then
		echo "$0: $x"
		"$x"
	fi
done

exec /usr/bin/supervisord -c /etc/supervisord.conf
