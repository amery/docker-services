#!/bin/sh

set -eu
F="$1"
shift

for x; do
	if ! grep -q "^$x " "$F" 2> /dev/null; then
		echo "$x ?=" >> "$F"
	fi
done
