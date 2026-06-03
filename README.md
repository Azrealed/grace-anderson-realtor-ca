# Grace Anderson REALTOR® — Deployment Guide
*Built by BranDDRive.AI*

---

## Fastest path: One-command deploy (Mac)

Open Terminal, navigate to this folder, and run:

```bash
bash setup.sh
```

The script handles everything:
- Installs Netlify CLI and GitHub CLI if needed
- Creates a GitHub repository
- Deploys to Netlify
- Prompts for your custom domain
- Prints the exact DNS records for Namecheap

**Prerequisites (install first if you don't have them):**
- Node.js: https://nodejs.org (LTS)
- GitHub CLI: `brew install gh` (or https://cli.github.com)

---

## Manual steps (if you prefer the GUI route)

### Step 1 — GitHub

1. Go to **github.com** → click **+** → **New repository**
2. Name it `grace-anderson-realtor`, set to **Public**, click **Create**
3. On your Mac, open Terminal in this folder and run:
   ```bash
   git init
   git branch -M main
   git add -A
   git commit -m "Grace Anderson site"
   git remote add origin https://github.com/YOUR_USERNAME/grace-anderson-realtor.git
   git push -u origin main
   ```

### Step 2 — Netlify

1. Go to **netlify.com** → **Add new site** → **Import from Git**
2. Connect GitHub, select **grace-anderson-realtor**
3. Build command: *(leave empty)*  
   Publish directory: `.` (a single dot)
4. Click **Deploy** — it'll be live in under 60 seconds

### Step 3 — Enable the CMS (5 clicks)

In your Netlify dashboard for this site:

1. **Site Settings → Identity → Enable Identity**
2. **Identity → Services → Enable Git Gateway**
3. **Identity → Invite Users → enter Grace's email**

Grace will get an email, set a password, and can immediately log in at `/admin`.

### Step 4 — Add your domain

In Netlify: **Domain Management → Add a domain** → enter your domain.

Netlify will show you DNS records. Then:

---

## Namecheap DNS Setup

Log in to **namecheap.com** → Domain List → your domain → **Manage** → **Advanced DNS**

### Option A — Netlify DNS (recommended, simplest)

1. In Netlify: Domain Management → **Set up Netlify DNS**
2. Netlify gives you 4 nameserver addresses (e.g. `dns1.p01.nsone.net`)
3. In Namecheap: **Domain** tab → **Nameservers → Custom DNS**
4. Paste all 4 Netlify nameservers, save
5. DNS propagates in 24–48 hours, SSL auto-provisions

### Option B — Keep Namecheap DNS (add records manually)

In Namecheap **Advanced DNS**, delete any existing A or CNAME records for `@` and `www`, then add:

| Type  | Host | Value                          | TTL      |
|-------|------|--------------------------------|----------|
| A     | @    | `75.2.60.5`                    | Automatic |
| CNAME | www  | `grace-anderson-realtor.netlify.app` | Automatic |

Save. DNS propagates in 24–48 hours.  
Once DNS resolves, Netlify auto-provisions a free SSL certificate.

---

## What Grace can do in the admin

Grace visits **yourdomain.com/admin**, logs in, and sees:

- **Blog Posts** — add, edit, publish posts; markdown editor with image upload
- **Property Listings** — add listings with address, price, photos, description, features; each one gets a shareable landing page at `yourdomain.com/listings/?id=the-slug`

Every save auto-deploys to the live site in under 30 seconds.

---

## File structure

```
grace-anderson-realtor/
├── index.html          ← Main lead-capture page
├── blog/
│   └── index.html      ← The Shasta County Journal
├── listings/
│   └── index.html      ← Property grid + individual landing pages
├── admin/
│   ├── index.html      ← Decap CMS loader
│   └── config.yml      ← CMS field definitions (edit to add fields)
├── _data/
│   ├── posts.json      ← All blog posts
│   └── listings.json   ← All listings
├── assets/             ← Photos and uploads
├── netlify.toml        ← Netlify config
└── setup.sh            ← One-command deploy script
```

---

## Sharing a listing with a client

Each listing has a URL like:  
`https://yourdomain.com/listings/?id=1234-main-st-redding`

Grace can text or DM this link to buyers — it opens a full property page with photos, stats, description, and a "Schedule a Showing" form that goes straight to her inbox.

---

*Questions? Ask Derek at BranDDRive.AI.*
