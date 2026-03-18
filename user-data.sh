#!/bin/bash

apt-get update -y
apt-get install -y apache2
systemctl start apache2
systemctl enable apache2

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Week 8 Load Balancer Demo</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container {
            background: rgba(255, 255, 255, 0.1);
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
        }
        h1 {
            text-align: center;
            font-size: 2.5em;
            margin-bottom: 30px;
        }
        .info-box {
            background: rgba(255, 255, 255, 0.2);
            padding: 15px;
            margin: 10px 0;
            border-radius: 5px;
        }
        .label {
            font-weight: bold;
            color: #ffd700;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Week 8: Load Balancer is Working! 🚀</h1>
        
        <div class="info-box">
            <p><span class="label">Instance ID:</span> ${INSTANCE_ID}</p>
        </div>
        
        <div class="info-box">
            <p><span class="label">Availability Zone:</span> ${AVAILABILITY_ZONE}</p>
        </div>
        
        <div class="info-box">
            <p><span class="label">Private IP:</span> ${PRIVATE_IP}</p>
        </div>
        
        <div class="info-box">
            <p><span class="label">Status:</span> ✅ Server is Healthy!</p>
        </div>
        
        <p style="text-align: center; margin-top: 30px;">
            Refresh the page to see different servers respond!
        </p>
    </div>
</body>
</html>
EOF

chmod 644 /var/www/html/index.html
systemctl restart apache2