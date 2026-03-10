#!/bin/bash
# =============================================================================
# build_ios_framework.sh
# Builds the Flutter module as XCFrameworks and packages them for CocoaPods.
# Large binaries (zip) are tracked via Git LFS.
#
# Usage:
#   ./scripts/build_ios_framework.sh [version]
#   Example: ./scripts/build_ios_framework.sh 1.0.0
#
# Output:
#   dist/TestSDK-<version>.zip  (tracked by LFS; also upload to GitHub Releases)
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
# 0. Check prerequisites
# --------------------------------------------------------------------------- #
if ! command -v git-lfs &>/dev/null; then
  echo "ERROR: git-lfs is not installed."
  echo "       Install with: brew install git-lfs && git lfs install"
  exit 1
fi

if ! command -v flutter &>/dev/null; then
  echo "ERROR: flutter is not installed or not in PATH."
  exit 1
fi

# --------------------------------------------------------------------------- #
# 1. Clean previous build
# --------------------------------------------------------------------------- #
echo "[1/6] Cleaning previous build..."
rm -rf "$BUILD_DIR" "$ZIP_STAGING"
mkdir -p "$DIST_DIR"

# --------------------------------------------------------------------------- #
# 2. Build release XCFrameworks
# --------------------------------------------------------------------------- #
echo "[2/6] Running flutter build ios-framework (release)..."
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
echo "[3/6] Staging zip contents..."
mkdir -p "$ZIP_STAGING/Frameworks"
mkdir -p "$ZIP_STAGING/ios/Classes"

# Copy XCFrameworks (release slice)
cp -R "$BUILD_DIR/Release/Flutter.xcframework" "$ZIP_STAGING/Frameworks/"
cp -R "$BUILD_DIR/Release/App.xcframework"     "$ZIP_STAGING/Frameworks/"

# Include FlutterPluginRegistrant if plugins are present
if [ -d "$BUILD_DIR/Release/FlutterPluginRegistrant.xcframework" ]; then
  cp -R "$BUILD_DIR/Release/FlutterPluginRegistrant.xcframework" "$ZIP_STAGING/Frameworks/"
  echo "      Included FlutterPluginRegistrant.xcframework"
fi

# Copy Swift wrapper, podspec, LICENSE
cp -R "$ROOT_DIR/ios/Classes/." "$ZIP_STAGING/ios/Classes/"
cp "$ROOT_DIR/TestSDK.podspec"  "$ZIP_STAGING/"
cp "$ROOT_DIR/LICENSE"          "$ZIP_STAGING/" 2>/dev/null || true

# --------------------------------------------------------------------------- #
# 4. Create zip
# --------------------------------------------------------------------------- #
echo "[4/6] Creating $ZIP_NAME..."
cd "$ZIP_STAGING"
zip -r "$DIST_DIR/$ZIP_NAME" .
echo "      Created: dist/$ZIP_NAME  ($(du -sh "$DIST_DIR/$ZIP_NAME" | cut -f1))"

# --------------------------------------------------------------------------- #
# 5. Compute SHA256 (required for podspec :sha256 field)
# --------------------------------------------------------------------------- #
echo "[5/6] SHA256 checksum:"
SHA256=$(shasum -a 256 "$DIST_DIR/$ZIP_NAME" | awk '{print $1}')
echo "      $SHA256"

# Write checksum to a sidecar file for easy reference
echo "$SHA256" > "$DIST_DIR/$ZIP_NAME.sha256"

# --------------------------------------------------------------------------- #
# 6. Stage dist/zip for Git LFS
# --------------------------------------------------------------------------- #
echo "[6/6] Tracking dist/ with Git LFS..."
cd "$ROOT_DIR"

# Ensure LFS is initialised in this repo
git lfs install --local --skip-smudge 2>/dev/null || true

# Track the zip pattern (idempotent — .gitattributes already has it)
git lfs track "dist/*.zip" 2>/dev/null || true

# Stage the zip via LFS
git add .gitattributes
git add "dist/$ZIP_NAME"
echo "      dist/$ZIP_NAME is now staged under Git LFS."
echo "      Run 'git lfs ls-files' to verify."

echo ""
echo "============================================"
echo "  DONE! Next steps:"
echo "============================================"
echo ""
echo "  1. Commit & push (LFS uploads the zip automatically):"
echo "     git add ."
echo "     git commit -m 'Release v$VERSION'"
echo "     git push   # LFS binary uploads here"
echo ""
echo "  2. Create a GitHub Release tagged v$VERSION and ALSO upload"
echo "     dist/$ZIP_NAME as a release asset (CocoaPods :http source)."
echo ""
echo "  3. Update TestSDK.podspec:"
echo "     :http  => 'https://github.com/YOURUSERNAME/test_sdk/releases/download/v$VERSION/$ZIP_NAME'"
echo "     :sha256 => '$SHA256'"
echo ""
echo "  4. Validate the podspec:"
echo "     pod spec lint TestSDK.podspec --allow-warnings"
echo ""
echo "  5. Register on CocoaPods trunk (first time only):"
echo "     pod trunk register dev@alfapay.com 'AlfaPay' --description='MacBook'"
echo "     (confirm the email sent to you)"
echo ""
echo "  6. Publish:"
echo "     pod trunk push TestSDK.podspec --allow-warnings"
echo ""
echo "  7. Host apps install via Podfile:"
echo "     pod 'TestSDK', '~> $VERSION'"
echo ""
