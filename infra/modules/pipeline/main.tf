resource "aws_kms_key" "default" {
  description             = "KMS key for codepipeline encryption"
  deletion_window_in_days = 10
  tags                    = var.tags
}

resource "aws_s3_bucket" "default" {
  bucket = "${var.app_name}-bucket"
  tags   = var.tags
}

resource "aws_codebuild_project" "default" {

  name           = "${var.app_name}-codebuild"
  service_role   = aws_iam_role.codepipeline_role.arn
  encryption_key = aws_kms_key.default.arn
  tags           = var.tags

  artifacts {
    encryption_disabled    = false
    name                   = "${var.app_name}-artifact"
    override_artifact_name = false
    packaging              = "NONE"
    type                   = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "ECR_REPOSITORY_NAME"
      type  = "PLAINTEXT"
      value = var.ecr_repository_name
    }

    environment_variable {
      name  = "REPOSITORY_BRANCH"
      type  = "PLAINTEXT"
      value = var.branch_names[0]
    }

    environment_variable {
      name  = "ENVIRONMENT_NAME"
      type  = "PLAINTEXT"
      value = var.environment
    }

    environment_variable {
      name  = "EKS_KUBECTL_ROLE_ARN"
      type  = "PLAINTEXT"
      value = var.cluster_iam_role_arn
    }

    environment_variable {
      name  = "K8S_FILE_PATH"
      type  = "PLAINTEXT"
      value = var.k8s_file_path
    }   
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  source {
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
    buildspec           = var.build_spec
  }

  depends_on = [ aws_s3_bucket.default, aws_kms_key.default ]
}

resource "aws_codepipeline" "default" {

  name          = "${var.app_name}-codepipeline"
  pipeline_type = "V2"
  role_arn      = aws_iam_role.codepipeline_role.arn
  tags          = var.tags

  artifact_store {
    location = aws_s3_bucket.default.bucket
    type     = "S3"
    encryption_key {
      id   = aws_kms_key.default.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      category         = "Source"
      name             = "Source"
      namespace        = "SourceVariables"
      output_artifacts = ["SourceOutput"]
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      run_order        = 1
      version          = "1"

      configuration = {
        BranchName           = var.branch_name
        ConnectionArn        = var.aws_codestarconnection_arn
        FullRepositoryId     = "${var.github_org}/${var.repository_name}"
        OutputArtifactFormat = "CODE_ZIP"
        DetectChanges        = true
      }
    }
  }

  stage {
    name = "Build-Deploy"
    action {
      category = "Build"
      name     = "Build-Deploy"

      configuration = {
        ProjectName = "${aws_codebuild_project.default.name}"
      }

      input_artifacts  = ["SourceOutput"]
      output_artifacts = ["BuildOutput"]
      owner            = "AWS"
      provider         = "CodeBuild"
      run_order        = 2
      version          = "1"
    }
  }

  trigger {
    provider_type = "CodeStarSourceConnection"
    git_configuration {
      source_action_name = "Source"
      push {
        branches {
          includes = [var.branch_name]
        }
        file_paths {
          includes = var.file_paths
        }
      }
    }
  }
}
