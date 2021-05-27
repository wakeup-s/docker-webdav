#!/bin/sh
set -e

# Environment variables that are used if not empty:
#   SERVER_NAMES
#   LOCATION
#   AUTH_TYPE
#   REALM
#   USERNAME
#   PASSWORD
#   ANONYMOUS_METHODS
#   SSL_CERT

# Just in case this environment variable has gone missing.
HTTPD_PREFIX="${HTTPD_PREFIX:-/usr/local/apache2}"

# Create directories for Dav data and lock database.
[ ! -e "/var/lib/dav/data/common/db.kdbx" ] && mkdir -p "/var/lib/dav/data/common" && cp "/storage/db.kdbx" "/var/lib/dav/data/common/db.kdbx"
[ ! -e "/var/lib/dav/data/secure/db.kdbx" ] && mkdir -p "/var/lib/dav/data/secure" && cp "/storage/db.kdbx" "/var/lib/dav/data/secure/db.kdbx"
[ ! -e "/var/lib/dav/data/critical/db.kdbx" ] && mkdir -p "/var/lib/dav/data/critical" && cp "/storage/db.kdbx" "/var/lib/dav/data/critical/db.kdbx"
[ ! -e "/htpasswd/user.passwd" ] && touch "/htpasswd/user.passwd" && chown app:app "/htpasswd/user.passwd" && chmod 0640 "/htpasswd/user.passwd"
[ ! -e "/var/lib/dav/DavLock" ] && touch "/var/lib/dav/DavLock"
chown -R app:app "/var/lib/dav"

exec "$@"
