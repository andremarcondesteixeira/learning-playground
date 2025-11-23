#!/bin/bash

. ./naivedb.sh

# ===================================================
# BENCHMARK: READ (EXISTING KEY AT BEGINNING OF FILE)
# ===================================================
SEARCH_KEY=0

echo "Benchmarking Read (Existing Key at beginning of file: ${SEARCH_KEY})..."

start_time=$(date +%s.%N)
result=$(db_get $SEARCH_KEY)
end_time=$(date +%s.%N)
elapsed=$(awk "BEGIN {print $end_time - $start_time}")

echo "   -> Found value: $result"
echo "   -> Time taken: ${elapsed} seconds"
echo ""

# =============================================
# BENCHMARK: READ (EXISTING KEY AT END OF FILE)
# =============================================
SEARCH_KEY=100001

echo "Benchmarking Read (Existing Key at end of file: ${SEARCH_KEY})..."

start_time=$(date +%s.%N)
result=$(db_get $SEARCH_KEY)
end_time=$(date +%s.%N)
elapsed=$(awk "BEGIN {print $end_time - $start_time}")

echo "   -> Found value: $result"
echo "   -> Time taken: ${elapsed} seconds"
echo ""

# ==================================
# BENCHMARK: READ (NON-EXISTENT KEY)
# ==================================

# We pick a key outside the range (e.g., 9999)
MISSING_KEY=100002

echo "Benchmarking Read (Non-Existent Key: ${MISSING_KEY})..."

start_time=$(date +%s.%N)
result=$(db_get $MISSING_KEY)
end_time=$(date +%s.%N)
elapsed=$(awk "BEGIN {print $end_time - $start_time}")

echo "   -> Found value: (Empty means correct) '$result'"
echo "   -> Time taken: ${elapsed} seconds"
echo "-----------------------------------------------------"
