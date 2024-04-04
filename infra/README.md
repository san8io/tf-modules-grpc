# setup
1. Start a new session with aws-cli (the aws iam account should have all the necessary permissions, specially with the s3 bucket used as backend):
   - Update ~/.aws/credentials and execute an aws sso login with the profile that will be used.
2. Commands:
- Main directory:
   - cd platform
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
   aws --profile your-profile-name eks --region your-region update-kubeconfig --name cluster-name
   ```
*Note: You can see logs inside the .tmp directory, if you want to clean this folder use: `make clean`*
