#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

VALIDATE(){
   if [ $1 -ne 0 ]
   then
       echo -e "$2 ... $R FAILED $N"
       exit 1
   else
       echo -e "$2 ... $G SUCCESS $N"
       fi
}

if [ $ID -ne 0 ]
then
   echo -e "$R ERROR:: please run this script without root access $N"
   exit 1 # you can give other than 0
else
       echo "you are root user"
    fi # fi means reverse of if, indicating condition end

    dnf install nginx -y

    VALIDATE $? "Installing nginx"

    systemctl enable nginx

    VALIDATE $? "Enable nginx"

    systemctl start nginx

    VALIDATE $? "Starting Nginx"

    rm -rf /usr/share/nginx/html/*

    VALIDATE $? "removed default website"

    curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip

    VALIDATE $? "Downloading web application"

    cd /usr/share/nginx/html

    VALIDATE $? "moving nginx html directory"

    unzip -o /tmp/web.zip

    VALIDATE $? "unzipping web"

    cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf 

    VALIDATE $? "copied roboshop reverse proxy config"

    systemctl restart nginx 

    VALIDATE $? "restarted nginx"
    