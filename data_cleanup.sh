#!/bin/bash

# Prompt the user for the directory containing text files
echo "Enter the directory containing text files:"
read dir

# Check if the directory exists
if [ ! -d "$dir" ]; then
  echo "Directory does not exist. Exiting."
  exit 1
fi

# Create a new directory for cleaned data if it doesn't exist
cleaned_dir="$dir/cleaned_data"
mkdir -p "$cleaned_dir"

# Log file to store processed filenames
log_file="$dir/cleanup_log.txt"
> "$log_file"  # Clear the log file if it exists

# Loop through each text file in the directory
for file in "$dir"/*.txt; do
  if [ -f "$file" ]; then
    # Process the file: remove blank lines, convert to lowercase, and remove duplicate lines
    cleaned_file="$cleaned_dir/$(basename "$file")"
    awk 'NF' "$file" | tr '[:upper:]' '[:lower:]' | sort | uniq > "$cleaned_file"
    
    # Log the processed file
    echo "Processed: $(basename "$file")" >> "$log_file"
    echo "Cleaned file saved as: $cleaned_file"
  fi
done

echo "Data cleanup completed. Check the 'cleaned_data' directory for results and 'cleanup_log.txt' for the log."
