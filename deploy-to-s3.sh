#!/bin/bash

# Configuration
BUCKET_NAME="smart-parking-app"  # Change this to your bucket name
DISTRIBUTION_ID=""  # Add your CloudFront distribution ID here (optional)

echo "🚀 Building Flutter web app..."
flutter build web --release

echo "📦 Uploading to S3..."

# Upload all files with default cache (1 year for assets)
aws s3 sync build/web/ s3://$BUCKET_NAME/ \
  --delete \
  --cache-control "public, max-age=31536000" \
  --exclude "index.html" \
  --exclude "flutter_service_worker.js" \
  --exclude "firebase-messaging-sw.js" \
  --exclude "manifest.json"

# Upload index.html with no-cache (always check for updates)
aws s3 cp build/web/index.html s3://$BUCKET_NAME/index.html \
  --content-type "text/html" \
  --cache-control "no-cache, no-store, must-revalidate" \
  --metadata-directive REPLACE

# Upload service workers with no-cache
aws s3 cp build/web/flutter_service_worker.js s3://$BUCKET_NAME/flutter_service_worker.js \
  --content-type "application/javascript" \
  --cache-control "no-cache, no-store, must-revalidate" \
  --metadata-directive REPLACE

aws s3 cp build/web/firebase-messaging-sw.js s3://$BUCKET_NAME/firebase-messaging-sw.js \
  --content-type "application/javascript" \
  --cache-control "no-cache, no-store, must-revalidate" \
  --metadata-directive REPLACE

# Upload manifest with short cache
aws s3 cp build/web/manifest.json s3://$BUCKET_NAME/manifest.json \
  --content-type "application/manifest+json" \
  --cache-control "public, max-age=3600" \
  --metadata-directive REPLACE

echo "✅ Upload complete!"

# Invalidate CloudFront cache (optional - requires DISTRIBUTION_ID)
if [ ! -z "$DISTRIBUTION_ID" ]; then
  echo "🔄 Invalidating CloudFront cache..."
  aws cloudfront create-invalidation \
    --distribution-id $DISTRIBUTION_ID \
    --paths "/*"
  echo "✅ Cache invalidation started!"
fi

echo "🎉 Deployment complete!"
echo "Your app is now live at: https://your-cloudfront-domain.cloudfront.net"
