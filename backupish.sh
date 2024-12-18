# CHANGE BELOW THIS LINE WITH YOUR CREDS

DB_USER="your_username"             
DB_PASSWORD="your_password"      
DB_HOST="localhost"               
BACKUP_DIR="databases" 
DB_LIST="DBS.txt"     
DATE=$(date +"%Y-%m-%d_%H-%M-%S")   

# DO NOT CHANGE ANYTHING BELOW THIS LINE 

mkdir -p "$BACKUP_DIR"

if [ ! -f "$DB_LIST" ]; then
    echo "File $DB_LIST not found! Check the file path." >&2
    touch "DBS.txt"
    exit 1
fi

echo "💾 Starting the backup proccess...."

while IFS= read -r DB; do
    # ignoring empty lines
    if [[ -z "$DB" || "$DB" == \#* ]]; then
        continue
    fi
    
    echo "Creating backup for : $DB"
    FILENAME="${BACKUP_DIR}/${DB}_${DATE}.sql.gz"
    
    mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" "$DB" | gzip > "$FILENAME"
    
    if [ $? -eq 0 ]; then
        echo "😊 The backup for database $DB completed : $FILENAME"
    else
         echo "😢 Something went wrong during backup database $DB" >&2
    fi
done < "$DB_LIST_FILE"

echo "🤩 ENTIRE BACKUP PROCEDURE COMLETED!!!!"