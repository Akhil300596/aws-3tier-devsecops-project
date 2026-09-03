#!/bin/bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y tomcat10 curl

mkdir -p /var/lib/tomcat10/webapps/ROOT

cat > /var/lib/tomcat10/webapps/ROOT/index.jsp <<'JSP'
<%@ page import="java.net.InetAddress" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AWS Three-Tier Application</title>
    <style>
        body {
            background-color: #f4f7fb;
            font-family: Arial, sans-serif;
            text-align: center;
            padding-top: 80px;
        }

        .card {
            background-color: white;
            display: inline-block;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.12);
        }

        h1 {
            color: #5b21b6;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>AWS Three-Tier DevSecOps Project</h1>
        <p>The request successfully reached the application tier.</p>
        <p>Application server:
            <strong><%= InetAddress.getLocalHost().getHostName() %></strong>
        </p>
    </div>
</body>
</html>
JSP

chown -R tomcat:tomcat /var/lib/tomcat10/webapps/ROOT

systemctl enable tomcat10
systemctl restart tomcat10