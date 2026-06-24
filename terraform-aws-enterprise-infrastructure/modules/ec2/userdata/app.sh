#!/bin/bash

yum update -y

yum install java-17-amazon-corretto -y

echo "Application Server Ready" > /tmp/app-ready.txt