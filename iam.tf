# IAM Role Required for VM Import
# https://docs.aws.amazon.com/vm-import/latest/userguide/required-permissions.html
# https://github.com/StratusGrid/terraform-aws-iam-role-vmimport/blob/main/iam-role-vmimport.tf  
resource "aws_iam_role" "vmimport" {
  name               = "vmimport"
  assume_role_policy = data.aws_iam_policy_document.vmimport-trust-policy.json
}

data "aws_iam_policy_document" "vmimport-trust-policy" {
  version = "2012-10-17"
  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type = "Service"
      identifiers = [
        "vmie.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_policy" "vmimport-policy" {
  name = "vmimport-policy-nixos-vm"
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Effect" = "Allow",
        "Action" = [
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject",
          "s3:GetBucketAcl"
        ],
        "Resource" = [
          "${aws_s3_bucket.this.arn}",
          "${aws_s3_bucket.this.arn}/*"
        ]
      },
      {
        "Effect" = "Allow",
        "Action" = [
          "ec2:ModifySnapshotAttribute",
          "ec2:CopySnapshot",
          "ec2:RegisterImage",
          "ec2:Describe*"
        ],
        "Resource" = "*"
      }
    ]
  })
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "vmimport_policy_attachment" {
  role       = aws_iam_role.vmimport.name
  policy_arn = aws_iam_policy.vmimport-policy.arn
}
