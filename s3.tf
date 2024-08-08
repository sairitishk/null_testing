resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-null"

  tags = {
    Name        = "My bucket"
  }
}


