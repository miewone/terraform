variable "region" {
  type        = string
#  default     = "ap-northeast-2"
  description = "Region 값을 입력하세요"
}

variable "vpc_cidr" {
  type        = string
#  default     = "10.0.0.0/16"
}

variable "subnet_az" {
  type        = list(string)
}
variable "subnet_pub_cidr_list" {
  description = "서브넷 PUB CIDR을 작성해야합니다."
  type        = list(string)
#  default    = ["10.0.0.0/24","10.0.2.0/24"]
}
variable "subnet_pri_cidr_list" {
  description = "서브넷 PRI CIDR을 작성해야합니다."
  type        = list(string)
  #  default  = ["10.0.1.0/24","10.0.3.0/24"]
}

variable "tagsName" {
  type        = string
}

variable "rt_pub_route_cidrblock" {
  type        = string
}
variable "rt_pir_route_cidrblock" {
  type        = string
}

variable "sg_list_ingress" {
  type        = list(object(
    {
      description       = string
      from_port         = number
      to_port           = number
      protocol          = string
      cidr_blocks       = list(string)
      ipv6_cidr_blocks  = list(string)
      security_groups   = list(string)
      prefix_list_ids   = list(string)
      self              = string
    }
  ))
}

variable "sg_list_egress" {
  type        = list(object(
    {
      description       = string
      from_port         = number
      to_port           = number
      protocol          = string
      cidr_blocks       = list(string)
      ipv6_cidr_blocks  = list(string)
      security_groups   = list(string)
      prefix_list_ids   = list(string)
      self              = string
    }
  ))
}
variable "ec2_instances" {
  type                  = list(object({
    ami                    = string
    instance_type          = string
    key_name               = string
#    vpc_security_group_ids = [aws_security_group.wgpark_allow_http.id]
    availability_zone      = string
    private_ip             = string
#    subnet_id              = aws_subnet.wgpark_pub[0].id
    user_data              = string
  }))
}

variable "lb_type" {
  type                  =  object({
    interval  = bool
    lb_type   = string
  })
}

variable "lb_tg_list" {
  type                  = list(object({
    port      = number
    protocol  = string
    health_check = object({
      enabled             = bool
      healthy_threshold   = number
      interval            = number
      matcher             = string
      path                = string
      port                = string
      protocol            = string
      timeout             = number
      unhealthy_threshold = number
    })
  }))
}
variable "lb_front" {
  type          = object({
    port      = string
    protocol  = string
    default_action = object({
      type    = string
    })
  })
}

variable "as_conf" {
  type = list(object({
    instance_type = string
    iam_instance_profile  = string
    key_name          = string
    user_data         = string
  }))
}
variable "eip_pris" {
  type = number
}