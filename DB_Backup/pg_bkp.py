import subprocess
import sys
import os
from datetime import datetime
import tarfile
if len(sys.argv) != 6:
    print("Usage: python3 pg_backup.py <host> <port> <username> <password> <dbname>")
    sys.exit(1)

HOST, PORT, USER, PASSWORD, DBNAME = sys.argv[1:6]

timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
sql_file = f"{DBNAME}_{timestamp}.sql"
tar_file = f"{DBNAME}_{timestamp}.tar.gz"
os.environ["PGPASSWORD"] = PASSWORD

print(f"Starting backup of database '{DBNAME}'...")

try:
    subprocess.run(
        ["pg_dump", "-h", HOST, "-p", PORT, "-U", USER, DBNAME],
        stdout=open(sql_file, "w"),
        check=True
    )
    print(f"Database dump completed: {sql_file}")
except subprocess.CalledProcessError:
    print("Database backup failed!")
    sys.exit(1)
try:
    with tarfile.open(tar_file, "w:gz") as tar:
        tar.add(sql_file)
    print(f"Backup compressed successfully: {tar_file}")
    os.remove(sql_file)  # Remove original SQL file
except Exception as e:
    print(f"Compression failed: {e}")
    sys.exit(1)
del os.environ["PGPASSWORD"]
