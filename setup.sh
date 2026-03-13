#!/bin/bash

# Nasflix Setup Script
# Generates secure credentials and prepares the environment
# Requires: Docker, Docker Compose, Bash

set -e

echo "Setting up Nasflix..."

# Generate random secure passwords
MYSQL_ROOT_PASSWORD=$(openssl rand -base64 24 | tr -dc 'a-zA-Z0-9' | head -c 24)
MYSQL_PASSWORD=$(openssl rand -base64 24 | tr -dc 'a-zA-Z0-9' | head -c 24)
SECRET_KEY_BASE=$(openssl rand -hex 64)
RAILS_MASTER_KEY=$(openssl rand -hex 16)

# Create .env file
cat > .env << EOF
# Nasflix Environment Configuration
# Generated on $(date)

# MySQL Database
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
MYSQL_DATABASE=nasflix_production
MYSQL_USER=nasflix
MYSQL_PASSWORD=${MYSQL_PASSWORD}

# Rails
RAILS_MASTER_KEY=${RAILS_MASTER_KEY}
SECRET_KEY_BASE=${SECRET_KEY_BASE}
EOF

echo "✓ Generated secure credentials in .env"
echo "✓ Run 'docker compose up -d --build' to start Nasflix"
