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

    curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip

    cd /app

    unzip /tmp/shipping.zip

    mvn clean package

    mv target/shipping-1.0.jar shipping.jar

    cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service

    systemctl daemon-reload

    systemctl enable shipping 

    systemctl start shipping

    dnf install mysql -y

    mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql 

    systemctl restart shipping