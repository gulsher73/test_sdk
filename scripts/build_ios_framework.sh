#!/bin/bash
# =============================================================================
# build_ios_framework.sh
# Builds the Flutter module as XCFrameworks and packages them for CocoaPods.
#
# Usage:
#   ./scripts/build_ios_framework.sh [version]
#   Example: ./scripts/build_ios_framework.sh 1.0.0
#
# Output:
#   dist/TestSDK-<version>.zip  (upload this to GitHub Releases)
# =============================================================================

set -e

VERSION="${1:-1.0.0}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build/ios_frameworks"
DIST_DIR="$ROOT_DIR/dist"
ZIP_STAGING="$ROOT_DIR/build/zip_staging"
ZIP_NAME="TestSDK-$VERSION.zip"

echo "============================================"
echo "  Building TestSDK iOS XCFrameworks v$VERSION"
echo "============================================"

# --------------------------------------------------------------------------- #
# 1. Clean previous build
# --------------------------------------------------------------------------- #
echo "[1/5] Cleaning previous build..."
rm -rf "$BUILD_DIR" "$ZIP_STAGING"
mkdir -p "$DIST_DIR"

# --------------------------------------------------------------------------- #
# 2. Build release XCFrameworks
# --------------------------------------------------------------------------- #
echo "[2/5] Running flutter build ios-framework (release)..."
cd "$ROOT_DIR"
flutter build ios-framework \
  --release \
  --xcframework \
  --no-profile \
  --output="$BUILD_DIR"

echo "      Build output:"
ls "$BUILD_DIR/Release/"

# --------------------------------------------------------------------------- #
# 3. Stage zip contents
# --------------------------------------------------------------------------- #
echo "[3/5] Staging zip contents..."
mkdir -p "$ZIP_STAGING/Frameworks"
mkdir -p "$ZIP_STAGING/ios/Classes"

# Copy XCFrameworks (release slice)
cp -R "$BUILD_DIR/Release/Flutter.xcframework"              "$ZIP_STAGING/Frameworks/"
cp -R "$BUILD_DIR/Release/App.xcframework"                  "$ZIP_STAGING/Frameworks/"

# If FlutterPluginRegistrant exists (plugins present), include it too
if [ -d "$BUILD_DIR/Release/FlutterPluginRegistrant.xcframework" ]; then
  cp -R "$BUILD_DIR/Release/FlutterPluginRegistrant.xcframework" "$ZIP_STAGING/Frameworks/"
  echo "      Included FlutterPluginRegistrant.xcframework"
fi

# Copy Swift wrapper
cp -R "$ROOT_DIR/ios/Classes/." "$ZIP_STAGING/ios/Classes/"

# Copy podspec + LICENSE
cp "$ROOT_DIR/TestSDK.podspec" "$ZIP_STAGING/"
cp "$ROOT_DIR/LICENSE"         "$ZIP_STAGING/" 2>/dev/null || true

# --------------------------------------------------------------------------- #
# 4. Create zip
# --------------------------------------------------------------------------- #
echo "[4/5] Creating $ZIP_NAME..."
cd "$ZIP_STAGING"
zip -r "$DIST_DIR/$ZIP_NAME" .
echo "      Created: dist/$ZIP_NAME"

# --------------------------------------------------------------------------- #
# 5. Compute checksum (for podspec :sha256 if needed)
# --------------------------------------------------------------------------- #
echo "[5/5] SHA256 checksum:"
shasum -a 256 "$DIST_DIR/$ZIP_NAME"

echo ""
echo "============================================"
echo "  DONE! Next steps:"
echo "============================================"
echo ""
echo "  1. Push your code to GitHub:"
echo "     git add . && git commit -m 'Release v$VERSION' && git push"
echo ""
echo "  2. Create a GitHub Release tagged v$VERSION and upload:"
echo "     dist/$ZIP_NAME"
echo ""
echo "  3. Update TestSDK.podspec — set the :http URL to the"
echo "     GitHub Release download link for $ZIP_NAME"
echo ""
echo "  4. Validate the podspec:"
echo "     pod spec lint TestSDK.podspec --allow-warnings"
echo ""
echo "  5. Register on CocoaPods trunk (first time only):"
echo "     pod trunk register dev@alfapay.com 'AlfaPay' --description='MacBook'"
echo "     (confirm the email link)"
echo ""
echo "  6. Publish to CocoaPods trunk:"
echo "     pod trunk push TestSDK.podspec --allow-warnings"
echo ""
echo "  7. Host apps install via Podfile:"
echo "     pod 'TestSDK', '~> $VERSION'"
echo ""
