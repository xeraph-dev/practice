#!/bash

DB_PATH="$(pwd)/$(dirname "$0")/database.db"
SCHEMA_PATH="$(pwd)/$(dirname "$0")/schema.sql"

if [ -f "$DB_PATH" ]; then rm "$DB_PATH"; fi
if [ -f "$SCHEMA_PATH" ]; then sqlite3 "$DB_PATH" <"$SCHEMA_PATH"; fi
