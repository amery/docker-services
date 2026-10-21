#!/bin/sh

set -eu

find_base() {
	local x="$1"

	while true; do
		if [ -s "$x/Dockerfile" -o -s "$x/Dockerfile.in" ]; then
			echo "$x"
		elif [ "${x:-/}" != "/" ]; then
			x="${x%/*}"
			continue
		fi
		break
	done
}

# <group>/<name>/<version> is published as docker-<group>-<name>:<version>
image_name() {
	local d="${1%/*}"
	local name="${d##*/}"

	d="${d%/*}"
	echo "docker-${d##*/}-$name"
}

tags() {
	local x= v= n=
	local d0= d1=

	for x; do
		d0="$(find_base "$(realpath -es "$x")")"
		if [ ! -d "$d0" ]; then
			echo "$x: Invalid docker dir" >&2
		else
			v="${d0##*/}"
			d1="$(readlink -f "$d0")"
			n="$(image_name "$d1")"

			if [ "$d0" != "$d1" ]; then
				d0="$n:${d1##*/}"
			fi

			echo "$n:$v $d0"
		fi
	done
}

# process docker dirs
#
find -L * -name 'Dockerfile' -o -name 'Dockerfile.in' |
	sed -e 's|/[^/]\+$||' | sort -uV |
	while read x; do
		tags "$x"
	done
