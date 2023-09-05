

provider "aws" {
  region = "eu-central-1"
  
}

resource "aws_default_vpc" "default" {}

resource "aws_instance" "my_server_web" {
  //count = 2
  ami                    = "ami-0bd39c806c2335b95"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.general.id]
  tags                   = { Name = "SRV-Web" }

  depends_on = [
    aws_instance.my_server_db,
    aws_instance.my_server_app
  ]
}

resource "aws_instance" "my_server_app" {
  ami                    = "ami-0bd39c806c2335b95"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.general.id]
  tags                   = { Name = "SRV-App" }

  depends_on = [aws_instance.my_server_db]
}

resource "aws_instance" "my_server_db" {
  ami                    = "ami-0bd39c806c2335b95"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.general.id]
  tags                   = { Name = "SRV-DB" }
}


resource "aws_security_group" "general" {
  name   = "Test Security Group"
  vpc_id = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = ["80", "8008", "443", "22", "3389"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TEST SecurityGroup"
  }
}

resource "aws_db_instance" "prod" {
  identifier           = "prod-mysql-rds"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
  username             = "administrator"
  password             = data.aws_ssm_parameter.rds_password.value
}

// Generate Password
resource "random_password" "main" {
  length           = 20
  special          = true #   Default: !@#$%&*()-_=+[]{}<>:?
  override_special = "#!()_"
}

// Store Password
resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/prod-mysql-rds/password"
  description = "Master Password for RDS Database"
  type        = "SecureString"
  value       = random_password.main.result
}

// Retrieve Password
data "aws_ssm_parameter" "rds_password" {
  name       = "/prod/prod-mysql-rds/password"
  depends_on = [aws_ssm_parameter.rds_password]
}


