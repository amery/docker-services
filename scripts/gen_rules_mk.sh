#!/bin/sh

DOLLAR="\$\$"

cat <<EOT
export DOCKER
SCRIPTS = $(dirname "$0")

EOT

# Render each template through settle, so a rendering that says the same
# thing again leaves the file's mtime, and the image built from it, alone.
# config.mk is in BUILD_SYS: it is only written when a variable is added.

if [ $# -eq 0 ]; then
	# no variable replacements
	#
	cat <<EOT
%: %.in \$(RULES_MK) \$(CONFIG_MK)
	\$(call settle,\$@,cat \$<,diff)

\$(CONFIG_MK): \$(RULES_MK)
	@:
EOT
	exit
fi

SED="sed"
for x; do
	SED="$SED -e 's|@@$x@@|\$($x)|g'"
done

X="${DOLLAR}x"
cat <<EOT
%: %.in \$(RULES_MK) \$(CONFIG_MK)
	\$(call settle,\$@,$SED \$<,diff)

\$(CONFIG_MK): \$(RULES_MK)
	@for x in $*; do \\
		if ! grep -q "^$X " \$@ 2> /dev/null; then \\
			echo "$X ?=" >> \$@; \\
		fi; \\
	done
EOT
