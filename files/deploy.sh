#!/bin/sh -e
#
cd /usr/local/tomcat/webapps/
rm -r ROOT docs examples host-manager manager
export VERSION="1.3.0"
export DESTINATION="/opt/guacamole"
mkdir -p "$DESTINATION"
curl -L "http://sourceforge.net/projects/guacamole/files/current/extensions/guacamole-auth-jdbc-$VERSION.tar.gz/download" | \
tar -zx \
 -C "$DESTINATION" \
 --wildcards \
 --no-anchored \
 --strip-components=1 \
 "*.jar" \
 "*.sql"
export DESTINATION="/usr/local/tomcat/webapps"
curl -L "http://sourceforge.net/projects/guacamole/files/current/binary/guacamole-${VERSION}.war/download" > "$DESTINATION/ROOT.war"
export DESTINATION="/opt/guacamole"
mkdir -p "$DESTINATION/postgresql/"
curl -L "https://jdbc.postgresql.org/download/postgresql-9.4-1201.jdbc41.jar" > "$DESTINATION/postgresql/postgresql-9.4-1201.jdbc41.jar"
apt-get update && apt-get install -y postgresql-client
