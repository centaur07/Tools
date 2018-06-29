#!/bin/bash

rm_cmd="/bin/rm"
mysql_cmd="/usr/bin/mysql"
cp_cmd="/bin/cp"
tar_cmd="/bin/tar"
default_web_root="/var/www/html"
use_default_prompt="(Press enter to use default)"
backup_file_root="/home/root/rebuild_cart/file"

read -p "Please enter web root ${use_default_prompt}: " web_root
if [ -z "${web_root}" ]; then
    web_root="${default_web_root}"
fi

read -p "Please enter rollback target name: " rollback_target
target_path="${web_root}/${rollback_target}"
backup_file_name="${rollback_target}.tar.gz"
backup_file_path="${backup_file_root}/${backup_file_name}"
rollback_sql_name="${rollback_target}.sql"
rollback_sql_path="${target_path}/$rollback_sql_name"

echo "Check if backup file ${backup_file_path} exists"
if [ -f " ${backup_file_path}" ]; then
    echo "Backup file do not exist, stop script!"
    exit 0
fi

echo "Copy backup file from ${backup_file_path} to ${web_root}"
"${cp_cmd}" -f "${backup_file_path}" "${web_root}"

echo  "Remove target directory ${target_path}"
cd "${web_root}"
"${rm_cmd}" -rf "${rollback_target}"

echo "Rollback default data"
# Without detail
"${tar_cmd}" -xzf "${backup_file_name}"

# With detail
#echo ""
#echo "Rollback file list:"
#"${tar_cmd}" -xvzf "${backup_file_name}"
#echo ""
echo "Rollback files finish"

echo "Clear backup file"
"${rm_cmd}" -f "${backup_file_name}"

echo "Rollback DB data from ${rollback_sql_path}"
read -p "Please enter MySQL user: " mysql_user
read -p "Please enter MySQL password: " -s mysql_pwd
echo ""
"${mysql_cmd}" -u"${mysql_user}" -p"${mysql_pwd}" --database "${rollback_target}"  < "${rollback_sql_path}"

echo "Finish"
