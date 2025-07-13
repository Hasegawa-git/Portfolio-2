# Portfolio-2

This repository contains a production-ready AWS infrastructure template using:

- Terraform (IaC)
- GitHub Actions (CI/CD)
- AWS (VPC, ECS, ALB, RDS, WAF, etc.)
- Dev/Prod environments separation
- Security design (IAM, WAF, SSM Session Manager)
- Monitoring (CloudWatch, SNS)

This portfolio demonstrates the skills necessary to deploy secure, scalable, and automated AWS infrastructure

## Architecture Diagram

```mermaid
graph TD
  Internet --> Route53 --> WAF --> ALB --> ECS --> RDS
