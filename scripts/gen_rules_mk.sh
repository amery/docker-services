#!/bin/sh

TAB=$(printf "\t")

cat <<EOT
# use %.in as template to generate % but making
# sure a sed error doesn't damage the file and
# the inode isn't replaced because it could be
# bind mounted inside the container
#
%: %.in \$(RULES_MK) \$(CONFIG_MK)
	@sed \\
EOT
for x; do
	echo "$TAB$TAB-e 's|@@$x@@|\$($x)|g' \\"
done

	cat <<EOT
		\$< > \$@~
	@if ! diff -u \$@ \$@~; then mv \$@~ \$@; else rm \$@~; fi 2> /dev/null
EOT

