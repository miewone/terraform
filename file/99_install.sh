#! /bin/bash
sudo su -

yum install -y httpd

amazon-linux-extras install php7.4
amazon-linux-extras enable php7.4

yum install -y php php-cli php-mysql 

wget https://ko.wordpress.org/latest-ko_KR.tar.gz
tar -xzf latest-ko_KR.tar.gz
cp -a wordpress/* /var/www/html/
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

chown apache.apache /var/www/html/*

sed -i 's/DirectoryIndex index.html/DirectoryIndex index.php/g' /etc/httpd/conf/httpd.conf
systemctl start httpd
systemctl enable httpd
sed -i 's/database_name_here/wordpress/g' /var/www/html/wp-config.php
sed -i 's/username_here/wordpress/g' /var/www/html/wp-config.php
sed -i 's/password_here/It12345!/g' /var/www/html/wp-config.php
sed -i 's/localhost/terraform-20211016153101238200000001.cyzaniwmw0sq.ap-northeast-2.rds.amazonaws.com/g' /var/www/html/wp-config.php

sed -i 's/define( "AUTH_KEY","put your unique phrase here" );/define("AUTH_KEY",         "6u4^&4MP%r{+f>TN=$W~swC>I5wS5C,1Gb,B+u^8nX@Pt%]x43ezIbComi)7J7R#");/g' /var/www/html/wp-config.php
sed -i 's/define( "SECURE_AUTH_KEY","put your unique phrase here" );/define("SECURE_AUTH_KEY",  "G2b[6j]/@:]{G&%RKfFf!9gI-&t$l+}]lV!Z/i75*Pn]bv}ugW++/Ktk+$B)4(1}");/g' /var/www/html/wp-config.php
sed -i 's/define( "LOGGED_IN_KEY",    "put your unique phrase here" );/define("LOGGED_IN_KEY",    "@[|]lV<rcB!mQ+p0,^XSN:r-$zMX%p7({GzL7gk*r#yw-s$nlTS>]j%jKi>()$+E");/g' /var/www/html/wp-config.php
sed -i 's/define( "NONCE_KEY","put your unique phrase here" );/define("NONCE_KEY",        "4 jap0](zJVtc186)M#}`Qk7(m#>J9.gf?=7WNfgzu(HnJvZPRRW*.)mAOGJ~%lU");/g' /var/www/html/wp-config.php
sed -i 's/define( "AUTH_SALT","put your unique phrase here" );/define("AUTH_SALT",        "-`eIAT{iP5/P]:|vAR)V1/tprG4b+ne =d!A#g~gQm[l<HQ}nrMIEs[`$4@h<+%X");/g' /var/www/html/wp-config.php
sed -i 's/define( "SECURE_AUTH_SALT","put your unique phrase here" );/define("SECURE_AUTH_SALT", "enow)tGAV.@VyJwReEL4wQc1R,&&M3~b<z!_R|h_^2a<,F+HzoX`#`|(wc<+q0br");/g' /var/www/html/wp-config.php
sed -i 's/define( "LOGGED_IN_SALT","put your unique phrase here" );/define("LOGGED_IN_SALT",   "<.?E %f1Z?7>R[wpw*vUrD--4`+@sVByR2q8u#TWW.!L2z|WtT@pdgjrz8q/b;-R");/g' /var/www/html/wp-config.php
sed -i 's/define( "NONCE_SALT","put your unique phrase here" );/define("NONCE_SALT",       ":+q.kw0Gje@fA%S#=En(E8/}3-@E+;_qB9(,G>SAqATILJkO*>JjsPhwn4ZW8Vy$");/g' /var/www/html/wp-config.php


