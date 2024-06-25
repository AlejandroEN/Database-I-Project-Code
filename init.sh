#!/bin/bash

set -e

psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "/sql-files/schemas.sql"

schemas=$(psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -t -c "SELECT schema_name FROM information_schema.schemata WHERE schema_name LIKE '%datos';")

for schema in $schemas; do
	echo "SET search_path TO $schema;" | cat - /sql-files/tables.sql | psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"
done

tables=$(psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -t -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'mil_datos' AND table_type = 'BASE TABLE' AND table_schema NOT IN ('pg_catalog', 'information_schema');")

schemas_names=("diezmil_datos")
schemas_sizes=("100000")

for index in "${!schemas_names[@]}"; do
	schema="${schemas_names[index]}"
	size="${schemas_sizes[index]}"

	for table in $tables; do
		filename="${table}_data_${size}.csv"
		psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -c "\COPY $schema.$table FROM '/csv-files/$filename' DELIMITER ',' CSV HEADER;"
	done
done
