#!/bin/bash


# mysql -u ${username} -p['${password}'] -h${host} -P3306 <<EOF
# CREATE DATABASE myDatabaseName;
# CREATE USER 'myUsername'@'${host}' IDENTIFIED BY 'myPassword';
# GRANT ALL PRIVILEGES ON myDatabaseName.* TO 'myUsername'@'${host}';
# FLUSH PRIVILEGES;
# EOF


cat <<EOF > /tmp/webapp/.env
USER_NAME=${username}
PASSWORD=${password}
DATABASE=${database}
HOST=${host}
PORT=${port}
EOF

sudo systemctl daemon-reload
sudo systemctl enable webapp_start.service
sudo systemctl start webapp_start.service
