#!/bin/bash

# iterate over all schema files
for schema in /docker-entrypoint-initdb.d/schemas.sql
do
  # get the base name of the schema file (without extension)
  base=$(basename -- "$schema")
  base="${base%.*}"

  # apply the schema
  psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f "$schema"

  # apply the corresponding tables.sql file
  psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f "/docker-entrypoint-initdb.d/tables/$base.sql"
done
