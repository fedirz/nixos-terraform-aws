provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project = var.project_name
    }
  }
}

resource "random_pet" "vhd_key" {
  length    = 3
  separator = "-"
}

resource "random_pet" "ami_name" {
  length    = 3
  separator = "-"
}
