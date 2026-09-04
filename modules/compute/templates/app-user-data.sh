#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

AWS_REGION="${aws_region}"
DB_HOST="${database_address}"
DB_PORT="${database_port}"
DB_NAME="${database_name}"
DB_SECRET_ARN="${database_secret_arn}"

STATUS_DIRECTORY="/var/lib/three-tier-app"
STATUS_FILE="$STATUS_DIRECTORY/database-status.txt"

apt-get update
apt-get install -y tomcat10 curl unzip jq default-mysql-client

# Install AWS CLI v2.
curl -sS \
  "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
  -o /tmp/awscliv2.zip

unzip -q /tmp/awscliv2.zip -d /tmp
/tmp/aws/install --update

mkdir -p "$STATUS_DIRECTORY"
mkdir -p /var/lib/tomcat10/webapps/ROOT

rm -f /var/lib/tomcat10/webapps/ROOT/index.html

cat > /usr/local/bin/check-application-database <<'SCRIPT'
#!/bin/bash
set -euo pipefail

AWS_REGION="${aws_region}"
DB_HOST="${database_address}"
DB_PORT="${database_port}"
DB_NAME="${database_name}"
DB_SECRET_ARN="${database_secret_arn}"

STATUS_DIRECTORY="/var/lib/three-tier-app"
STATUS_FILE="$STATUS_DIRECTORY/database-status.txt"

mkdir -p "$STATUS_DIRECTORY"

for ATTEMPT in $(seq 1 12); do
  if SECRET_JSON=$(/usr/local/bin/aws secretsmanager get-secret-value \
    --region "$AWS_REGION" \
    --secret-id "$DB_SECRET_ARN" \
    --query SecretString \
    --output text 2>/tmp/database-secret-error.log); then

    DB_USERNAME=$(printf '%s' "$SECRET_JSON" | jq -r '.username')
    DB_PASSWORD=$(printf '%s' "$SECRET_JSON" | jq -r '.password')

    if [ -n "$DB_USERNAME" ] &&
       [ "$DB_USERNAME" != "null" ] &&
       [ -n "$DB_PASSWORD" ] &&
       [ "$DB_PASSWORD" != "null" ]; then

      export MYSQL_PWD="$DB_PASSWORD"

      if mysql \
        --host="$DB_HOST" \
        --port="$DB_PORT" \
        --user="$DB_USERNAME" \
        --ssl-mode=REQUIRED \
        --connect-timeout=10 \
        "$DB_NAME" \
        --execute="
          CREATE TABLE IF NOT EXISTS application_health (
            id BIGINT AUTO_INCREMENT PRIMARY KEY,
            server_name VARCHAR(255) NOT NULL,
            checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          );

          INSERT INTO application_health (server_name)
          VALUES ('$(hostname)');

          SELECT COUNT(*) AS successful_database_checks
          FROM application_health;
        " > /tmp/database-query-result.txt 2>/tmp/database-query-error.log; then

        ROW_COUNT=$(mysql \
          --host="$DB_HOST" \
          --port="$DB_PORT" \
          --user="$DB_USERNAME" \
          --ssl-mode=REQUIRED \
          --connect-timeout=10 \
          --batch \
          --skip-column-names \
          "$DB_NAME" \
          --execute="SELECT COUNT(*) FROM application_health;")

        cat > "$STATUS_FILE" <<STATUS
Database connection: SUCCESS
Database server: $DB_HOST
Database name: $DB_NAME
Application server: $(hostname)
Rows written by application servers: $ROW_COUNT
STATUS

        unset MYSQL_PWD DB_PASSWORD SECRET_JSON
        chmod 640 "$STATUS_FILE"
        chown tomcat:tomcat "$STATUS_FILE"
        exit 0
      fi
    fi
  fi

  sleep 10
done

cat > "$STATUS_FILE" <<STATUS
Database connection: FAILED
Database server: $DB_HOST
Database name: $DB_NAME
Application server: $(hostname)
Check cloud-init and database connectivity logs.
STATUS

chmod 640 "$STATUS_FILE"
chown tomcat:tomcat "$STATUS_FILE"
exit 1
SCRIPT

chmod 750 /usr/local/bin/check-application-database

cat > /var/lib/tomcat10/webapps/ROOT/index.jsp <<'JSP'
<%@ page import="java.net.InetAddress" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.Paths" %>
<%
String databaseStatus;

try {
    databaseStatus = Files.readString(
        Paths.get("/var/lib/three-tier-app/database-status.txt")
    );
} catch (Exception exception) {
    databaseStatus = "Database verification is still starting.";
}
%>
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

        pre {
            background-color: #eef2ff;
            border-radius: 8px;
            padding: 20px;
            text-align: left;
        }
    </style>
</head>
<body>
    <div class="card">
        <h1>AWS Three-Tier DevSecOps Project</h1>

        <p>The request successfully reached the application tier.</p>

        <p>
            Application server:
            <strong><%= InetAddress.getLocalHost().getHostName() %></strong>
        </p>

        <h2>Database verification</h2>
        <pre><%= databaseStatus %></pre>
    </div>
</body>
</html>
JSP

chown -R tomcat:tomcat /var/lib/tomcat10/webapps/ROOT

systemctl enable tomcat10
systemctl restart tomcat10

# Perform the RDS write/read test without exposing the password.
/usr/local/bin/check-application-database || true

rm -rf /tmp/aws /tmp/awscliv2.zip