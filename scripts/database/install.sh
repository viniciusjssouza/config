#!/bin/bash
#
# Script for creating the development and test databases
# and giving full access to a new user which will manage them.
#
# The new user name is the same of the project.
# The user password is 'test123'.
#
# It requires the command-line database client.
#########################################################################

function read_input {
  echo -n "Enter the database (project) name: "
  read name
  echo -n "Enter the root user password: "
  read -s password
  echo ""
}

function create_database {
  echo "Creating the database $1"
  mysql --user="root" --password="$password" --execute="CREATE DATABASE $1;"
  mysql --user="root" --password="$password" --execute="GRANT ALL PRIVILEGES ON $1.* TO '$name'@'localhost';"
}

function create_user {
  mysql --user="root" --password="$password" --execute="CREATE USER '${name}'@'localhost' IDENTIFIED BY 'test123';"
}

read_input
echo "--------------------------------------------------------"
create_user
create_database "${name}_dev"
create_database "${name}_test"

echo "Databases created with success!"