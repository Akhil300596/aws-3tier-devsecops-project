#!/bin/bash
set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y nginx curl

cat > /etc/nginx/sites-available/default <<'NGINX'
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    location = /web-health {
        access_log off;
        add_header Content-Type text/plain;
        return 200 "Web tier is healthy\n";
    }

    location / {
        proxy_pass http://${internal_nlb_dns_name}:8080;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_connect_timeout 10s;
        proxy_read_timeout 30s;
    }
}
NGINX

nginx -t
systemctl enable nginx
systemctl restart nginx