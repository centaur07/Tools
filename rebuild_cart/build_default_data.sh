#!/bin/bash

mysqldump_cmd="/usr/bin/mysqldump"
tar_cmd="/bin/tar"
mkdir_cmd="/bin/mkdir"
mv_cmd="/bin/mv"
default_web_root="/var/www/html"
use_default_prompt="(Press enter to use default)"
backup_file_root="/home/root/rebuild_cart/file"

read -p "Please enter web root ${use_default_prompt}: " web_root
if [ -z "${web_root}" ]; then
    web_root="${default_web_root}"
fi

read -p "Please enter backup target name: " backup_target
target_path="${web_root}/${backup_target}"
target_tar_name="${backup_target}.tar.gz"

echo "Check if ${target_path} directory exists"
if [ -d " ${target_path}" ]; then
    echo "Target do not exist, stop script!"
    exit 0
fi

read -p "Please enter MySQL user: " mysql_user

read -p "Please enter MySQL password: " -s mysql_pwd
echo ""

echo "Dump database ${backup_target} to ${target_path}/${backup_target}.sql"
cd "${target_path}"
"${mysqldump_cmd}" -u"${mysql_user}" -p"${mysql_pwd}" --databases "${backup_target}" > "${backup_target}.sql"

echo "Create backup file ${target_tar_name}"
cd ..

# Without detail
"${tar_cmd}" -czf "${target_tar_name}" "${backup_target}"
echo "${target_tar_name} created"

# With detail
#echo ""
#echo "Tar file list:"
#"${tar_cmd}" -cvzf "${target_tar_name}" "${backup_target}"
#echo ""
#echo "${target_tar_name} created"
#echo ""

echo "Move ${target_tar_name} to ${backup_file_root}/"
"${mkdir_cmd}" -p "${backup_file_root}"
"${mv_cmd}" -f "${target_tar_name}" "${backup_file_root}/"

echo "Finish"
