# Drupal
# ======
#
# This is a placeholder: it starts an EC2 with a "hello world" index.html in Apache
# HTTPD.
#
# The real one will use an ECS with the Apache+Drupal image built via GitHub Actions.

# Create an IAM role for the EC2 instance (for demo purposes? or to
# prove we can do it?)
resource "aws_iam_role" "ec2_role" {
  name               = "apache-server-role"
  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Attach a simple policy to the role (CloudWatch read example, optional)
resource "aws_iam_role_policy_attachment" "cloudwatch_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
}

# Create an instance profile to associate the IAM role with the EC2 instance
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "apache-server-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# Security group allowing HTTP (and optional SSH)
resource "aws_security_group" "apache_sg" {
  name        = "apache_sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # If SSH is allowed
  dynamic "ingress" {
    for_each = var.allow_ssh ? [1] : []
    content {
      description = "SSH from anywhere (not recommended for production)"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Simple user data to install Apache and create an index.html
locals {
  user_data = <<-EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl enable httpd
systemctl start httpd
echo "<html><h1>Hey world, 👋 🌎</h1></html>" > /var/www/html/index.html
EOF
}

# Launch EC2 instance
resource "aws_instance" "apache_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.drupal_instance_type
  key_name      = var.key_name
  user_data     = local.user_data

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  # Just pick the first subnet for simplicity
  subnet_id = data.aws_subnets.default.ids[0]

  vpc_security_group_ids = [aws_security_group.apache_sg.id]

  tags = {
    Name = "ApacheServer"
  }
}

# Data source for the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
