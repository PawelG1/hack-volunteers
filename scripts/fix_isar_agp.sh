#!/bin/bash
# Fix Isar Flutter Libs compatibility with Android Gradle Plugin 8.x
# This script adds namespace to build.gradle and removes package from AndroidManifest.xml

set -e

echo "🔧 Fixing Isar Flutter Libs AGP compatibility..."

# Find isar_flutter_libs in pub cache
ISAR_PATH=$(find ~/.pub-cache -type d -name "isar_flutter_libs-*" | head -1)

if [ -z "$ISAR_PATH" ]; then
    echo "❌ Error: isar_flutter_libs not found in pub cache"
    echo "   Run 'flutter pub get' first"
    exit 1
fi

echo "📦 Found: $ISAR_PATH"

# Add namespace to build.gradle if not present
BUILD_GRADLE="$ISAR_PATH/android/build.gradle"
if grep -q "namespace" "$BUILD_GRADLE"; then
    echo "✅ Namespace already present in build.gradle"
else
    echo "➕ Adding namespace to build.gradle..."
    sed -i '/android {/a\    namespace = "dev.isar.isar_flutter_libs"' "$BUILD_GRADLE"
    echo "✅ Namespace added"
fi

# Remove package from AndroidManifest.xml if present
MANIFEST="$ISAR_PATH/android/src/main/AndroidManifest.xml"
if grep -q "package=" "$MANIFEST"; then
    echo "➖ Removing package from AndroidManifest.xml..."
    sed -i 's/ *package="[^"]*"//' "$MANIFEST"
    echo "✅ Package removed"
else
    echo "✅ Package already removed from AndroidManifest.xml"
fi

echo ""
echo "🎉 Isar Flutter Libs fixed!"
echo "   You can now run: flutter clean && flutter pub get && flutter build"
