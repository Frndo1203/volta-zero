# HCL - Hashicorp Configuration Language
# Linguagem declarativa 

provider "aws" {
  region = var.base_region
}

resource "aws_s3_bucket" "datalake" {
  # Resource configuration parameters
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
  bucket = "${var.base_bucket_name}-${var.ambiente}-${var.numero_conta}"

  tags = {
    IES   = "IGTI"
    CURSO = "EDC"
  }

}

resource "aws_s3_bucket_acl" "datalake_acl" {
  bucket = aws_s3_bucket.datalake.bucket
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "datalake_side_encryption" {
  bucket = aws_s3_bucket.datalake.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "spark_code" {
  bucket = aws_s3_bucket.datalake.id
  key    = "emr/pyspark/job_spark_from_tf.py"
  acl    = "private"

  source = "../jobs_emr.py"
  etag   = filemd5("../jobs_emr.py")

}


