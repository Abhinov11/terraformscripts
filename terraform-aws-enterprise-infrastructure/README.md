# Terraform AWS Enterprise Infrastructure
# Terraform AWS Enterprise Infrastructure

## Overview

Production-style AWS infrastructure deployed using Terraform.

### Components

- VPC
- Public & Private Subnets
- NAT Gateway
- Security Groups
- Bastion Host
- Web Server
- Application Server
- Remote State Backend
- DynamoDB State Locking

## Architecture

Internet
↓
IGW
↓
Public Subnets
├── Bastion
├── Web Server
└── NAT Gateway

Private Subnets
└── App Server

## Modules

### VPC
Creates networking infrastructure.

### Security Groups
Implements least-privilege access.

### EC2
Deploys bastion, web and app servers.

### Bootstrap
Creates remote state backend.

## Security Controls

- IMDSv2 enforced
- Encrypted EBS volumes
- S3 encryption
- State locking
- Private subnet isolation

## Future Enhancements

- ALB
- Auto Scaling
- AWS Client VPN
- WAF
- CloudWatch Monitoring