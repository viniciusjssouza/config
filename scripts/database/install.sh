#!/bin/bash
#
# Script for creating the development and test databases
# and giving full access to a new user which will manage them.
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
}

read_input
echo "--------------------------------------------------------"
create_database "${name}_dev"
create_database "${name}_test"

echo "Databases created with success!"