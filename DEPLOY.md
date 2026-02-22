# Deploy: OpenClaw Journey (DigitalOcean + Caddy)

## Architecture
- Ubuntu Droplet (sfo2, s-1vcpu-1gb)
- Caddy serves static files from `/var/www/openclaw-journey/current`
- GitHub Actions builds Astro and rsyncs `dist/` to server

## One-time setup (assistant-run)
1. Create droplet using `scripts/provision_do.sh`
2. Point DNS A records:
   - `openclawjourney.com` -> droplet IP
   - `www.openclawjourney.com` -> droplet IP
3. Add GitHub secrets (repo settings):
   - `DEPLOY_HOST`
   - `DEPLOY_USER` (default `deploy`)
   - `DEPLOY_SSH_KEY` (private key for deploy user)

## Ongoing publishing
- Push to `main`
- Workflow `.github/workflows/deploy.yml` builds + deploys automatically

## Editorial gate (important)
- Co-authored posts (`authors: ["tom", "clara"]`) must be reviewed before publish.
- Keep them as `draft: true` until Tom explicitly approves publication.
- Drafts are excluded from public routes and RSS by design.

## Manual deploy fallback
```bash
npm ci
npm run build
rsync -az --delete dist/ deploy@<HOST>:/var/www/openclaw-journey/releases/manual/
ssh deploy@<HOST> 'ln -sfn /var/www/openclaw-journey/releases/manual /var/www/openclaw-journey/current && sudo systemctl reload caddy'
```
