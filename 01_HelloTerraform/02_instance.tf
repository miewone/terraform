resource "aws_instance" "ubuntu" {
      ami               = "ami-04876f29fd3a5e8ba"
      instance_type     = "t2.small"
      user_data = <<-eof
                  #! /bin/bash
                  sudo su -
                  yum insatll -y httpd
                  cat > /var/www/html/index.html << end
                  <h1>Terraform-WEB-1<h1>
                  end
                  systemctl start httpd
                  eof
      tags = {
            Name = "aws-ubuntu-1"
      }
}