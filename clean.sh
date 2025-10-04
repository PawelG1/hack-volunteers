#!/bin/bash

# Skrypt do czyszczenia cache i rebuildowania projektu
# Użyj gdy build jest bardzo wolny lub występują dziwne błędy

echo "🧹 Czyszczenie cache Flutter..."
echo ""

# Flutter clean
echo "1️⃣ Flutter clean..."
flutter clean

# Usuwanie plików build
echo "2️⃣ Usuwanie folderów build..."
rm -rf build/
rm -rf android/build/
rm -rf android/app/build/
rm -rf ios/build/
rm -rf .dart_tool/

# Pobieranie zależności
echo "3️⃣ Pobieranie zależności..."
flutter pub get

# Czyszczenie Gradle cache (Android)
echo "4️⃣ Czyszczenie Gradle cache..."
cd android
./gradlew clean 2>/dev/null || echo "Gradle clean pominięty"
cd ..

echo ""
echo "✅ Cache wyczyszczony!"
echo "💡 Teraz uruchom: flutter run"
echo ""
