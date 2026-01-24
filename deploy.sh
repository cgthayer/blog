#!/bin/bash
echo "Building site..."
hugo --gc --minify

echo "Deploying to main branch..."
git add docs
git commit -m "Build site $(date)"
git push origin main

echo "Deployed! Site will be live at https://thayer-blog.b2si.com"
