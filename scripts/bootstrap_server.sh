#!/usr/bin/env bash
set -euo pipefail

DOMAIN="${1:-openclawjourney.com}"
DEPLOY_USER="${2:-deploy}"
DEPLOY_PUBKEY="${3:-}"

if [[ -z "$DEPLOY_PUBKEY" ]]; then
  echo "Usage: $0 <domain> <deploy_user> <deploy_public_key>"
  exit 1
fi

sudo apt-get update -y
sudo apt-get install -y debian-keyring debian-archive-keyring apt-transport-https curl gnupg2 ufw fail2ban rsync

curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list >/dev/null
sudo apt-get update -y
sudo apt-get install -y caddy

if ! id -u "$DEPLOY_USER" >/dev/null 2>&1; then
  sudo useradd -m -s /bin/bash "$DEPLOY_USER"
fi

sudo mkdir -p "/home/$DEPLOY_USER/.ssh"
echo "$DEPLOY_PUBKEY" | sudo tee "/home/$DEPLOY_USER/.ssh/authorized_keys" >/dev/null
sudo chown -R "$DEPLOY_USER:$DEPLOY_USER" "/home/$DEPLOY_USER/.ssh"
sudo chmod 700 "/home/$DEPLOY_USER/.ssh"
sudo chmod 600 "/home/$DEPLOY_USER/.ssh/authorized_keys"

sudo mkdir -p /var/www/openclaw-journey/releases
sudo mkdir -p /var/www/openclaw-journey/current
sudo chown -R "$DEPLOY_USER:$DEPLOY_USER" /var/www/openclaw-journey

sudo tee /etc/sudoers.d/${DEPLOY_USER}-caddy >/dev/null <<EOF
$DEPLOY_USER ALL=(ALL) NOPASSWD: /usr/bin/systemctl reload caddy, /usr/bin/systemctl restart caddy
EOF
sudo chmod 440 /etc/sudoers.d/${DEPLOY_USER}-caddy

sudo tee /etc/caddy/Caddyfile >/dev/null <<EOF
$DOMAIN, www.$DOMAIN {
    root * /var/www/openclaw-journey/current
    encode zstd gzip
    file_server

    header {
        X-Content-Type-Options "nosniff"
        X-Frame-Options "SAMEORIGIN"
        Referrer-Policy "strict-origin-when-cross-origin"
        Permissions-Policy "geolocation=(), microphone=(), camera=()"
    }
}
EOF

sudo ufw allow OpenSSH || true
sudo ufw allow 80,443/tcp || true
sudo ufw --force enable || true
sudo systemctl enable --now fail2ban
sudo systemctl enable --now caddy
sudo systemctl reload caddy

echo "Bootstrap complete. DNS should point to this host for TLS issuance."