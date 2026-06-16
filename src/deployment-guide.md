# Deployment Overview

This guide explains how this project moves from code in GitHub to cloud-ready container images in AWS and Azure.

The project uses GitHub Actions to run the deployment workflow. When code is pushed to the main branch, GitHub Actions can validate the application, build a Docker image, scan it for security issues, and publish the image to container registries in AWS and Azure.

The current deployment process focuses on preparing and publishing container images. It does not deploy the application to EKS, AKS, or any live Kubernetes cluster yet.

## Prerequisites

Before using the full deployment workflow, the following items should be ready:

- A GitHub repository for this project.
- An AWS account.
- An Azure subscription.
- Terraform installed locally or available in a trusted environment.
- Docker available in GitHub Actions, which is already included on GitHub-hosted runners.
- AWS OIDC access configured for GitHub Actions.
- Azure OIDC access configured for GitHub Actions.
- An Amazon ECR repository created by Terraform.
- An Azure ACR registry created by Terraform.
- Required GitHub repository variables added.

Required GitHub variables include:

- `AWS_GITHUB_ACTIONS_ROLE_ARN`
- `AWS_REGION`
- `AWS_ECR_REPOSITORY_URL`
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `AZURE_ACR_NAME`
- `AZURE_ACR_LOGIN_SERVER`

These values connect the GitHub Actions workflow to AWS and Azure without storing long-term cloud passwords.

## Infrastructure Deployment

Infrastructure means the cloud resources that support the application.

This project uses Terraform to define the AWS and Azure foundation. Terraform lets the infrastructure be described in files, so the same setup can be reviewed, repeated, and improved over time.

### AWS Infrastructure

The AWS Terraform configuration prepares:

- A network foundation.
- An Amazon ECR repository for Docker images.
- GitHub OIDC trust.
- An IAM role that GitHub Actions can use.
- Permissions for publishing images to ECR.

Amazon ECR is where AWS stores Docker images.

### Azure Infrastructure

The Azure Terraform configuration prepares:

- A resource group.
- A network foundation.
- An Azure Container Registry.
- Guidance for GitHub OIDC federated identity setup.

Azure ACR is where Azure stores Docker images.

### How Terraform Is Used

Terraform should be run from a safe local or administrative environment, not automatically from the current GitHub Actions workflow.

A typical Terraform process is:

1. Review the Terraform files.
2. Run `terraform init`.
3. Run `terraform plan`.
4. Review the plan carefully.
5. Run `terraform apply` only when ready.

This project does not automatically run `terraform apply` from GitHub Actions.

## Container Image Publishing

After the cloud registries and OIDC access are ready, GitHub Actions can publish Docker images.

When code is pushed to GitHub:

1. GitHub Actions starts the workflow.
2. The Python application is validated.
3. Docker builds an image of the application.
4. Trivy scans the image for known security issues.
5. GitHub Actions uses OIDC to request temporary cloud access.
6. The image is pushed to Amazon ECR.
7. The image is pushed to Azure ACR.

OIDC is a secure login method. In plain English, it lets GitHub prove to AWS and Azure that the workflow is coming from the approved repository. AWS and Azure then provide short-term access for that workflow run.

This avoids storing long-term cloud keys or passwords in GitHub.

### AWS ECR Publishing

For AWS, the workflow:

- Logs in using GitHub OIDC.
- Connects to Amazon ECR.
- Tags the Docker image with the Git commit ID.
- Pushes the image to ECR.

The AWS image uses a commit-based tag so each published image can be traced back to a specific version of the code.

### Azure ACR Publishing

For Azure, the workflow:

- Logs in using GitHub OIDC.
- Connects to Azure ACR.
- Tags the Docker image with the Git commit ID.
- Also tags the image as `latest`.
- Pushes both tags to ACR.

This makes the image available for future Azure deployment steps.

## Validation Steps

Before enabling or trusting the publishing workflow, check the following:

1. Confirm the GitHub Actions workflow runs successfully.
2. Confirm Python validation passes.
3. Confirm the Docker image builds successfully.
4. Confirm the Trivy security scan passes.
5. Confirm AWS OIDC role assumption succeeds.
6. Confirm Amazon ECR receives the image.
7. Confirm Azure OIDC login succeeds.
8. Confirm Azure ACR receives the image.
9. Confirm no Kubernetes deployment is triggered.

In GitHub Actions, a successful run should show completed steps for validation, Docker build, security scan, AWS ECR publishing, Azure ACR publishing, and artifact upload.

## Troubleshooting

### GitHub Actions does not start

Check that the workflow file exists under `.github/workflows/` and that the push was made to the `main` branch.

### AWS login fails

Check:

- `AWS_GITHUB_ACTIONS_ROLE_ARN` is correct.
- `AWS_REGION` is correct.
- The AWS OIDC provider exists.
- The AWS IAM role trusts the correct GitHub repository and branch.
- The role has permission to push to ECR.

### ECR push fails

Check:

- `AWS_ECR_REPOSITORY_URL` is correct.
- The ECR repository exists.
- The IAM role has ECR push permissions.
- The image tag does not conflict with an existing immutable tag.

### Azure login fails

Check:

- `AZURE_CLIENT_ID` is correct.
- `AZURE_TENANT_ID` is correct.
- `AZURE_SUBSCRIPTION_ID` is correct.
- The Azure federated identity credential trusts the correct GitHub repository and branch.

### ACR push fails

Check:

- `AZURE_ACR_NAME` is correct.
- `AZURE_ACR_LOGIN_SERVER` is correct.
- The Azure identity has the `AcrPush` role.
- The ACR registry exists and is reachable.

### Trivy scan fails

The workflow may stop if Trivy finds high or critical security issues. Review the scan artifact, update the image or dependencies, and run the workflow again.

## Summary

This deployment process uses GitHub Actions, Docker, Terraform, AWS, Azure, ECR, ACR, and OIDC to prepare container images for multi-cloud deployment.

The process is designed to be simple and repeatable:

1. Push code to GitHub.
2. Let GitHub Actions validate, build, and scan the application.
3. Use OIDC for secure temporary cloud access.
4. Publish the Docker image to AWS ECR and Azure ACR.

This gives the project a strong foundation for future deployment to AWS and Azure runtime services.
