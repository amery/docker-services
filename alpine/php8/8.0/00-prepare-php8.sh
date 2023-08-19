#!/bin/sh

set -eu

# composer wrapper
F=/usr/bin/composer
cat <<EOT > "$F"
#!/bin/sh

set -eu
exec run-user php "/usr/bin/composer${COMPOSER_PREFERRED:-2}" "\$@"
EOT
chmod +x "$F"

# error_log
chown -R $USER_NAME /var/log/php8
