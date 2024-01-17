#!/bin/bash

AMI=ami-03265a0778a880afb
SG_ID=sg-00c327683078c0c60 
INSTANCES=("mongodb" "redis" "mysql" "rabbit" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "web")

for i in "${INSTANCES[@]}"
do
    echo "instance is: $i"
   if [ $i== "mongodb" ] || [ $i== "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE t2.micro  --security-group-ids sg-00c327683078c0c60

    done
    