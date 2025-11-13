#!/bin/bash

# Update and install nginx
apt update -y
apt install -y nginx

# Create Hello World page
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Hello World</title>
</head>
<body>
  <h1 style="text-align:center; margin-top: 20%;">Hello, World from $(hostname)! </h1>
</body>
</html>
EOF

# Start and enable nginx
systemctl enable nginx
systemctl start nginx

