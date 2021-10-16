resource "aws_security_group" "wgpark_allow_http" {
  name        = "allow_httpssh"
  description = "Allow Http inbound traffic"
  vpc_id      = aws_vpc.wgpark_vpc.id

  ingress = [
    {
      description       = "Http from VPC"
      from_port         = 80
      to_port           = 80
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = ["::/0"]
      prefix_list_ids   = null
      security_groups   = null
      self              = null
    },
    {
      description       = "SSH from VPC"
      from_port         = 22
      to_port           = 22
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
      ipv6_cidr_blocks  = ["::/0"]
      prefix_list_ids   = null
      security_groups   = null
      self              = null
    }
  ]

  egress = [
    {
      description       = "default"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids   = null
      security_groups   = null
      self              = null
    }
  ]

  tags = {
    Name = "wgpark-allow-httpssh"
  }
}

resource "aws_security_group" "wgpark_allow_mysql" {
  name        = "allow_mysql"
  description = "Allow mysql inbound traffic"
  vpc_id      = aws_vpc.wgpark_vpc.id

  ingress = [
    {
      description       = "mysql from VPC"
      from_port         = 3306
      to_port           = 3306
      protocol          = "tcp"
      cidr_blocks       = [aws_subnet.wgpark_puba.cidr_block]
      ipv6_cidr_blocks  = ["::/0"]
      prefix_list_ids   = null
      security_groups   = null
      self              = null
    }
  ]

  egress = [
    {
      description       = "default"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids   = null
      security_groups   = null
      self              = null
    }
  ]

  tags = {
    Name = "wgpark-allow-rds"
  }
}