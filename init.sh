#!/bin/bash

set -e
export PGPASSWORD=$POSTGRES_PASSWORD

until psql -h localhost -p 5433 -U $POSTGRES_USER -d $POSTGRES_DB -c '\l'; do
  echo "Postgres is unavailable - sleeping"
  sleep 1
done

echo "Postgres is up - executing commands"

# psql -h localhost -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f "/docker-entrypoint-initdb.d/schemas.sql"

# schemas=$(psql -h localhost -U "$POSTGRES_USER" -d "$POSTGRES_DB" -t -c "SELECT schema_name FROM information_schema.schemata WHERE schema_name LIKE '%Datos';")

# for schema in $schemas
# do
#   psql -h localhost -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SET search_path TO $schema;"

#   psql -h localhost -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f "/docker-entrypoint-initdb.d/tables.sql"
# done