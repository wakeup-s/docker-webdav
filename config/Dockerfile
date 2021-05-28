FROM httpd

# These variables are inherited from the httpd:alpine image:
# ENV HTTPD_PREFIX /usr/local/apache2
# WORKDIR "$HTTPD_PREFIX"

# Copy in our configuration files.
COPY httpd/ conf/
COPY db-template.kdbx /storage/db.kdbx

RUN groupadd -g 1000 app
RUN adduser --gid 1000 -u 1000 app

RUN set -ex; \
    # Create empty default DocumentRoot.
    mkdir -p "/var/www/html"; \
    # Create directories for Dav data and lock database.
    mkdir -p "/var/lib/dav/data"; \
    touch "/var/lib/dav/DavLock"; \
    chown -R app:app "/var/lib/dav"; \
    # Enable DAV modules.
    for i in dav dav_fs; do \
        sed -i -e "/^#LoadModule ${i}_module.*/s/^#//" "conf/httpd.conf"; \
    done; \
    \
    # Make sure authentication modules are enabled.
    for i in authn_core authn_file authz_core authz_user auth_basic auth_digest; do \
        sed -i -e "/^#LoadModule ${i}_module.*/s/^#//" "conf/httpd.conf"; \
    done; \
    \
    # Make sure other modules are enabled.
    for i in alias headers mime setenvif; do \
        sed -i -e "/^#LoadModule ${i}_module.*/s/^#//" "conf/httpd.conf"; \
    done; \
    \
    # Run httpd as "app" (instead of "daemon").
    for i in User Group; do \
        sed -i -e "s|^$i .*|$i app|" "conf/httpd.conf"; \
    done; \
    \
    # Include enabled configs and sites.
    printf '%s\n' "Include conf/conf-enabled/*.conf" \
        >> "conf/httpd.conf"; \
    printf '%s\n' "Include conf/sites-enabled/*.conf" \
        >> "conf/httpd.conf"; \
    \
    # Enable dav and default site.
    mkdir -p "conf/conf-enabled"; \
    mkdir -p "conf/sites-enabled"; \
    ln -s ../conf-available/dav.conf "conf/conf-enabled"; \
    ln -s ../sites-available/default.conf "conf/sites-enabled";

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
EXPOSE 80/tcp
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "httpd-foreground" ]
