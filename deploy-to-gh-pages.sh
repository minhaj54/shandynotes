#!/bin/bash

# Exit on errors
set -e

REPO_URL="https://github.com/minhaj54/shandynotes.git"

echo "==============================="
echo "🚀 Flutter Deployment Script"
echo "==============================="
echo "Choose an option:"
echo "1) Push source code to main branch"
echo "2) Deploy Flutter web build to gh-pages"
echo "==============================="
read -p "Enter choice (1 or 2): " choice

if [ "$choice" == "1" ]; then
    echo "📦 Pushing source code to main branch..."
    git add .
    git commit -m "Updated source code"
    git branch -M main
    git push -u origin main
    echo "✅ Source code pushed successfully to main branch."

elif [ "$choice" == "2" ]; then
    echo "🌐 Deploying Flutter web app to gh-pages..."

    # Build Flutter web app
    flutter clean
    flutter build web --no-tree-shake-icons

    # Navigate to build directory
    cd build/web

    # If a git repo already exists, remove it
    if [ -d ".git" ]; then
        rm -rf .git
        echo "🗑️ Removed old .git folder to avoid remote conflicts."
    fi

    # Initialize new git repo for gh-pages
    git init
    git add .
    git commit -m "Deploy Flutter web app to GitHub Pages"
    git branch -M gh-pages
    git remote add origin "$REPO_URL"
    git push -f origin gh-pages

    # Go back to project root
    cd ../..

    echo "✅ Deployment successful! Your site will be live at:"
    echo "🌐 https://minhaj54.github.io/shandynotes/"
else
    echo "❌ Invalid option. Please run the script again and choose 1 or 2."
fi
