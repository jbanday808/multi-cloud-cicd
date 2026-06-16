# Project Challenges

This project was built to show how one application can be validated, packaged, scanned, and prepared for publishing across AWS and Azure.

The biggest challenge was not writing the small application itself. The bigger challenge was connecting several tools together in a clean and secure way:

- GitHub Actions for automation.
- Docker for packaging the application.
- Trivy for security scanning.
- Terraform for cloud infrastructure.
- AWS ECR for storing images in AWS.
- Azure ACR for storing images in Azure.
- OIDC for secure cloud authentication.

Each tool solved a different problem, but they had to work together as one pipeline.

## What Worked Well

The overall pipeline design worked well because each step had a clear purpose.

GitHub Actions handled the automation. Docker created a consistent application package. Trivy checked the image for known security problems. Terraform defined the cloud resources. AWS and Azure provided the container registries.

The project also showed the value of starting small. Instead of trying to deploy everything to Kubernetes immediately, the first goal was to build a reliable foundation:

1. Validate the application.
2. Build the Docker image.
3. Scan the image.
4. Prepare AWS and Azure infrastructure.
5. Publish the image to ECR and ACR.

This made the project easier to troubleshoot and improve step by step.

## Problems Encountered

### Terraform Authentication Issues

Terraform needs cloud access before it can create or update resources. This means AWS and Azure credentials must be configured correctly before Terraform can be used.

One important lesson was that infrastructure automation depends on identity and permissions. If the identity setup is wrong, Terraform cannot do its job, even if the Terraform files are written correctly.

The solution was to separate infrastructure setup from application deployment. Terraform is used to define cloud resources, but the GitHub Actions workflow does not automatically run `terraform apply`. This keeps infrastructure changes controlled and easier to review.

### AWS IAM and OIDC Setup

AWS access required two important pieces:

- An OIDC provider that trusts GitHub.
- An IAM role that GitHub Actions can assume.

IAM can be difficult because the permissions need to be specific. Too many permissions create risk, but too few permissions cause the workflow to fail.

The solution was to create a GitHub Actions role with limited permissions for the current goal: publishing Docker images to Amazon ECR. The role does not include EKS deployment permissions yet because Kubernetes deployment is not part of the current workflow.

### Azure App Registration and OIDC Setup

Azure also requires a trusted identity before GitHub Actions can publish images to Azure ACR.

The main challenge was understanding that Azure needs a federated credential. In plain English, this tells Azure which GitHub repository and branch are allowed to request temporary access.

The project includes Azure OIDC setup guidance and placeholders. The next step is to connect those placeholders to a real Azure App Registration or managed identity and grant it the `AcrPush` role.

### GitHub Actions Workflow Troubleshooting

GitHub Actions required careful testing because small workflow details can cause steps to skip or fail.

One issue was the condition used for publishing steps. The workflow originally checked both the event type and a repository variable. When the publishing steps were skipped, the condition was simplified so publishing runs on push events.

This showed an important lesson: automation should be easy to reason about. If a condition is too complex, it can make troubleshooting harder.

### Trivy Security Scanning

Trivy was added to check the Docker image for known security issues.

The key lesson was that security scanning should happen before publishing. If the image has serious issues, the workflow should stop before sending that image to a container registry.

This makes security part of the normal delivery process instead of something that happens later.

### ECR Image Publishing

Publishing to Amazon ECR required the workflow to:

1. Authenticate to AWS using OIDC.
2. Log in to ECR.
3. Tag the Docker image with the ECR repository URL.
4. Push the image.

One important detail was image tag immutability. The ECR repository was configured to use immutable tags, which means the same tag cannot be overwritten. Because of that, the workflow pushes a commit-based image tag to ECR instead of relying on `latest`.

This makes ECR publishing more traceable and safer.

### ACR Image Publishing

Publishing to Azure ACR required the workflow to:

1. Authenticate to Azure using OIDC.
2. Log in to ACR.
3. Tag the Docker image with the ACR login server.
4. Push the image.

Azure ACR publishing also depends on correct Azure identity setup. The Azure identity needs permission to push images to the registry. The required role is `AcrPush`.

This reinforced the importance of matching workflow steps with the correct cloud permissions.

## Solutions Implemented

Several improvements were added during the project:

- Added GitHub Actions automation for validation, Docker build, Trivy scanning, and registry publishing.
- Added Docker image publishing steps for AWS ECR and Azure ACR.
- Added AWS OIDC provider and IAM role configuration.
- Added AWS ECR publish permissions for the GitHub Actions role.
- Added Azure OIDC placeholders and setup documentation.
- Added Terraform outputs needed for GitHub repository variables.
- Added documentation for deployment, architecture, OIDC setup, and registry publishing.
- Updated workflow conditions so publishing steps run during push events.

These changes made the project easier to understand, easier to test, and closer to a real-world multi-cloud delivery process.

## Skills Gained

This project helped build practical experience in:

- GitHub Actions workflow design.
- Docker image building and tagging.
- Trivy container image scanning.
- Terraform-based cloud infrastructure.
- AWS IAM and OIDC authentication.
- Amazon ECR image publishing.
- Azure identity and federated credentials.
- Azure ACR image publishing.
- Multi-cloud project organization.
- Troubleshooting automation failures.
- Writing clear documentation for technical and non-technical audiences.

## Key Takeaways

The biggest takeaway is that automation is only useful when it is secure, repeatable, and easy to understand.

This project showed that a multi-cloud pipeline can be built step by step. The best approach was to solve one layer at a time:

1. Make the application build correctly.
2. Package it with Docker.
3. Scan it for security issues.
4. Prepare cloud infrastructure with Terraform.
5. Set up secure cloud access with OIDC.
6. Publish the image to AWS and Azure registries.

Another important lesson was that permissions matter. AWS IAM roles and Azure identities need to be limited to the task they are performing. For this project, the focus was container publishing, so the permissions were kept focused on ECR and ACR.

For recruiters and hiring managers, this project demonstrates more than tool usage. It shows problem solving, troubleshooting, cloud security awareness, documentation, and the ability to connect multiple systems into one working delivery process.
