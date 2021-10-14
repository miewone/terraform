#! /bin/bash
sudo su -
yum install -y httpd
cat > /var/www/html/index.html << end
<h1>Terraform-WEB-1<h1>
end
systemctl start httpd