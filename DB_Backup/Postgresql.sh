#!/bin/bash
HOST=$1
PORT=$2
USER=$3
PASSWORD=$4
DBNAME=$5

# Validate input
if [ $# -ne 5 ]; then
  echo "Usage: $0 <host> <port> <username> <password> <dbname>"
  exit 1
fi
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

SQL_FILE="${DBNAME}_${TIMESTAMP}.sql"
TAR_FILE="${DBNAME}_${TIMESTAMP}.tar.gz"
export PGPASSWORD=$PASSWORD

echo "Starting backup of database '$DBNAME'..."

pg_dump -h "$HOST" -p "$PORT" -U "$USER" "$DBNAME" > "$SQL_FILE"

# Check if backup succeeded
if [ $? -eq 0 ]; then
  echo "Database dump completed: $SQL_FILE"
  
  tar -czf "$TAR_FILE" "$SQL_FILE"
  
  if [ $? -eq 0 ]; then
    echo "Backup compressed successfully: $TAR_FILE"
    rm -f "$SQL_FILE"
  else
    echo "Compression failed!"
    exit 1
  fi

else
  echo "Database backup failed!"
  exit 1
fi
unset PGPASSWORD
