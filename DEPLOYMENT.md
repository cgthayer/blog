# GitHub Pages Deployment Guide

Simple manual deployment for your Hugo blog to GitHub Pages with custom domain `thayer-blog.b2si.com`.

## Goals and Constraints

**Goals:**
- Deploy Hugo blog to GitHub Pages with custom domain `thayer-blog.b2si.com`
- Keep blog repository public (free GitHub Pages)
- Keep draft posts private and backed up
- Build and preview site locally (full control over Hugo version and build process)
- Simple, repeatable deployment workflow

**Constraints:**
- GitHub Pages on free accounts only works with public repositories
- Don't want draft content exposed in public repository, so placing them in writing repo.
- Need version control and backup for drafts
- Want to preview drafts locally before publishing

**Solution:**
- **Public repo** (`cgthayer/blog`) - Contains published content and Hugo configuration
- **Private repo** (`cgthayer/writing/article`) - Contains draft posts, symlinked locally for preview
- **Local builds** - Run `hugo` locally, output to `/docs` folder, push to `main` branch
- **Manual deployment** - No GitHub Actions needed since we build locally

This approach gives us free hosting, private drafts with backups, and local previewing.

## Prerequisites

- Repository at `https://github.com/cgthayer/blog`
- Access to DNS settings for `b2si.com`
- Hugo installed locally

## Deployment Workflow

### 1. Preview Locally

```bash
# Start Hugo development server
hugo server

# Site available at http://localhost:1313/
# Includes both published posts (content/posts/) and drafts (content/drafts/)
# Live reload on file changes
```

**Note:** Use `hugo server` instead of file:// URLs - Hugo requires a web server for proper routing and asset loading.

### 2. Build and Deploy

```bash
# Build the site (outputs to /docs folder)
hugo --gc --minify

# Commit and push
git add docs
git commit -m "Build site $(date)"
git push origin main
```

Or simply run the deploy script:

```bash
./deploy.sh
```

**Note:** Hugo is configured with `publishDir = "docs"` so output goes directly to `/docs` folder.

### 3. Configure GitHub Pages (One Time)

1. Go to `https://github.com/cgthayer/blog/settings/pages`
2. Under **Source**, select:
   - **Branch**: `main`
   - **Folder**: `/docs`
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
Type: A, Name: thayer-blog, Values: 185.199.108.153, 185.199.109.153, 185.199.110.153, 185.199.111.153
```

DNS propagation typically takes 1-2 hours (max 48 hours).

### 5. Set Custom Domain in GitHub

1. Go to **Settings** → **Pages**
2. Under **Custom domain**, enter: `thayer-blog.b2si.com`
3. Click **Save**
4. Wait for DNS verification
5. Enable **Enforce HTTPS**

## Quick Deploy Script

The `deploy.sh` script automates the build and deploy process:

```bash
#!/bin/bash
echo "Building site..."
hugo --gc --minify

echo "Deploying to main branch..."
git add docs
git commit -m "Build site $(date)"
git push origin main

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
