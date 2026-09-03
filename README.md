# AWS 3-Tier DevSecOps Automation Project

This project creates a production-style AWS three-tier architecture using Terraform modules and deploys it through a Jenkins CI/CD pipeline.

## Planned Architecture

Internet → Public NLB → Web ASG → Internal NLB → App ASG → RDS MySQL

## Supporting Services

- AWS Backup
- CloudWatch
- SNS
- Jenkins
- Terraform remote state
- Cross-region RDS read replica

## Environment

- Primary region: ap-south-1
- DR region: us-east-1
- Environment: dev