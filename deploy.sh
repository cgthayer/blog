#!/bin/bash
echo "Building site..."
hugo --gc --minify

echo "Deploying to main branch..."
git commit -am "Build site $(date)"
git push

echo "Deployed! Site will be live at https://thayer-blog.b2si.com"
