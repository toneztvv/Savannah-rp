# Deploy Savannah RP Website

This folder is the full static website. Upload everything in this folder to your web host document root (or `/var/www/savannah-rp` on a VPS).

## Quick options

### A) Your VPS / game server (Nginx)
1. Copy this folder to the server: `scp -r savannah-rp-website/* user@YOUR-SERVER:/var/www/savannah-rp/`
2. Use `nginx.conf.example` as a starting point.
3. Point your domain DNS A/AAAA record at the server IP.
4. (Optional) Add HTTPS with Certbot: `sudo certbot --nginx -d YOUR-DOMAIN.COM`

### B) Apache / cPanel / shared hosting
1. Upload all files into `public_html` (or your domain folder).
2. Keep `.htaccess` so missing pages show `404.html`.

### C) GitHub Pages / Netlify / Cloudflare Pages
1. Push this folder as a GitHub repo.
2. Enable Pages (or connect Netlify/Cloudflare to the repo).
3. Set the publish directory to the site root.

## Before you go live — fill these in

1. **FiveM status** — in `script.js` set:
   ```js
   const SAVANNAH_CFX_SERVER_ID = "your-public-join-code";
   ```
   Use the public Cfx.re join code only. Never put a license key here.

2. **Discord invite** — replace “coming soon” Discord buttons/links in `index.html` and `join.html`.

3. **Direct connect** — replace Play Now / connect placeholders with your FiveM connect link or server IP.

4. **Support email** — replace `ADD-YOUR-EMAIL@EXAMPLE.COM` in:
   - `support.html`
   - `terms.html`
   - `privacy.html`
   - `refunds.html`

5. **Tebex store** — when your store URL is ready, replace “STORE COMING SOON” buttons with real package links.

6. **Hero art** — replace `hero-reference.png` with final screenshots when ready.
