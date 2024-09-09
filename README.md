### See anything that can improved? Please consider creating a pull request. Thanks!

# Overview

This repository showcases of how to use `nix` to build a VM image (with NVIDIA GPU support) for AWS deploy everything using `terraform`. The example in this repository

- [nixos-generators](https://github.com/nix-community/nixos-generators) is used to generate a VM image for AWS.
- NVIDIA configuration lives `./nvidia.nix`
- AWS resources required to make this work

  - S3 bucket for storing the VM image
  - IAM role for the VM to access the S3 bucket
  - EBS snapshot for the VM image
  - AMI for the VM image
  - Security group for the VM
  - EC2 instance for the VM

# Quick Start

## Building a VM from `flake.nix`

```bash
nix build .#amazon --print-out-path
# Output: /nix/store/h28zy1gnyl6jmwghza1z349x0mh73w57-nixos-amazon-image-24.11.20240906.574d1ea-x86_64-linux
ls /nix/store/h28zy1gnyl6jmwghza1z349x0mh73w57-nixos-amazon-image-24.11.20240906.574d1ea-x86_64-linux
# Output: nix-support  nixos-amazon-image-24.11.20240906.574d1ea-x86_64-linux.vhd

# Modify the `vhd_image_source` in ./variables.tf variable with the path. In my case it's `/nix/store/h28zy1gnyl6jmwghza1z349x0mh73w57-nixos-amazon-image-24.11.20240906.574d1ea-x86_64-linux/nixos-amazon-image-24.11.20240906.574d1ea-x86_64-linux.vhd`
```

## Creating AWS resources

NOTE: modify the necessary variables in `variables.tf` before running the following commands.

```bash
terraform apply -auto-approve
# This will take a while ~10 minutes. Most of the time is spent uploading the VHD to S3 and creating the AMI.
# To destroy the resources run: `terraform destroy -auto-approve
```

# Contributing

Some things that this repository could use help with:

- Better documentation
- Improved terraform structure
- Home-manger for user configuration
