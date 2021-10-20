module "test" {
  source = "../01_module"

  tagsName               = "wgpark"
  subnet_az              = ["a", "c"]
  region                 = "ap-northeast-2"
  vpc_cidr               = "10.1.0.0/16"
  subnet_pub_cidr_list   = ["10.1.1.0/24", "10.1.2.0/24"]
  subnet_pri_cidr_list   = ["10.1.3.0/24", "10.1.4.0/24"]
  rt_pub_route_cidrblock = "0.0.0.0/0"
  rt_pir_route_cidrblock = "0.0.0.0/0"

  sg_list_ingress = [
    {
      description      = "HTTP from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = null
      prefix_list_ids  = null
      self             = null
    },
    {
      description      = "SSH from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = null
      prefix_list_ids  = null
      self             = null
    }
  ]
  sg_list_egress  = [
    {
      description      = "all allow"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = null
      prefix_list_ids  = null
      self             = null
    }
  ]
  ec2_instances   = [
    {
      ami           = "ami-0e4a9ad2eb120e054"
      instance_type = "t2.medium"
      key_name      = "aws_terraform_tf"

      availability_zone = "ap-northeast-2a"
      private_ip        = "10.1.1.13"

      user_data = <<-EOF
                             #!/bin/bash
                             sudo su -
                             yum install -y httpd
                            curl http://169.254.169.254/latest/meta-data/instance-id -o /var/www/html/index.html
                            systemctl start httpd
                            EOF
    },
    {
      ami           = "ami-0e4a9ad2eb120e054"
      instance_type = "t2.medium"
      key_name      = "aws_terraform_tf"

      availability_zone = "ap-northeast-2c"
      private_ip        = "10.1.2.13"

      user_data = <<-EOF
                             #!/bin/bash
                             sudo su -
                             yum install -y httpd
                            curl http://169.254.169.254/latest/meta-data/instance-id -o /var/www/html/index.html
                            systemctl start httpd
                            EOF
    }
  ]
  lb_type         = {
    interval = false
    lb_type  = "application"
  }
  lb_tg_list      = [
    {
      port         = 80
      protocol     = "HTTP"
      health_check = {
        enabled             = true
        healthy_threshold   = 3
        interval            = 5
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 2
        unhealthy_threshold = 2
      }
    }
  ]
  lb_front        = {
    port           = "80"
    protocol       = "HTTP"
    default_action = {
      type = "forward"
    }
  }
  as_conf         = [
    {
      instance_type        = "t2.medium"
      iam_instance_profile = "admin_role"
      key_name             = "aws_terraform_tf"
      user_data            = <<-EOF
                        #!/bin/bash
                        systemctl restart httpd
                        systemctl enable httpd
                        EOF
    }
  ]
  eip_pris        = 2

  rds = {
    allocated_storage    = 10                     #DB 용량
    engine               = "mysql"                #엔진
    engine_version       = "5.7"
    instance_class       = "db.t3.micro"
    name                 = "wordpress"
    username             = "wordpress"
    password             = "It12345!"
    parameter_group_name = "default.mysql5.7"

    skip_final_snapshot = true
  }

  sg_rds_list_ingress = [
    {

      description      = "mysql from VPC"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks       = ["10.1.1.0/24","10.1.2.0/24"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null

    }
  ]

  sg_rds_list_egress = [
    {

      description      = "default"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null

    }
  ]
}