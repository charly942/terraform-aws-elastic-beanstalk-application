locals {
  tags = { for t in keys(module.this.tags) : t => module.this.tags[t] if t != "Name" && t != "Namespace" }
}

resource "aws_elastic_beanstalk_application" "default" {
  name        = module.this.id
  description = var.description
  tags        = local.tags

  dynamic "appversion_lifecycle" {
    for_each = var.appversion_lifecycle_service_role_arn != "" ? ["true"] : []
    content {
      service_role          = var.appversion_lifecycle_service_role_arn
      max_count             = var.appversion_lifecycle_max_count
      delete_source_from_s3 = var.appversion_lifecycle_delete_source_from_s3
    }
  }
}

/* 
resource "aws_s3_bucket" "default" {
  bucket = var.bucket_name
}

resource "aws_s3_object" "default" {
  bucket = aws_s3_bucket.default.id
  key    = "beanstalk/provisiones.zip"
  source = "provisiones.zip"
  content_type = "application/zip"
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name        = "tf-test-version-label"
  application = var.application_name
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.default.id
  key         = aws_s3_object.default.id
} */
