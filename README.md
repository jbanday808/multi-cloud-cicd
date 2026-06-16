# Multi-Cloud CI/CD Pipeline

## Project Overview

This project automates the process of testing, building, scanning, and preparing an application for deployment across AWS and Azure.

It shows how a software team can use one repeatable process to move code from GitHub toward cloud deployment. Instead of manually checking code, building containers, and preparing cloud resources, the pipeline handles those steps automatically.

The goal is simple: make software delivery faster, safer, and more consistent across more than one cloud provider.

## Architecture Diagram

![Multi-Cloud CI/CD Pipeline](docs/images/multi-cloud-cicd-diagram.png)

Figure 1. Multi-Cloud CI/CD Pipeline architecture showing GitHub Actions, Docker, security scanning, OIDC authentication, and deployment preparation across AWS and Azure.

## Why This Project Matters

Organizations want to release software faster without lowering quality or security. Manual deployment steps can slow teams down and create mistakes, especially when applications need to run in more than one cloud.

This project demonstrates how automation can reduce manual effort, improve consistency, and support secure delivery across AWS and Azure. It is a practical example of how DevOps practices help teams move from code changes to cloud-ready applications with fewer repeated manual tasks.

## What I Built

I built a multi-cloud CI/CD pipeline that automates application validation, containerization, security scanning, and infrastructure provisioning across AWS and Azure.

## Real-World Use Case

A company may have customers, applications, or teams using both AWS and Azure. Without a shared process, the company may need separate deployment workflows for each cloud provider.

This project shows a simpler approach. One automated workflow can check the application, build it, scan it, and prepare it for deployment to both cloud environments. This helps teams avoid duplicated effort and keeps the release process more consistent.

## Diagram Explanation

The architecture diagram shows a multi-cloud CI/CD pipeline. It follows the path from a code change to a cloud-ready application.

- **Code Push:** A developer sends code to GitHub.
- **GitHub Actions:** GitHub automatically starts the workflow.
- **Test:** The code is checked automatically to catch basic issues early.
- **Build:** A Docker image is created. This packages the application so it can run consistently in different environments.
- **Scan:** The Docker image is checked for security issues before it is prepared for deployment.
- **AWS Deployment:** The image can be pushed to Amazon ECR and deployed to ECS or EKS.
- **Azure Deployment:** The image can be pushed to Azure ACR and deployed to AKS or App Service.
- **OIDC:** Secure temporary access is used instead of stored passwords or long-term access keys.

In simple terms, the diagram shows one workflow that can prepare the same application for both AWS and Azure. The project is designed to build once and deploy everywhere using one codebase.

## Architecture Diagram Walkthrough

1. Developer pushes code to GitHub.
2. GitHub Actions starts automatically.
3. Validation checks run to make sure the application is in a good state.
4. A Docker image is built so the application can run consistently.
5. A security scan is performed with Trivy to check the image for known issues.
6. The image is prepared for cloud deployment.
7. OIDC provides secure temporary authentication without storing long-term passwords or keys.
8. The application can be deployed to AWS and Azure.

## For Everyone

You write code once, push it to GitHub, and the system automatically checks it, packages it, scans it for security problems, and prepares it for deployment to AWS and Azure.

This helps teams avoid manual steps, reduce mistakes, and keep the delivery process consistent.

## Business Value

- **Secure:** No long-term secrets need to be stored in the pipeline.
- **Fast:** The process from code to deployment preparation is automated.
- **Multi-cloud:** The same application can work across AWS and Azure.
- **Reliable:** The same steps run every time, which makes releases more repeatable.
- **Cost-effective:** The project uses cloud services efficiently and keeps the deployment process organized.

## Key Skills Demonstrated

- GitHub Actions
- CI/CD Automation
- Docker
- Kubernetes
- Terraform
- AWS
- Azure
- Infrastructure as Code (IaC)
- Security Scanning (Trivy)
- Multi-Cloud Architecture
- DevOps Best Practices

## Resume Value

This project demonstrates skills that employers look for in cloud, DevOps, and platform engineering roles:

- Automation
- Cloud engineering
- Security
- Infrastructure management
- CI/CD pipelines
- Multi-cloud deployments

It shows the ability to connect application delivery, containerization, cloud infrastructure, and security scanning into one organized workflow.

## Current Status

The project currently includes:

- GitHub Actions CI workflow
- Python validation
- Docker build
- Trivy security scan
- Kubernetes manifests
- AWS Terraform foundation
- Azure Terraform foundation

## Future Roadmap

Planned next steps include:

- GitHub OIDC for AWS
- GitHub OIDC for Azure
- Push image to AWS ECR
- Push image to Azure ACR
- Deploy to EKS
- Deploy to AKS
