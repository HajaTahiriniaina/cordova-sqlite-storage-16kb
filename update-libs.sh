#!/bin/bash
# Script pour mettre à jour les bibliothèques natives 16KB

set -e

echo "🔄 Updating 16KB native libraries..."

ANDROID_NDK=~/Library/Android/sdk/ndk/29.0.13846066
TEMP_DIR=/tmp/sqlite-16kb-update
PLUGIN_DIR=$(pwd)

# Vérifier qu'on est dans le bon dossier
if [ ! -f "plugin.xml" ]; then
    echo "❌ Error: Run this script from the plugin root directory"
    exit 1
fi

# Vérifier NDK
if [ ! -d "$ANDROID_NDK" ]; then
    echo "❌ NDK not found at $ANDROID_NDK"
    exit 1
fi

export ANDROID_NDK_HOME=$ANDROID_NDK
export PATH=$ANDROID_NDK:$PATH

# Créer répertoire temporaire
mkdir -p $TEMP_DIR
cd $TEMP_DIR

# Compiler android-sqlite-ndk-native-driver
echo "📦 Compiling android-sqlite-ndk-native-driver..."
rm -rf android-sqlite-ndk-native-driver
git clone --quiet --depth 1 https://github.com/brodybits/android-sqlite-ndk-native-driver.git
cd android-sqlite-ndk-native-driver

git submodule update --init --quiet

echo "   Building with NDK r29..."
$ANDROID_NDK/ndk-build clean > /dev/null 2>&1 || true
$ANDROID_NDK/ndk-build

if [ ! -d "libs" ]; then
    echo "❌ Build failed"
    exit 1
fi

mv libs lib
jar cf sqlite-ndk-native-driver.jar lib

echo "✅ JAR created: $(du -h sqlite-ndk-native-driver.jar | cut -f1)"

# Copier dans le plugin
echo "📋 Copying to plugin..."
cp sqlite-ndk-native-driver.jar \
   $PLUGIN_DIR/node_modules/cordova-sqlite-storage-dependencies/libs/

# Nettoyer
cd $PLUGIN_DIR
rm -rf $TEMP_DIR

echo ""
echo "✅ Libraries updated successfully!"
echo ""
echo "Next steps:"
echo "  1. git add node_modules/cordova-sqlite-storage-dependencies/libs/"
echo "  2. git commit -m 'Update 16KB native libraries'"
echo "  3. git push"
