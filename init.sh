#!/bin/bash

set -e

psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "/sql-files/schemas.sql"

schemas=$(psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -t -c "SELECT schema_name FROM information_schema.schemata WHERE schema_name LIKE '%datos';")

for schema in $schemas
  do
	echo "SET search_path TO $schema;" | cat - /sql-files/tables.sql | psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"
  done
