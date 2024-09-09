# Bucket to store the VHD image
resource "aws_s3_bucket" "this" {}

resource "aws_s3_object" "vhd" {
  bucket = aws_s3_bucket.this.id
  key    = random_pet.vhd_key.id
  source = var.vhd_image_source
  etag   = filemd5(var.vhd_image_source)
}

resource "aws_ebs_snapshot_import" "nixos_snapshot" {
  disk_container {
    format = "VHD"
    user_bucket {
      s3_bucket = aws_s3_bucket.this.id
      s3_key    = aws_s3_object.vhd.key
    }
  }
  role_name = aws_iam_role.vmimport.name
}

resource "aws_ami" "nixos_ami" {
  name                = random_pet.ami_name.id
  virtualization_type = "hvm"
  root_device_name    = "/dev/sda1"
  ebs_block_device {
    device_name           = "/dev/sda1"
    snapshot_id           = aws_ebs_snapshot_import.nixos_snapshot.id
    volume_size           = 128
    delete_on_termination = true
  }
  ena_support = true # AFAIK instances AMI instances such as g5 won't be available without this
}

