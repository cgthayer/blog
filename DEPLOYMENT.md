# GitHub Pages Deployment Guide

Simple manual deployment for your Hugo blog to GitHub Pages with custom domain `thayer-blog.b2si.com`.

## Prerequisites

- Repository at `https://github.com/cgthayer/blog`
- Access to DNS settings for `b2si.com`
- Hugo installed locally

## Deployment Workflow

### 1. Build Locally

```bash
# Build the static site
hugo --gc --minify

# This generates the site in the ./public directory
```

### 2. Deploy to GitHub Pages

**Option A: Use gh-pages branch (Recommended)**

```bash
# Build the site
hugo --gc --minify

# Deploy to gh-pages branch
git add public -f  # Force add public/ (usually gitignored)
git commit -m "Build site $(date)"
git subtree push --prefix public origin gh-pages
```

**Note:** This uses `git subtree` to push only the `public/` directory contents to the `gh-pages` branch.

**Option B: Push public/ folder to main branch**

Add `public/` to your main branch and configure GitHub Pages to serve from `/public` folder.

### 3. Configure GitHub Pages

1. Go to `https://github.com/cgthayer/blog/settings/pages`
2. Under **Source**, select:
   - **Branch**: `gh-pages` (or `main` if using Option B)
   - **Folder**: `/root` (or `/public` if using Option B)
3. Click **Save**

### 4. Configure DNS

Add a CNAME record in your DNS provider for `b2si.com`:

```
Type: CNAME
Name: thayer-blog
Value: cgthayer.github.io
```

**Alternative: A Records**
```
Type: A
Name: thayer-blog
Value: 185.199.108.153

Type: A
Name: thayer-blog
Value: 185.199.109.153

Type: A
Name: thayer-blog
Value: 185.199.110.153

Type: A
Name: thayer-blog
Value: 185.199.111.153
```

DNS propagation typically takes 1-2 hours (max 48 hours).

### 5. Set Custom Domain in GitHub

1. Go to **Settings** → **Pages**
2. Under **Custom domain**, enter: `thayer-blog.b2si.com`
3. Click **Save**
4. Wait for DNS verification
5. Enable **Enforce HTTPS**

## Quick Deploy Script

Create `deploy.sh` in your repo root:

```bash
#!/bin/bash
echo "Building site..."
hugo --gc --minify

echo "Deploying to gh-pages..."
git add public -f
git commit -m "Build site $(date)"
git subtree push --prefix public origin gh-pages

echo "Deployed! Site will be live at https://thayer-blog.b2si.com"
```

Make executable: `chmod +x deploy.sh`

Then deploy with: `./deploy.sh`

## Troubleshooting

### DNS Not Resolving
```bash
dig thayer-blog.b2si.com
```

### Custom Domain Not Working
- Verify `static/CNAME` contains: `thayer-blog.b2si.com`
- Check GitHub Pages settings show the custom domain
- Ensure DNS records point to GitHub Pages

### Site Not Updating
- Clear browser cache
- Wait a few minutes for GitHub Pages to rebuild
- Check that you pushed to the correct branch

## GitHub Pages Pricing

**Free for unlimited public repositories** - no payment needed even with multiple sites and custom domains.
