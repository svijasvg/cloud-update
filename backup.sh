#!/bin/bash
# backup.sh

#   source /opt/venv/djangoEnv/bin/activate

#———————————————————————————————————————— do first

#  first update /home/sitelist.txt

#  run from /home/, leave in /version-update folder

#  to get currently installed version:
#  vi [site]/static/admin/css/admin-extra.css
#  vi /var/www/Env/djangoEnv/lib/python3.6/site-packages/svija/templates/admin/base_site.html

printf "\n    Backup functionality has been"
printf "\n    moved to the site-mgmt repository\n\n"

#   #———————————————————————————————————————— version number
#   
#   version="2.2.25" # OLD VERSION TO BE REPLACED
#   
#   #———————————————————————————————————————— version number
#   
#   cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#   printf "\n   changed directory"
#   
#   backupdir="db-backups-$version"
#   mkdir "../$backupdir"
#   printf "\n   $backupdir created\n"
#   
#   while IFS= read -r line; do
#   
#     cd ../$line
#     ./manage.py dumpdata --indent 2 > "../$backupdir/$line-$version.json"
#     printf "\n   /$line saved"
#   
#   done < ../sitelist.txt
#   
#   #———————————————————————————————————————— clean up
#   
#   cd /home
#   printf "\n\n   data export finished\n\n"
#   
#   #———————————————————————————————————————— fin
