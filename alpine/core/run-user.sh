#!/bin/sh

set -eu
U=@@USER_NAME@@
H=@@USER_HOME@@

if [ $# -eq 0 ]; then
	cat <<-EOT >&2
	Usage: $0 <command>
	
	Run <command> as $U
	EOT
	exit 1
fi

if [ "$U" != "root" -a "$(id -ur)" = 0 ]; then
	set -- s6-setuidgid "$U" env -i HOME=$H "PATH=$PATH" "$@"
fi

exec "$@"
