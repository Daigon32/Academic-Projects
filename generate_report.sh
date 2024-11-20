#!/bin/bash

# Prompt the user for the CSV file
echo "Enter the path to the CSV file:"
read csv_file

# Check if the file exists
if [ ! -f "$csv_file" ]; then
  echo "CSV file does not exist. Exiting."
  exit 1
fi

# Prompt for the numeric column to analyze
echo "Enter the column number (starting from 1) for numeric analysis:"
read column

# Generate summary: number of records, average, min, and max of the specified column
record_count=$(wc -l < "$csv_file")
average_value=$(awk -F',' -v col="$column" '{sum+=$col} END {if (NR>0) print sum/NR}' "$csv_file")
max_value=$(awk -F',' -v col="$column" 'BEGIN {max=-9999999} {if ($col>max) max=$col} END {print max}' "$csv_file")
min_value=$(awk -F',' -v col="$column" 'BEGIN {min=9999999} {if ($col<min) min=$col} END {print min}' "$csv_file")

# Save the report to a file
report_file="report.txt"
echo "Number of records: $record_count" > "$report_file"
echo "Average value of column $column: $average_value" >> "$report_file"
echo "Max value: $max_value" >> "$report_file"
echo "Min value: $min_value" >> "$report_file"

echo "Report generated: $report_file"

# Optionally send the report by email (uncomment and set the correct email)
# echo "The report is attached." | mail -s "CSV Report" -A "$report_file" user@example.com
