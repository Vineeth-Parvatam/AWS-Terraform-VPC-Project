#!/bin/bash
sudo apt update -y
cd /home/ubuntu
cat <<EOF > index.html
<!DOCTYPE html>
<html>
<head>
  <title>VPC Deployment Success</title>
  <style>
    body {
      background-color: #f4f6f8;
      font-family: Arial, sans-serif;
      text-align: center;
      padding-top: 100px;
    }
    .container {
      background-color: #fff;
      display: inline-block;
      padding: 40px;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }
    h1 {
      color: #2c3e50;
    }
    p {
      color: #34495e;
      font-size: 18px;
    }
    code {
      background-color: #ecf0f1;
      padding: 2px 6px;
      border-radius: 4px;
      font-family: monospace;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1> VPC Deployment Successful!!</h1>
    <p>This instance is running in a <strong>private subnet</strong></p>
    <p>Accessed via a <strong>public ALB</strong> in the same VPC</p>
    <p>Provisioned using <code>Terraform</code></p>
  </div>
</body>
</html>
EOF
sudo nohup python3 -m http.server 8000 --directory /home/ubuntu &