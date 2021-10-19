  resource "aws_db_subnet_group" "database" {
  name = "wgpark_db_subnet_group"
  subnet_ids = [aws_subnet.wgpark_pria.id,aws_subnet.wgpark_pric.id]
}

resource "aws_db_instance" "wgpark_rds" {
  allocated_storage    = 10                     #DB 용량
  engine               = "mysql"                #엔진
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "wordpress"
  username             = "wordpress"
  password             = "It12345!"
  parameter_group_name = "default.mysql5.7"
  
  db_subnet_group_name = aws_db_subnet_group.database.id

  vpc_security_group_ids = [aws_security_group.wgpark_allow_mysql.id]
  skip_final_snapshot  = true
  tags = {
    Name = "wgpark-mysql-rds"
  }
}

