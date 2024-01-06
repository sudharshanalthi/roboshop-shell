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

    dnf module disable nodejs -y &>> $LOGFILE

    VALIDATE $? "Disabling current NodeJS" 

    dnf module enable nodejs:18 -y &>> $LOGFILE

    VALIDATE $? "Enabling Nodejs:18" 

    dnf install nodejs -y &>> $LOGFILE

    VALIDATE $? "Installing Nodejs:18" 

    id roboshop
    if [ $? -ne 0 ]
    then
     useradd roboshop
     VALIDATE $? "roboshop user creation"
     else
         echo -e "roboshop user already exist $Y SKIPPING $N"
    fi

    mkdir -p /app

    VALIDATE $? "creating app directory" 

    curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE

    VALIDATE $? "Downloading user application" &>> $LOGFILE

    cd /app 

    unzip -o /tmp/user.zip &>> $LOGFILE

    VALIDATE $? "unzipping user" 

    npm install &>> $LOGFILE

    VALIDATE $? "Installing dependencies" 

    cp /home/centos/roboshop-shell/user.service /etc/systemd/system/user.service

    VALIDATE $? "copying user service file"

    systemctl daemon-reload &>> $LOGFILE

    VALIDATE $? "user demon reload" 

    systemctl enable user &>> $LOGFILE

    VALIDATE $? "Enable user"

    systemctl start user &>> $LOGFILE

    VALIDATE $? "starting user"

    cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

    VALIDATE $? "copying mongodb repo"

    dnf install mongodb-org-shell -y &>> $LOGFILE

    VALIDATE $? "Installing MongoDB client"

    mongo --host 172.31.47.139 </app/schema/user.js &>> $LOGFILE

    VALIDATE $? "Loading user data into MongoDB"

    


