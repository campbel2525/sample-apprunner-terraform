# Terraform for Deploying Next.js on AWS App Runner

This document contains the Terraform code for deploying a Next.js application on AWS App Runner.

# Infrastructure Diagram

# Environment Setup

1. Set up SSO in AWS.
2. Create an S3 bucket in AWS to store the Terraform state file.
3. Create `credentials/aws/config` based on `credentials/aws/config.example`.
4. Run `make init`.

# How to Apply (Staging Environment Example)

1. Create `src/project/backend-config.env-kind.hcl` based on `src/project/backend-config.env-kind.hcl.example`.
   - Specify the S3 bucket you created in step 2 of the "Environment Setup" for the `bucket` attribute.
2. Create `src/project/terraform.env-kind.tfvars` based on `src/project/terraform.env-kind.tfvars.example`.
3. Run `make shell`.
   The following steps are performed inside the Docker container.
4. `cd /project/project`
5. Log in with SSO.
   `sl`
6. `make stg-apply`
   To delete the resources: `make stg-destroy`
7. Access the domain output in the console. If the web page is displayed, the deployment is successful.
   - This web page is launched from the [sample image](https://www.google.com/search?q=public.ecr.aws/aws-containers/hello-app-runner).

# Commands

## Command to get the GitHub OIDC provider fingerprint.

When setting this as an environment variable, be sure to convert uppercase letters to lowercase.

```
openssl s_client -connect token.actions.githubusercontent.com:443 -showcerts \
 </dev/null 2>/dev/null \
 | openssl x509 -noout -fingerprint -sha1 \
 | sed 's/://g' | sed 's/SHA1 Fingerprint=//'

```

# Tips

## 1

When you apply an App Runner service, a deployment is always triggered. It is impossible to prevent this initial deployment.

Therefore, the infrastructure construction follows this sequence:

1. **Create the ECR repository.**
   (e.g.) `terraform apply -auto-approve -target=module.user_front_apprunner.aws_ecr_repository.app -var-file=../terraform.stg.tfvars`
   The specific logic for pushing the image is described in `push_initial_image.sh`.
2. **Push a sample image from AWS to the new repository.**
   (e.g.) `./push_initial_image.sh aws-stg ap-northeast-1 user-front-repo`
3. **Apply the App Runner service configuration.**
   (e.g.) `terraform apply -auto-approve -var-file=../terraform.stg.tfvars`

Please refer to the `stg-apply` target in `src/project/Makefile` for details.
