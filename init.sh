#!/bin/bash

set -e

psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f "/sql-files/create_schemas.sql"

schemas=$(psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -t -c "SELECT schema_name FROM information_schema.schemata WHERE schema_name LIKE '%datos';")

for schema in $schemas; do
	echo "SET search_path TO $schema;" | cat - /sql-files/create_tables.sql | psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"
done

tables=$(psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -t -c "SELECT relname AS table_name FROM pg_class WHERE relkind = 'r' AND relnamespace IN (SELECT oid FROM pg_namespace WHERE nspname = 'mil_datos') ORDER BY oid;")

schemas_names=("mil_datos" "diezmil_datos" "cienmil_datos" "millon_datos")
schemas_sizes=("1000" "10000" "100000" "1000000")

for index in "${!schemas_names[@]}"; do
	schema="${schemas_names[index]}"
	size="${schemas_sizes[index]}"

	for table in $tables; do
		filename="${table}_data_${size}.csv"
		psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -c "\COPY $schema.$table FROM '/csv-files/$filename' DELIMITER ',' CSV HEADER;"
	done
done
