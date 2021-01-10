#!/bin/bash
#
export GUACAMOLE_HOME="$HOME/.guacamole"
export GUACAMOLE_EXT="$GUACAMOLE_HOME/extensions"
export GUACAMOLE_LIB="$GUACAMOLE_HOME/lib"
export GUACAMOLE_PROPERTIES="$GUACAMOLE_HOME/guacamole.properties"
set_property() {
 NAME="$1"
 VALUE="$2"
 # Ensure guacamole.properties exists
 if [ ! -e "$GUACAMOLE_PROPERTIES" ]; then
 mkdir -p "$GUACAMOLE_HOME"
 echo "# guacamole.properties - generated `date`" > "$GUACAMOLE_PROPERTIES"
 fi
 # Set property
 echo "$NAME: $VALUE" >> "$GUACAMOLE_PROPERTIES"
}
associate_postgresql() {
 set_property "postgresql-hostname" "$POSTGRES_HOSTNAME"
 set_property "postgresql-port" "$POSTGRES_PORT"
 set_property "postgresql-database" "$POSTGRES_DATABASE"
 set_property "postgresql-username" "$POSTGRES_USER"
 set_property "postgresql-password" "$POSTGRES_PASSWORD"

 # Add required .jar files to GUACAMOLE_LIB and GUACAMOLE_EXT
 ln -s /opt/guacamole/postgresql/postgresql-*.jar "$GUACAMOLE_LIB"
ln -s /opt/guacamole/postgresql/guacamole-auth-*.jar "$GUACAMOLE_EXT"
 export PGPASSWORD=$POSTGRES_PASSWORD
 if [[ `psql -h $POSTGRES_HOSTNAME -p $POSTGRES_PORT -U $POSTGRES_USER -tAc "SELECT 1 FROM information_schema.tables WHERE table_name='guacamole_user'"` == "1" ]]
 then
 echo "Database already exists"
 else
 echo "Database does not exist - Creating"
 cat /opt/guacamole/postgresql/schema/*.sql | psql -h $POSTGRES_HOSTNAME -p $POSTGRES_PORT -U $POSTGRES_USER
 fi
}
start_guacamole() {
 cd /usr/local/tomcat
# exec bash
 exec catalina.sh run
}
rm -Rf "$GUACAMOLE_HOME"
mkdir -p "$GUACAMOLE_EXT"
mkdir -p "$GUACAMOLE_LIB"
set_property "guacd-hostname" "$GUACD_PORT_4822_TCP_ADDR"
set_property "guacd-port" "$GUACD_PORT_4822_TCP_PORT"
associate_postgresql
start_guacamole
