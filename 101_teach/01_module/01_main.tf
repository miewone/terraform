provider "aws" {
  region = var.region
}

resource "aws_vpc" "wgpark_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "${var.tagsName}-vpc"
  }
}

resource "aws_subnet" "wgpark_pub" {
  vpc_id            = aws_vpc.wgpark_vpc.id
  count             = length(var.subnet_pub_cidr_list)
  cidr_block        = var.subnet_pub_cidr_list[count.index]
  availability_zone = "${var.region}${var.subnet_az[count.index]}"

  tags = {
    Name = "${var.tagsName}-pub${var.subnet_az[count.index]}"
    test = "${var.region}${var.subnet_az[count.index]}"
  }
}

resource "aws_subnet" "wgpark_pri" {
  vpc_id            = aws_vpc.wgpark_vpc.id
  count             = length(var.subnet_pri_cidr_list)
  cidr_block        = var.subnet_pri_cidr_list[count.index]
  availability_zone = "${var.region}${var.subnet_az[count.index]}"

  tags = {
    Name = "${var.tagsName}-pri${var.subnet_az[count.index]}"
  }
}

resource "aws_internet_gateway" "wgpark_ig" {
  vpc_id = aws_vpc.wgpark_vpc.id

  tags = {
    Name = "${var.tagsName}-ig"
  }
}


resource "aws_route_table" "wgpark_pubrt" {
  vpc_id = aws_vpc.wgpark_vpc.id

  route {
    cidr_block = var.rt_pub_route_cidrblock
    gateway_id = aws_internet_gateway.wgpark_ig.id
  }

  tags = {
    Name = "${var.tagsName}-pubrt"
  }
}

resource "aws_route_table_association" "wgpark_puba_ass" {
  count          = length(var.subnet_pub_cidr_list)
  subnet_id      = aws_subnet.wgpark_pub[count.index].id
  route_table_id = aws_route_table.wgpark_pubrt.id
}


resource "aws_eip" "wgpark_eip_pri" {
  count = var.eip_pris
  vpc   = true
}

resource "aws_eip" "wgpark_eip_web_a1" {
  instance = aws_instance.wgpark_web[0].id
  vpc      = true
}

resource "aws_nat_gateway" "wgpark_ngw_pri" {
  count         = length(var.subnet_pri_cidr_list)
  allocation_id = aws_eip.wgpark_eip_pri[count.index].id
  subnet_id     = aws_subnet.wgpark_pub[count.index].id

  tags = {
    Name = "${var.tagsName}-ngw-pria"
  }
}

resource "aws_route_table" "wgpark_natrt_pri" {
  vpc_id = aws_vpc.wgpark_vpc.id
  count  = length(var.subnet_pri_cidr_list)
  route {
    cidr_block = var.rt_pir_route_cidrblock
    gateway_id = aws_nat_gateway.wgpark_ngw_pri[count.index].id
  }

  tags = {
    Name = "${var.tagsName}-natrt-pria${var.subnet_az[count.index]}"
  }
}

resource "aws_route_table_association" "wgpark_pria_ass" {
  count          = length(var.subnet_pri_cidr_list)
  subnet_id      = aws_subnet.wgpark_pri[count.index].id
  route_table_id = aws_route_table.wgpark_natrt_pri[count.index].id
}

resource "aws_security_group" "wgpark_allow_insatnces" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.wgpark_vpc.id


  ingress = var.sg_list_ingress

  egress = var.sg_list_egress

  tags = {
    Name = "${var.tagsName}-allow-http"
  }
}
resource "aws_security_group" "wgpark_allow_rds" {
  name        = "allow_rds_sg"
  description = "Allow rds inbound traffic"
  vpc_id      = aws_vpc.wgpark_vpc.id


  ingress = var.sg_rds_list_ingress

  egress = var.sg_rds_list_egress

  tags = {
    Name = "${var.tagsName}-allow-rds"
  }
}


resource "aws_instance" "wgpark_web" {
  count                  = length(var.ec2_instances)
  ami                    = var.ec2_instances[count.index].ami
  instance_type          = var.ec2_instances[count.index].instance_type
  key_name               = var.ec2_instances[count.index].key_name
  vpc_security_group_ids = [aws_security_group.wgpark_allow_insatnces.id]
  availability_zone      = var.ec2_instances[count.index].availability_zone
  private_ip             = var.ec2_instances[count.index].private_ip
  subnet_id              = aws_subnet.wgpark_pub[count.index].id
  user_data              = var.ec2_instances[count.index].user_data


  tags = {
    Name = "${var.tagsName}-web-a${count.index}"
  }
}


