#!/bin/bash

# Prompt for database connection details
echo "Enter database type (mysql/sqlite):"
read db_type

if [ "$db_type" == "mysql" ]; then
  echo "Enter MySQL host:"
  read db_host
  echo "Enter MySQL user:"
  read db_user
  echo "Enter MySQL password:"
  read -s db_pass
  echo "Enter database name:"
  read db_name
  db_connection="mysql -h $db_host -u $db_user -p$db_pass $db_name"
elif [ "$db_type" == "sqlite" ]; then
  echo "Enter SQLite database file path:"
  read db_file
  db_connection="sqlite3 $db_file"
else
  echo "Unsupported database type. Exiting."
  exit 1
fi

# Show options for interaction
echo "Select an option:"
echo "1. Display all records in a table"
echo "2. Insert a new record into a table"
echo "3. Delete a record from a table"
read option

case $option in
  1)
    echo "Enter the table name:"
    read table
    $db_connection "SELECT * FROM $table;"
    ;;
  2)
    echo "Enter the table name:"
    read table
    echo "Enter values for each field, separated by commas:"
    read values
    $db_connection "INSERT INTO $table VALUES ($values);"
    ;;
  3)
    echo "Enter the table name:"
    read table
    echo "Enter the condition for deletion (e.g., id=5):"
    read condition
    $db_connection "DELETE FROM $table WHERE $condition;"
    ;;
  *)
    echo "Invalid option. Exiting."
    exit 1
    ;;
esac
