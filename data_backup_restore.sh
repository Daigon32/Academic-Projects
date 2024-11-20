#!/bin/bash

# Prompt for operation: Backup or Restore
echo "Choose an operation:"
echo "1. Backup"
echo "2. Restore"
read operation

if [ "$operation" -eq 1 ]; then
  echo "Enter the directory to back up:"
  read dir
  if [ ! -d "$dir" ]; then
    echo "Directory does not exist. Exiting."
    exit 1
  fi
  timestamp=$(date +%Y%m%d%H%M%S)
  backup_file="$dir-backup-$timestamp.tar.gz"
  tar -czf "$backup_file" "$dir"
  echo "Backup saved as $backup_file"
  echo "$(date) - Backup of $dir created as $backup_file" >> backup_log.txt
elif [ "$operation" -eq 2 ]; then
  echo "Available backups:"
  ls *.tar.gz
  echo "Enter the backup file to restore:"
  read backup_file
  if [ ! -f "$backup_file" ]; then
    echo "Backup file does not exist. Exiting."
    exit 1
  fi
  echo "Enter the location to restore the backup:"
  read restore_dir
  tar -xzf "$backup_file" -C "$restore_dir"
  echo "Backup restored to $restore_dir"
else
  echo "Invalid option. Exiting."
  exit 1
fi
