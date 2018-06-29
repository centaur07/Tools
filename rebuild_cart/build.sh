#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
export PATH


code=${1}
web_root="/var/www/html"
cart_web_root="${web_root}/${code}"
backup_root="/root"
backup_anchor_name="${code}.tar.gz"
backup_anchor_path="${backup_root}/rebuild_cart/${backup_anchor_name}"
backup_sql_name="${code}.sql"
backup_sql_path="${cart_web_root}/$backup_sql_name"
mysql_user="root"

echo "Cart code: ${code}"


#echo "Check if directory exists"
#test ! -d "${cart_web_root}" && echo "${cart_web_root} not exists" && exit 0


echo "Cnange to ${web_root}"
cd "${web_root}"

echo  "Remove cart directory ${code}"
rm -rf "${code}"


echo "Copy backup anchor file from ${backup_anchor_path} to ${web_root}"
cp "${backup_anchor_path}" "${web_root}"


echo "Extract anchor file ${backup_anchor_name}"
tar -xvzf "${backup_anchor_name}"

echo "Remove anchor file ${backup_anchor_name}"
rm -f "${backup_anchor_name}"


echo "Import data from ${backup_sql_path}"
mysql -u"${mysql_user}" --database "${code}" < "${backup_sql_path}"
