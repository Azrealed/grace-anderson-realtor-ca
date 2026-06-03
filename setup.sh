#!/bin/bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  Grace Anderson REALTOR® — One-Command Deployment
#  Run this from inside the grace-anderson-realtor folder:
#    cd grace-anderson-realtor && bash setup.sh
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -e

REPO_NAME="grace-anderson-realtor"
SITE_NAME="grace-anderson-realtor"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Grace Anderson Site — Automated Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ─── 1. NODE.JS CHECK ─────────────────────────────────────────
if ! command -v node &>/dev/null; then
  echo "✖  Node.js not found."
  echo "   Install it from https://nodejs.org (LTS version) then re-run this script."
  exit 1
fi
echo "✓  Node.js $(node -v)"

# ─── 2. NETLIFY CLI ───────────────────────────────────────────
if ! command -v netlify &>/dev/null; then
  echo "→  Installing Netlify CLI…"
  npm install -g netlify-cli
fi
echo "✓  Netlify CLI $(netlify --version | head -1)"

# ─── 3. GITHUB CLI ────────────────────────────────────────────
if ! command -v gh &>/dev/null; then
  echo ""
  echo "⚠  GitHub CLI (gh) not found."
  echo "   Install it, then re-run:"
  echo "   • Mac:    brew install gh"
  echo "   • Win:    winget install GitHub.cli"
  echo "   • Or:     https://cli.github.com"
  echo ""
  read -p "Press Enter once installed, or Ctrl+C to cancel…"
fi
echo "✓  GitHub CLI $(gh --version | head -1)"

# ─── 4. GIT INIT ──────────────────────────────────────────────
if [ ! -d ".git" ]; then
  echo "→  Initialising Git repository…"
  git init
  git branch -M main
fi
git add -A
git diff --staged --quiet || git commit -m "Initial site: Grace Anderson REALTOR®"
echo "✓  Git repository ready"

# ─── 5. GITHUB LOGIN + REPO ───────────────────────────────────
echo ""
echo "→  Logging in to GitHub (a browser window will open)…"
gh auth login --web --git-protocol https
echo "→  Creating GitHub repository '$REPO_NAME'…"
gh repo create "$REPO_NAME" --public --source=. --remote=origin --push 2>/dev/null \
  || git push -u origin main
GITHUB_URL=$(gh repo view "$REPO_NAME" --json url -q .url 2>/dev/null || echo "https://github.com/YOUR_USER/$REPO_NAME")
echo "✓  GitHub repo live: $GITHUB_URL"

# ─── 6. NETLIFY LOGIN + SITE ──────────────────────────────────
echo ""
echo "→  Logging in to Netlify (a browser window will open)…"
netlify login
echo "→  Creating Netlify site and linking to GitHub…"
netlify init --name "$SITE_NAME"
echo "→  Deploying to production…"
netlify deploy --build --prod
NETLIFY_URL=$(netlify status --json 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('siteData',{}).get('ssl_url',''))" 2>/dev/null || echo "")
[ -n "$NETLIFY_URL" ] && echo "✓  Site live at: $NETLIFY_URL" || echo "✓  Site deployed — check your Netlify dashboard for the URL"

# ─── 7. DOMAIN (OPTIONAL) ─────────────────────────────────────
echo ""
read -p "→  Enter your custom domain (e.g. graceandersonrealtor.com) or press Enter to skip: " CUSTOM_DOMAIN
if [ -n "$CUSTOM_DOMAIN" ]; then
  netlify domains:add "$CUSTOM_DOMAIN" 2>/dev/null && echo "✓  Domain $CUSTOM_DOMAIN added to Netlify" || echo "ℹ  Add the domain manually in the Netlify dashboard → Domain Management"
fi

# ─── 8. SUMMARY ───────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✓  All done! Remaining 2-minute steps:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  IN NETLIFY DASHBOARD (netlify.com → your site):"
echo "  1. Settings → Identity → Enable"
echo "  2. Identity → Services → Enable Git Gateway"
echo "  3. Identity → Invite Users → Grace's email"
echo ""
if [ -n "$CUSTOM_DOMAIN" ]; then
echo "  IN NAMECHEAP (namecheap.com → $CUSTOM_DOMAIN → DNS):"
echo "  Option A — Use Netlify DNS (easiest):"
echo "    Domain List → $CUSTOM_DOMAIN → Manage → Nameservers"
echo "    Select 'Custom DNS' and paste the Netlify nameservers"
echo "    shown in Netlify → Domain Management → Netlify DNS"
echo ""
echo "  Option B — Keep Namecheap DNS:"
echo "    Add A record:     @    →  75.2.60.5"
echo "    Add CNAME record: www  →  $SITE_NAME.netlify.app"
fi
echo ""
echo "  Grace's admin panel will be at: https://$CUSTOM_DOMAIN/admin"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
