resource "aws_s3_bucket" "ipv4_bucket" {
  bucket = "${var.env_name}-${var.app_name}-bucket"

  tags = {
    Name        = "${var.env_name}-${var.app_name}-bucket"
    Environment = var.env_name
    Application = var.app_name
  }
}

resource "aws_s3_bucket_website_configuration" "ipv4_web" {
  bucket = aws_s3_bucket.ipv4_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.ipv4_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "ipv4_policy" {
  bucket = aws_s3_bucket.ipv4_bucket.id
  policy = data.aws_iam_policy_document.ipv4_s3_policy.json
  depends_on = [aws_s3_bucket_public_access_block.example]
}

data "aws_iam_policy_document" "ipv4_s3_policy" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.ipv4_bucket.arn}/*",
    ]

    condition {
      test     = "DateLessThan"
      variable = "aws:CurrentTime"

      values = [ "2024-12-10T13:43-52Z" ]
    }
  }
}
