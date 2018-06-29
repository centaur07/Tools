#!/bin/bash

mysql_cmd="/usr/bin/mysql"
use_default_prompt="(Press enter to use default)"
default_pwd=""

read -p "Please enter MySQL user: " mysql_user

read -p "Please enter MySQL password: " -s mysql_pwd
echo ""

read -p "Please enter database name: " db_name

read -p "Please enter the user for ${db_name} ${use_default_prompt}: " db_user
if [ -z "${db_user}" ]; then
    db_user="${db_name}"
fi

read -p "Please enter the password for ${db_user} ${use_default_prompt}: " -s db_pwd
echo ""
if [ -z "${db_pwd}" ]; then
    db_pwd=${default_pwd}
fi

echo "Drop database ${db_name} if exists"
"${mysql_cmd}" -u"${mysql_user}" -p"${mysql_pwd}" -e "DROP DATABASE IF EXISTS ${db_name};"

echo "Create database ${db_name}"
"${mysql_cmd}" -u"${mysql_user}" -p"${mysql_pwd}" -e "CREATE DATABASE ${db_name};"

echo "Create user ${db_user} and grant privileges"
"${mysql_cmd}" -u"${mysql_user}" -p"${mysql_pwd}" -e "GRANT ALL ON ${db_name}.* TO ${db_user}@localhost IDENTIFIED BY \"${db_pwd}\";"
"${mysql_cmd}" -u"${mysql_user}" -p"${mysql_pwd}" -e "FLUSH PRIVILEGES;"

echo "Finish"
