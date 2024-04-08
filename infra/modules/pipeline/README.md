# Pipeline module

This module contains the necessary AWS CodeBuild and AWS Codepipeline resources configuration for CI/CD. Integrations with GitHub repositories through AWS CodeStar for source code, AWS S3 bucket for artifacts management and AWS KMS keys for encryption/decryption.

For trigger actions path filters to each app folder in a monorepo are considered after a git push and deployments are done via kubernetes manifests in the app code, each deployment generates a new Docker image version which is used to create a new deployment ReplicaSet.