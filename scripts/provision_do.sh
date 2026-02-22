#!/usr/bin/env bash
set -euo pipefail

: "${DIGITALOCEAN_TOKEN:?DIGITALOCEAN_TOKEN is required}"

REGION="${REGION:-sfo2}"
SIZE="${SIZE:-s-1vcpu-1gb}"
IMAGE="${IMAGE:-ubuntu-24-04-x64}"
NAME="${NAME:-openclaw-journey-web}"
SSH_KEY_NAME="${SSH_KEY_NAME:-tom-mac-openclaw}"

if ! command -v doctl >/dev/null 2>&1; then
  echo "doctl is required. Install with: brew install doctl"
  exit 1
fi

doctl auth init -t "$DIGITALOCEAN_TOKEN" >/dev/null

KEY_ID=$(doctl compute ssh-key list --format Name,ID --no-header | awk -v n="$SSH_KEY_NAME" '$1==n{print $2}' | head -n1)
if [[ -z "$KEY_ID" ]]; then
  echo "SSH key named '$SSH_KEY_NAME' not found in DO account"
  exit 1
fi

echo "Creating droplet $NAME in $REGION ($SIZE)..."
doctl compute droplet create "$NAME" \
  --region "$REGION" \
  --size "$SIZE" \
  --image "$IMAGE" \
  --ssh-keys "$KEY_ID" \
  --wait \
  --format ID,Name,PublicIPv4,Status

echo "Done."