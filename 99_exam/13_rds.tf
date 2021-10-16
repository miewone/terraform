# resource "aws_db_instance" "wgpark_rds" {
#   allocated_storage    = 10                     #DB 용량
#   engine               = "mysql"                #엔진
#   engine_version       = "5.7"
#   instance_class       = "db.t3.micro"
#   name                 = "mydb"
#   username             = "wordpress"
#   password             = "It12345!"
#   parameter_group_name = "default.mysql5.7"
#   skip_final_snapshot  = false
# }