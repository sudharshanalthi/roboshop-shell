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

    dnf module disable mysql -y &>> $LOGFILE

    VALIDATE $? "Disable current MySQL version" 

    cp mysql.repo /etc/yum.repos.d/mysql.repo

    VALIDATE $? "copied MySQL repo" 

    dnf install mysql-community-server -y

    VALIDATE $? "Installing Mysql Server" 

    systemctl enable mysqld

    VALIDATE $? "Enabling Mysql Server" 

    systemctl start mysqld

    VALIDATE $? "Starting Mysql Server" 

    mysql_secure_installation --set-root-pass RoboShop@1

    VALIDATE $? "Starting Mysql root password" 







    