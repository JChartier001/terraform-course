resource "random_id" "bucket_suffix" {
  byte_length = 4

}

resource "aws_s3_bucket" "this" {
  count = var.bucket_count

  bucket = "workspaces-demo-${terraform.workspace}-${random_id.bucket_suffix.hex}"
}
