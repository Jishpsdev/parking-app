#!/bin/bash

# Configuration
REPO_NAME="parking-app"  # ⚠️ Change this to your GitHub repository name
GITHUB_USERNAME="Jishpsdev"  # Add your GitHub username here

echo "🚀 Deploying Smart Parking App to GitHub Pages"
echo "================================================"
echo ""
echo "📦 Building Flutter web app..."
flutter build web --release --base-href /$REPO_NAME/

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo "✅ Build successful!"
echo ""

# Check if gh-pages is installed
if ! command -v gh-pages &> /dev/null; then
    echo "⚠️  gh-pages npm package not found"
    echo ""
    echo "Install it with one of these commands:"
    echo "  npm install -g gh-pages"
    echo "  yarn global add gh-pages"
    echo ""
    echo "Or use GitHub Actions for automatic deployment (recommended)"
    echo "See: GITHUB_PAGES_DEPLOYMENT.md"
    exit 1
fi

echo "📤 Deploying to GitHub Pages..."
gh-pages -d build/web

if [ $? -ne 0 ]; then
    echo "❌ Deployment failed!"
    exit 1
fi

echo ""
echo "🎉 Deployment complete!"
echo "================================================"
echo ""
echo "Your app will be available at:"
if [ -z "$GITHUB_USERNAME" ]; then
    echo "https://YOUR-USERNAME.github.io/$REPO_NAME/"
else
    echo "https://$GITHUB_USERNAME.github.io/$REPO_NAME/"
fi
echo ""
echo "Note: It may take 1-2 minutes for changes to appear."
echo "Check deployment status at:"
if [ -z "$GITHUB_USERNAME" ]; then
    echo "https://github.com/YOUR-USERNAME/$REPO_NAME/deployments"
else
    echo "https://github.com/$GITHUB_USERNAME/$REPO_NAME/deployments"
fi
echo ""
