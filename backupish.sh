# CHANGE BELOW THIS LINE WITH YOUR CREDS

DB_USER="your_username"             
DB_PASSWORD="your_password"      
DB_HOST="localhost"               
BACKUP_DIR="databases" 
DB_LIST="databases.txt"     
DATE=$(date +"%Y-%m-%d_%H-%M-%S")   

# DO NOT CHANGE ANYTHING BELOW THIS LINE 

mkdir -p "$BACKUP_DIR"

if [ ! -f "$DB_LIST" ]; then
    echo "File $DB_LIST not found! Check the file path." >&2
    exit 1
fi

echo "💾 Starting the backup proccess...."

# foreach DB 
for DB in "${DATABASES[@]}"; do
    echo "⌛️ Generating backup for Database: $DB"
    FILENAME="${BACKUP_DIR}/${DB}_${DATE}.sql.gz"
    
    # let's extract them
    mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB" | gzip > "$FILENAME"
    
    if [ $? -eq 0 ]; then
        echo "😊 The backup for database $DB completed : $FILENAME"
    else
        echo "😢 Something went wrong during backup database $DB" >&2
    fi
done

echo "🤩 ENTIRE BACKUP PROCEDURE COMLETED!!!!"