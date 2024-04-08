# Infra resources
1. Start a new session with aws-cli (the aws iam account should have all the necessary permissions, specially with the s3 bucket used as backend):
   - Update ~/.aws/credentials and execute an aws sso login with the profile that will be used.
2. Commands:
- Main directory:
   - cd infra
- Terraform commands:
   ```
   export AWS_ACCESS_KEY_ID="ASIAxxxx"
   export AWS_SECRET_ACCESS_KEY="f7xxxxx"
   export AWS_SESSION_TOKEN="IQoJxxxxx"
   make init
   make validate
   make apply
   make upgrade
   ```
- Kubernetes commands:
   - kubeconfig:
   ```
   export AWS_ACCESS_KEY_ID="ASIAxxxx"
   export AWS_SECRET_ACCESS_KEY="f7xxxxx"
   export AWS_SESSION_TOKEN="IQoJxxxxx"
   aws eks --region your-region update-kubeconfig --name cluster-name
   ```
*Note: You can see logs inside the .tmp directory, if you want to clean this folder use: `make clean`*

Modules' docs:
- [EKS](./modules/eks/README.md)
- [VPC](./modules/vpc/README.md)
- [Pipeline](./modules/pipeline/README.md)
- [ECR](./modules/ecr/README.md)