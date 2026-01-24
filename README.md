# My Blog

This is an experimental space to try Hugo with a personal and targeted
blog.  The personal space is tied to Obsidian as a vault and let's me
write and share with specific people in a safe (Dark Forest). The
professional blog is targeted at AI software engineers and those
wishing to get up to speed with AI and LLM technology.

# LTS: The AI Software Engineer Blog

LTS: Learn, Tinker, Share

A Hugo blog for experienced software engineers starting to engage with AI and LLM programming. This repository also functions as an Obsidian vault.

## Features

- Built with [Hugo](https://gohugo.io/)
- Theme: [PaperMod](https://github.com/adityatelange/hugo-PaperMod)
- Auto light/dark theme support
- HTML support in Markdown
- Compatible with Obsidian

## Setup

### Prerequisites

- [Hugo](https://gohugo.io/installation/) (extended version recommended)
- Git

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/cgthayer/blog.git
   cd blog
   ```

2. Initialize the theme submodule:
   ```bash
   git submodule update --init --recursive
   ```

### Running Locally

Start the Hugo development server:

```bash
hugo server -D
```

The blog will be available at `http://localhost:1313/`

### Creating New Posts

Create a new blog post:

```bash
hugo new content/posts/my-post.md
```

Edit the post and set `draft: false` when ready to publish.

### Draft Management with Private Repo

To keep drafts private while maintaining backups and version control, this blog uses a symlinked private repository approach.

#### Initial Setup (One Time)

1. Create a private repository for drafts:
   ```bash
   cd ~/work
   git clone git@github.com:cgthayer/blog-drafts.git  # Create this as a private repo
   cd blog-drafts
   mkdir posts
   git add posts
   git commit -m "Initial commit"
   git push
   ```

2. Create symlink in your blog repo:
   ```bash
   cd ~/work/blog/content
   ln -s ~/work/blog-drafts/posts drafts
   ```

3. Commit the symlink to your public blog repo:
   ```bash
   git add drafts
   git commit -m "Add symlink to private drafts"
   git push
   ```

**Note:** The symlink will be broken on GitHub (since the target is in a private repo), so drafts remain completely hidden from the public repository.

#### Writing Drafts

1. Create and edit drafts in the private repo:
   ```bash
   cd ~/work/blog-drafts/posts
   vim my-draft-post.md
   ```

2. Commit and push to backup your drafts:
   ```bash
   git add my-draft-post.md
   git commit -m "WIP: my draft post"
   git push
   ```

3. Preview locally (Hugo sees drafts via symlink):
   ```bash
   cd ~/work/blog
   hugo server -D
   ```

#### Publishing a Draft

When ready to publish, move the file from drafts to posts:

```bash
# Move the file
mv ~/work/blog-drafts/posts/my-draft-post.md content/posts/

# Commit to public blog repo
git add content/posts/my-draft-post.md
git commit -m "Publish: my draft post"
git push

# Clean up from private drafts repo
cd ~/work/blog-drafts
git add -A
git commit -m "Published: my draft post"
git push
```

**Benefits:**
- ✓ Drafts are version controlled and backed up to GitHub
- ✓ Drafts remain completely private (in separate private repo)
- ✓ Local preview works seamlessly
- ✓ No risk of losing drafts if local disk fails
- ✓ Public repo never exposes draft content

## Directory Structure

- `content/posts/` - Blog posts
- `themes/PaperMod/` - PaperMod theme (git submodule)
- `static/` - Static assets (images, files, etc.)
- `layouts/` - Custom layout overrides
- `archetypes/` - Content templates

## Configuration

The blog is configured in `hugo.toml`. Key settings:

- **baseURL**: `http://localhost:1313/` (change for production)
- **title**: AI Dev Blog
- **theme**: PaperMod
- **defaultTheme**: auto (respects system preference)
- **Markup**: HTML enabled in markdown

## Obsidian Integration

This repository can be opened as an Obsidian vault. The `.obsidian/` directory is gitignored to keep personal settings local.
