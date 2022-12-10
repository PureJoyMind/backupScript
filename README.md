# Backup Scripts for MongoDB and Server Files
These scripts take a backup of a linux server files and the websites' mongo database and upload them to another server through SFTP. 

There are two bash script files. You need to run only one of them named `backup.sh`. This script:
1. Backups the Mongodb using `mongodump` command, then compress it using tar. The naming format is `db-<Date>.tar.gz`
2. Creates a `.tar.gz` compressed folder of the server files. The naming format is `srv-<Date>.tar.gz`
3. Call the `sftp.sh` script which handles the connection to the other server and uploads files.

### Paths in arguments
Always use absolute path in arguments to avoid complications.

# What To Do
Before anything you need to setup passwordless sftp `authorized_keys` between your servers so the script can connect to the other server and upload files.
[This](https://www.golinuxcloud.com/sftp-chroot-restrict-user-specific-directory/#Step_6_Setup_passwordless_sftp_authorized_keys) article explains that and is the one I used to learn the topic. 
Also the `sftp.sh` script was taken and modified from the same persons script on [this](https://www.golinuxcloud.com/automate-sftp-shell-script-with-password-unix/) page. 
## On Host server
### Creating directories
In the folder where you have the scripts, create two directories: 
1. A temp directory. This one will hold the unzipped folders which the script empties after execution.
2. A directory which the zipped files will be. `sftp.sh` will read the files from here, then the script wil empty this directory after execution.

### Script arguments
1. The name of the mongo database you want to take a backup of. Usually this is also the name of the server folder you want to backup aswell so I have used this as server folder name as well. For example:
    * The name of my server folder, which holds all the websites files, is mazdak because my website is either named mazdak or my client is mazdak. and the databse I use to keep this clients or the sites collection in is also named mazdak.

2. The directory to the temp folder.
3. The directory to the zipped files where `sftp.sh` will read and upload files from.
4. The username of the client server which we have setup passwordless sftp between host and it. 
5. The ip address of the host server.
6. The directory of the backups on the client server.

### Notes before using
***backup.sh***:
* On line 26 we use the `tar` command to compress server files. the directory is `/home/<serverName>`. If your folder is somewhere else change it.  

* I use this script on a node.js express project. The part of the script which compresses the server files on line 26, has an `--exclude` parameter which excludes the `node_modules` folder. It has project dependencies which should not be uploaded and are listed in a package,json file. This file reads the dependency names and installs them wherever it is called.
If you don't have it delete that tag.

***sftp.sh***:
* If the server you are uploading to is accessed only through a certain port uncomment line 51 and comment line 52, then set the `-oPort` argument to the port number. 

## On Client server
### Creating directories
Create a directory on the client server that is going to download the backup files that is named `<serverName>backup`. For example if on the host server I am backing up the mazdak folder, on the client server I create a directory named `mazdakbackup`.

## Using the script 
For example: 
* My client server is `srv@1.1.1.1`
* The name of the server folder and database is `mazdak`
* The temp directory is `/home/backupScripts/backupTmp`
* The directory for zip files is `/home/backupScripts/files`
* The directory of the backup files on the client is `/home/backupFiles`

Then the script should be run like this:
`./backup.sh mazdak /home/backupScripts/backupTmp /home/backupScripts/files srv 1.1.1.1 /home/backupFiles`

The script will create a directory with the name as the Date on the client server then move the backup files to it and delete the backup files on the host server. 

# Final Notes
You can use these scripts to backup your server and mongoDB. To automate this task you can use crontab. I know the command to run the script might look too long but do it once and put it in a cron job. 
The script should work fine. 
Feel free to contact me for any ideas on how to improve the scripts and if there were any porblems with the scripts.