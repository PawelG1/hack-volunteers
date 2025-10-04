#!/bin/bash

# Hack Volunteers - Quick Development Script
# Przyspiesza development poprzez hot reload i skipping buildów

echo "🚀 Hack Volunteers - Quick Dev Mode"
echo ""

# Sprawdź czy urządzenie jest podłączone
if ! flutter devices | grep -q "device"; then
    echo "❌ Brak podłączonego urządzenia!"
    echo "Podłącz urządzenie lub uruchom emulator"
    exit 1
fi

echo "✅ Urządzenie wykryte"
echo ""

# Opcje budowania
echo "Wybierz tryb:"
echo "1) Debug (szybki build, hot reload)"
echo "2) Profile (sprawdzanie wydajności)"
echo "3) Release (pełna optymalizacja - wolny build)"
echo ""
read -p "Wybór (1-3): " choice

case $choice in
    1)
        echo "🔥 Uruchamiam w trybie DEBUG..."
        flutter run --debug
        ;;
    2)
        echo "⚡ Uruchamiam w trybie PROFILE..."
        flutter run --profile
        ;;
    3)
        echo "🚀 Uruchamiam w trybie RELEASE..."
        flutter run --release
        ;;
    *)
        echo "❌ Nieprawidłowy wybór"
        exit 1
        ;;
esac
