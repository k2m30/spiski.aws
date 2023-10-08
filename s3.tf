#resource "aws_s3_bucket" "spiski_bucket" {
#  bucket = "spiski-bucket"
#  force_destroy = true
#}

resource "aws_iam_role" "spiski_role" {
  name = "spiski_role"

  assume_role_policy = jsonencode({
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
#      {
#        Sid : "AllowAccessToSpiskiBucket",
#        Action   = "s3:*",
#        Effect   = "Allow",
#        Resource = [
#          aws_s3_bucket.spiski_bucket.arn,
#          "${aws_s3_bucket.spiski_bucket.arn}/*",
#        ]
#      }

    ]
  })
}

#resource "aws_iam_policy_attachment" "s3_access" {
#  name       = "s3_access_attachment"
#  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
#  roles      = [aws_iam_role.spiski_role.name]
#}

#resource "aws_s3_bucket_policy" "spiski_bucket_policy" {
#  bucket = aws_s3_bucket.spiski_bucket.id
#  policy = jsonencode({
#    Version   = "2012-10-17",
#    Statement = [
#      {
#        Sid : "AllowAccessToSpiskiBucket",
#        Action   = "s3:*",
#        Effect   = "Allow",
#        Resource = [
#          aws_s3_bucket.spiski_bucket.arn,
#          "${aws_s3_bucket.spiski_bucket.arn}/*",
#        ]
#        Principal = {
#          Service = "lambda.amazonaws.com"
#        }
#      }
#    ]
#  })
#}
