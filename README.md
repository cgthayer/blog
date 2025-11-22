# AI Dev Blog

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
