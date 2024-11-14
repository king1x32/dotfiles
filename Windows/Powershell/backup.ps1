$DATE = Get-Date -Format "yyyy.MM.dd-HH.mm"
$INSTALL_SQLITE = "apt-get update && apt-get install sqlite3 -y"
$BACKUP_DB = "sqlite3 /data/db.sqlite3 '.backup /data/db.bak'"
$CREATE_ARCHIVE = "tar -czf $DATE.tar.gz data"
fly ssh console -a kingsmanvn -q -C "bash -c ""$INSTALL_SQLITE && $BACKUP_DB && $CREATE_ARCHIVE"" "

fly sftp get "$DATE.tar.gz"
