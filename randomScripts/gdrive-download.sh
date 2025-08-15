#!/bin/bash
# Google Drive file downloader (works for small & large files)
# Usage: ./gdrive-download.sh <FILE_ID> <OUTPUT_FILENAME>

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <FILE_ID> <OUTPUT_FILENAME>"
    exit 1
fi

FILE_ID="$1"
OUTPUT="$2"
COOKIE_FILE="$(mktemp)"

# First request to get the confirmation token
CONFIRM=$(curl -sc "$COOKIE_FILE" "https://drive.google.com/uc?export=download&id=${FILE_ID}" \
    | grep -o 'confirm=[^&]*' | sed 's/confirm=//')

# Second request with the confirmation token
curl -Lb "$COOKIE_FILE" "https://drive.google.com/uc?export=download&confirm=${CONFIRM}&id=${FILE_ID}" -o "$OUTPUT"

# Clean up
rm -f "$COOKIE_FILE"
echo "Downloaded '$OUTPUT' from Google Drive."

