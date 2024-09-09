resource "aws_security_group" "this" {
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.ingress_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  ami             = aws_ami.nixos_ami.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.this.name]
  tags = {
    Name = var.instance_name
  }
}
