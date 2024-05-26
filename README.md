# Deploy Spring Boot Application using Github Actions on AWS EKS

## Application Setup

This application is a simple Java web application built using Spring Boot. It was generated using [start.spring.io](https://start.spring.io/).

The application has a single REST endpoint `/hello` which, when hit, returns a greeting message "<b>Hello, Spring Boot!</b>".

## CI

This application uses Github Actions for CI. It consists of a `Main Workflow` which in turn uses reusable workflows.  `Main Workflow` is triggered manually, and can be set to trigger on other events. Following are the jobs used:

| Job Name  | Description |
| ---  | --- |
| `terraform-checkov-scan`  | Scans the Terraform code for security and compliance issues. It is set to `soft-fail` - it won't crash the pipeline if vulnerabilities are found - a setting that can be changed need based. |
| `java-build-jar`  | Builds the Java application and creates a JAR file. It uploads the JAR artifact so it can be later downloaded by following job and used. |
| `docker-build-n-push`  | Builds a Docker image from the JAR file and pushes it to an ECR repository. This job depends on `java-build-jar`. The generated JAR file is downloaded and copied in the Docker image. IAM authN is used to interact with ECR. |
| `eks-deploy`  | Deploys the Docker image to an EKS cluster. Authentication to EKS is done via Tokens issued by OIDC Github IdP (instead of previously demonstrated IAM authN) to deploy resources to EKS. |

### Testing

- Trivy Scan is used to scan Docker images for vulnerabilities
- Checkov Scan is used to scan Terraform for vulnerabilities

Note: Vulnerabilities found were not addressed as a part of this project. 

### Prerequisites to run CI

- `DockerBuildnPush` job uses Github Actions Secrets to store credentials for authentication for pushing images to ECR. Following are the variables that must be added before triggering workflow:
    
    - `GH_ACTIONS_ACCESS_KEY`: AWS Access key
    - `GH_ACTIONS_SECRET_ACCESS_KEY`: AWS Secrets Access Key
    - `GH_ACTIONS_REGION`: AWS Region

    See: [Creating secrets for a repository](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-a-repository)

    ECR user `gh_actions_ecr_user` created via Terraform has `create_iam_access_key` flag set to `false`. This means that you will have to navigate to AWS IAM console to generate Access Key & Secret Access key.

    See: [Managing access keys (console)](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey)

- `TerraformCheckovScan` uses Github Personal Access Token. Following variable must be added before triggering workflow:

    - `GH_PAT`: Github Personal Access Token

    See: [Creating Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-fine-grained-personal-access-token)


## Infrastructure

Infrastructure is provisioned with Terraform. AWS s3 paired with DynamoDB table is used as backend to store state. Variables are defined in a separate `variables.tf` file, and `terraform.tfvars` is used to set values. This approach allows reusability for a multi-environment setup, by introducing `<env>.tfvars` files to set values respectively. Most of the resources are created using public modules. Naming is done with integer prefixes to demonstrate order of application for cluster provisioning.

## Authentication

Two modes for authN are demonstrated in this setup. 

1. IAM authentication is used with Assumable roles, with permission policies and trust-relationships, demonstrated for EKS/ECR access.
2. OIDC IdP token based authN, demonstrated for Github Actions access to cluster to apply resources.

### Improvement points

- Cluster Autoscaler could be setup for autoscaling, ensuring high-availability of cluster
- Security groups could be setup for improved security of cluster
- Taints on managed nodegroups with respective tolerations on workloads for need based scheduling on on-demand & spot instances
- Separate OIDC based role for Terraform
- Monitoring & Alerting

## Setup Verification

Application is deployed successfully and running in the cluster. A successful Github Actions run can be found [here](https://github.com/bilalbokharee/MySpringBootApp/actions/runs/9245506459).

To verify this setup, port-forward was done using k8s/service port, and the defined endpoint was hit to see the following output:

```bash
kubectl port-forward svc/my-spring-boot-app -n myspringbootapp 3000:80

curl localhost:3000/hello
Hello, Spring Boot!% 
```
