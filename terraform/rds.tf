# Security group for RDS that only allows access from the Apache SG
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow MySQL inbound traffic only from the Apache HTTPD server"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "MySQL access from Apache SG only"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.apache_sg.id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Subnet Group to specify which subnets RDS can use
resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "rds-db-subnet-group"
  description = "Subnet group for RDS MySQL"
  # Using all default VPC subnets. Ideally, choose private subnets only.
  subnet_ids = data.aws_subnets.default.ids
}

# RDS MySQL instance
resource "aws_db_instance" "mysql_db" {
  count               = var.enable_rds ? 1 : 0
  allocated_storage   = 20
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro" # or use a variable for instance class
  db_name             = "drupal"      # initial database name
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true

  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible = false
  multi_az            = false
  storage_type        = "gp2"
  deletion_protection = false

  # Backup retention? Performance optimizations?
}
