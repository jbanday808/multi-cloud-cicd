# GitHub OIDC Setup Guide

This project uses GitHub OIDC to prepare for secure cloud authentication without storing long-term AWS or Azure keys in GitHub.

OIDC lets GitHub Actions request short-lived cloud credentials during a workflow run. The cloud provider checks that the request came from the approved GitHub repository and branch before issuing temporary access.

No deployment is enabled yet. These steps prepare the authentication foundation only.

## GitHub Repository Settings

Add these repository variables before enabling cloud login steps:

- `ENABLE_CONTAINER_REGISTRY_PUBLISH`: set to `true` only after AWS and Azure cloud-side setup is complete.
- `AWS_GITHUB_ACTIONS_ROLE_ARN`: AWS IAM role ARN output by Terraform.
- `AWS_REGION`: AWS region, such as `us-east-1`.
- `AWS_ECR_REPOSITORY_URL`: AWS ECR repository URL output by Terraform.
- `AZURE_CLIENT_ID`: Azure application or managed identity client ID.
- `AZURE_TENANT_ID`: Azure tenant ID.
- `AZURE_SUBSCRIPTION_ID`: Azure subscription ID.
- `AZURE_ACR_NAME`: Azure Container Registry name output by Terraform.
- `AZURE_ACR_LOGIN_SERVER`: Azure Container Registry login server output by Terraform.

The workflow already includes `id-token: write`, which allows GitHub Actions to request an OIDC token. This does not grant cloud access by itself; AWS and Azure must be configured to trust the repository.

## AWS Setup

The AWS Terraform configuration creates:

- A GitHub Actions OIDC provider for `https://token.actions.githubusercontent.com`.
- An IAM role that GitHub Actions can assume with OIDC.
- Outputs for the OIDC provider ARN and GitHub Actions role ARN.

Before applying the AWS Terraform:

1. Update `github_oidc_subject_claims` in `terraform/aws/variables.tf` or a `.tfvars` file.
2. Replace the placeholder with the real repository subject.

Example:

```hcl
github_oidc_subject_claims = [
  "repo:OWNER/REPO:ref:refs/heads/main"
]
```

For this repository, replace `OWNER/REPO` with the actual GitHub owner and repository name.

The AWS role includes least-privilege permissions for publishing images to the project ECR repository. It does not include EKS deployment permissions.

## Azure Setup

The Azure Terraform configuration includes placeholder comments for federated credentials in `terraform/azure/oidc.tf`.

Before enabling Azure login:

1. Decide whether GitHub Actions should use an Azure AD application or a user-assigned managed identity.
2. Create the identity.
3. Add a federated identity credential with:
   - Issuer: `https://token.actions.githubusercontent.com`
   - Subject: `repo:OWNER/REPO:ref:refs/heads/main`
   - Audience: `api://AzureADTokenExchange`
4. Grant the identity only the Azure roles it needs, such as `AcrPush` for container registry publishing.
5. Add the identity details to GitHub repository variables.

## Workflow Behavior

The GitHub Actions workflow contains AWS and Azure OIDC login placeholders.

These steps only run when:

```text
ENABLE_CONTAINER_REGISTRY_PUBLISH=true
```

Until then, the workflow continues to validate Python, build the Docker image, scan it with Trivy, and upload scan results without logging in to either cloud or pushing images.

## References

- GitHub OIDC with AWS: https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws
- AWS credentials action: https://github.com/aws-actions/configure-aws-credentials
- Azure OIDC with GitHub Actions: https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure-openid-connect
