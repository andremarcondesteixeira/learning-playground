#!/bin/bash

DB_FILE="database"
NUM_RECORDS=100000000
KEY_RANGE=100000

rm -rf "$DB_FILE"
touch "$DB_FILE"

echo "0,0" >> "$DB_FILE"

echo "-----------------------------------------------------"
echo "Starting generation of ${NUM_RECORDS} records"
echo "Key Range: 1 - ${KEY_RANGE}"
echo "-----------------------------------------------------"

echo "Writing ${NUM_RECORDS} records..."

start_time=$(date +%s.%N)

seq $NUM_RECORDS | awk -v range=$KEY_RANGE '
    BEGIN { srand() }
    {
        key = int(rand() * range) + 1
        print key ",value_record_" $0
    }
' >> "$DB_FILE"

echo "100001,100001" >> "$DB_FILE"

end_time=$(date +%s.%N)
elapsed=$(echo "$end_time - $start_time" | bc)

echo "   -> Insertion Complete."
echo "   -> Time taken: ${elapsed} seconds"
echo ""

db_size=$(du -h "$DB_FILE" | cut -f1)
echo "Final Database Size: $db_size"