resource "aws_lb" "wgpark_lb" {
  name               = "${var.tagsName}-lb"
  internal           = var.lb_type.interval
  load_balancer_type = var.lb_type.lb_type
  security_groups    = [aws_security_group.wgpark_allow_insatnces.id]
  subnets            = aws_subnet.wgpark_pub.*.id
  #  subnets            = [aws_subnet.wgpark_pub[0].id,aws_subnet.wgpark_pub[1].id]
  /*
    enable_deletion_protection = true

    access_logs {
      bucket  = aws_s3_bucket.lb_logs.bucket
      prefix  = "test-lb"
      enabled = true
    }
  */
  tags               = {
    Env = "test"
  }
}

resource "aws_lb_target_group" "wgpark_lb_tg" {
  count    = length(var.lb_tg_list)
  name     = "${var.tagsName}-lb-tg"
  port     = var.lb_tg_list[count.index].port
  protocol = var.lb_tg_list[count.index].protocol
  vpc_id   = aws_vpc.wgpark_vpc.id
  #  target_type = "ip"


  health_check {
    enabled             = var.lb_tg_list[count.index].health_check.enabled
    healthy_threshold   = var.lb_tg_list[count.index].health_check.healthy_threshold
    interval            = var.lb_tg_list[count.index].health_check.interval
    matcher             = var.lb_tg_list[count.index].health_check.matcher
    path                = var.lb_tg_list[count.index].health_check.path
    port                = var.lb_tg_list[count.index].health_check.port
    protocol            = var.lb_tg_list[count.index].health_check.protocol
    timeout             = var.lb_tg_list[count.index].health_check.timeout
    unhealthy_threshold = var.lb_tg_list[count.index].health_check.unhealthy_threshold
  }
}

resource "aws_lb_listener" "wgpark_lb_front" {
  count             = length(var.lb_tg_list)
  load_balancer_arn = aws_lb.wgpark_lb.arn
  port              = var.lb_front.port
  protocol          = var.lb_front.protocol
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"
  # alpn_policy       = "HTTP2Preferred"

  default_action {
    type             = var.lb_front.default_action.type
    target_group_arn = aws_lb_target_group.wgpark_lb_tg[count.index].arn
  }
}

data "aws_instances" "test" {
  instance_tags = {
    Name = "${var.tagsName}-web-*"
  }
  depends_on    = [
    aws_eip.wgpark_eip_web_a1
  ]
}

resource "aws_ami_from_instance" "wgpark_web_id" {
  name               = "web-image"
  source_instance_id = aws_instance.wgpark_web[0].id
}

resource "aws_launch_configuration" "wgpark_as_conf" {
  count                = length(var.as_conf)
  name_prefix          = "${var.tagsName}-web-"
  image_id             = aws_ami_from_instance.wgpark_web_id.id
  instance_type        = var.as_conf[count.index].instance_type
  iam_instance_profile = var.as_conf[count.index].iam_instance_profile
  security_groups      = [aws_security_group.wgpark_allow_insatnces.id]
  key_name             = var.as_conf[count.index].key_name
  user_data            = var.as_conf[count.index].user_data

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_placement_group" "wgpark_pg" {
  name     = "${var.tagsName}-pg"
  strategy = "cluster"
}

resource "aws_autoscaling_group" "wgpark_at_sg" {
  count                     = length(var.as_conf)
  name                      = "${var.tagsName}-at-sg"
  max_size                  = 8
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = aws_launch_configuration.wgpark_as_conf[count.index].name
  vpc_zone_identifier       = aws_subnet.wgpark_pub.*.id
  #placement_group           = aws_placement_group.wgpark_pg.id
}

resource "aws_autoscaling_attachment" "wgpark_asg_attachment_alb" {
  count                  = length(var.as_conf)
  autoscaling_group_name = aws_autoscaling_group.wgpark_at_sg[count.index].id
  alb_target_group_arn   = aws_lb_target_group.wgpark_lb_tg[count.index].arn
}

resource "aws_db_subnet_group" "database" {
  name       = "wgpark_db_subnet_group"
  subnet_ids = aws_subnet.wgpark_pri.*.id
}

resource "aws_db_instance" "wgpark_rds" {
  allocated_storage    = var.rds.allocated_storage
  engine               = var.rds.engine
  engine_version       = var.rds.engine_version
  instance_class       = var.rds.instance_class
  name                 = var.rds.name
  username             = var.rds.username
  password             = var.rds.password
  parameter_group_name = var.rds.parameter_group_name

  db_subnet_group_name = aws_db_subnet_group.database.id

  vpc_security_group_ids = [aws_security_group.wgpark_allow_rds.id]
  skip_final_snapshot    = var.rds.skip_final_snapshot
  tags                   = {
    Name = "wgpark-mysql-rds"
  }
}

