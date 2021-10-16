resource "aws_db_subnet_group" "database" {
  name = "wgpark_db_subnet_group"
  subnet_ids = [aws_subnet.wgpark_pria.id,aws_subnet.wgpark_pric.id]
}

resource "aws_db_instance" "wgpark_rds" {
  allocated_storage    = 10                     #DB 용량
  engine               = "mysql"                #엔진
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "wordpress"
  password             = "It12345!"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = false
  db_subnet_group_name = aws_db_subnet_group.database.id

  tags = {
    Name = "wgpark-mysql-rds"
  }
}

