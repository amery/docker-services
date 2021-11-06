#!/bin/sh

for f; do
	if [ -s "$f" ]; then
		sed -e 's|\(@@[^@]\+@@\)|\n\1\n|g' -- "$f" | sed -n -e 's|^@@\([^@]\+\)@@$|\1|p'
	fi
done | sort -uV
