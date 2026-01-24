#!/bin/bash
echo "Building site..."
hugo --gc --minify

echo "Deploying to gh-pages branch..."
git add public -f
git commit -m "Build site $(date)"
git subtree push --prefix public origin gh-pages

echo "Deployed! Site will be live at https://thayer-blog.b2si.com"
