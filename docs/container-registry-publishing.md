# Container Registry Publishing Setup

This project can publish the same Docker image to both AWS ECR and Azure ACR from GitHub Actions.

Publishing is disabled by default. It only runs on `push` events when this GitHub repository variable is set:

```text
ENABLE_CONTAINER_REGISTRY_PUBLISH=true
```

Pull requests still run validation, Docker build, Trivy scanning, and artifact upload, but they do not push images to cloud registries.

## What the Workflow Does

1. Checks out the repository.
2. Installs Python dependencies.
3. Runs Python validation.
4. Builds the Docker image.
5. Scans the image with Trivy.
6. Uses GitHub OIDC to authenticate to AWS.
7. Pushes the image to Amazon ECR.
8. Uses GitHub OIDC to authenticate to Azure.
9. Pushes the image to Azure ACR.

The workflow does not deploy to EKS, AKS, ECS, App Service, or Kubernetes.

## Image Tags

The workflow pushes registry tags as follows:

- AWS ECR: `${GITHUB_SHA}` only, because the ECR repository uses immutable image tags.
- Azure ACR: `${GITHUB_SHA}` and `latest`.

## Required GitHub Variables

Add these as GitHub repository variables:

- `ENABLE_CONTAINER_REGISTRY_PUBLISH`: set to `true` to enable registry publishing on pushes.
- `AWS_GITHUB_ACTIONS_ROLE_ARN`: IAM role ARN that GitHub Actions assumes with OIDC.
- `AWS_REGION`: AWS region for ECR, such as `us-east-1`.
- `AWS_ECR_REPOSITORY_URL`: ECR repository URL, from the Terraform `ecr_repository_url` output.
- `AZURE_CLIENT_ID`: Azure application or managed identity client ID.
- `AZURE_TENANT_ID`: Azure tenant ID.
- `AZURE_SUBSCRIPTION_ID`: Azure subscription ID.
- `AZURE_ACR_NAME`: Azure Container Registry name, from the Terraform `acr_name` output.
- `AZURE_ACR_LOGIN_SERVER`: Azure Container Registry login server, from the Terraform `acr_login_server` output.

## Required AWS Configuration

AWS must trust GitHub Actions through OIDC before the workflow can push images.

The AWS Terraform configuration includes:

- GitHub OIDC provider.
- GitHub Actions IAM role.
- ECR repository.
- ECR push permissions attached to the GitHub Actions role.
- Outputs for the role ARN and ECR repository URL.

Before using the workflow:

1. Replace the placeholder GitHub OIDC subject in `github_oidc_subject_claims`.
2. Use the real GitHub repository subject, for example:

```hcl
github_oidc_subject_claims = [
  "repo:OWNER/REPO:ref:refs/heads/main"
]
```

3. Apply the AWS Terraform outside this workflow when ready.
4. Add the Terraform outputs to GitHub repository variables.

The AWS role is scoped to publish images to the project ECR repository. It does not grant EKS deployment permissions.

## Required Azure Configuration

Azure must trust GitHub Actions through a federated identity credential before the workflow can push images.

Before using the workflow:

1. Create or choose an Azure AD application or user-assigned managed identity.
2. Add a federated identity credential with:
   - Issuer: `https://token.actions.githubusercontent.com`
   - Subject: `repo:OWNER/REPO:ref:refs/heads/main`
   - Audience: `api://AzureADTokenExchange`
3. Grant that identity the `AcrPush` role on the Azure Container Registry.
4. Add the identity and registry values to GitHub repository variables.

The Azure Terraform file `terraform/azure/oidc.tf` contains placeholders showing the expected federated credential shape. It does not create the Azure identity yet.

The Azure identity only needs ACR push access for this workflow. It does not need AKS deployment permissions.

## Safety Controls

- Registry publishing is disabled unless `ENABLE_CONTAINER_REGISTRY_PUBLISH=true`.
- Publishing only runs on `push` events, not pull requests.
- Cloud authentication uses OIDC short-lived tokens instead of stored cloud passwords.
- The workflow stops before pushing if validation, Docker build, or Trivy scanning fails.
