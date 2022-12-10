#!/bin/bash

# Storing input
DB="$1"
SRV=$DB
tmpDir="$2"
mvDir="$3"
upUser="$4"
upIp="$5"
downDir="$6"

echo "Mongo backup in progress..."

# Backing up mongo database:
# 1. Creating mongo backup folder in  a tmp directory
mongodump --db $DB --out ${tmpDir}/`date +"db-%m-%d-%y"`

# 2. Zipping the mongo directory into the backup folder and deleting the tmp directory
tar -cvzpf ${mvDir}/`date +"db-%m-%d-%y.tar.gz"` ${tmpDir}/`date +"db-%m-%d-%y"`

rm -rf ${tmpDir}/`date +"db-%m-%d-%y"`

echo "Mongo backup done."

echo "Server files backup in progress..."

# Backing up server files

tar -cvzpf ${mvDir}/`date +"srv-%m-%d-%y.tar.gz"` --exclude="node_modules"  /home/$SRV

echo "Server files backup done."

# Transfering files to the other server 
echo "Transfering files to the other server..."
source sftpTest.sh ${upUser} ${upIp} ${mvDir} ${downDir} $SRV


echo "Removing backup files on client server..."
rm -rf ${mvDir}
mkdir ${mvDir}
echo "Backup files removal done."

exit 0
~                      
