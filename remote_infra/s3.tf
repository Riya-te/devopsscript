resource "aws_s3_bucket" "remote_bucket" {
  bucket = "my-remote-test-bucket-10"

  tags = {
    Name = "my-remote-test-bucket-10"
  }
}