用rsync

rsync -av --exclude=Webroot/storage/* --exclude=Webroot/htdocs/asset/* -e ssh xx@ip:/dir