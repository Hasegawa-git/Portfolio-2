# Portfolio-2

This repository contains a production-ready AWS infrastructure template using:

- Terraform (IaC)
- GitHub Actions (CI/CD)
- AWS (VPC, ECS, ALB, RDS, WAF, etc.)
- Dev/Prod environments separation
- Security design (IAM, WAF, SSM Session Manager)
- Monitoring (CloudWatch, SNS)

This portfolio demonstrates the skills necessary to deploy secure, scalable, and automated AWS infrastructure — equivalent to a 700,000 JPY/month contract engineer level.

## Architecture Diagram

```mermaid
graph TD
  Internet --> Route53 --> WAF --> ALB --> ECS --> RDS
