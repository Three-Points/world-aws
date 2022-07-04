resource "aws_instance" "ubuntu_instance" {
  ami                         = "ami-0cff7528ff583bf9a"
  instance_type               = "t2.micro"
  subnet_id                   = var.network_application.subnet
  associate_public_ip_address = true
  security_groups             = [
    var.network_application.security_group,
  ]
  tags = {
    Name = "Application"
  }
  user_data = file("./modules/instances/init.sh")
  key_name  = "ssh"
}

resource "aws_db_instance" "default" {
  engine                 = "mysql"
  engine_version         = "5.7.34"
  identifier             = "phonebook-db"
  username               = "dbadmin"
  password               = "u6QibHhani"
  instance_class         = "db.t2.micro"
  storage_type           = "gp2"
  allocated_storage      = 20
  db_subnet_group_name   = var.network_database.subnet
  vpc_security_group_ids = [
    var.network_database.security_group,
  ]
  db_name              = "phonebook"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}