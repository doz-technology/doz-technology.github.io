#!/bin/bash

# Script de test de l'application Pellet Tracker

echo "🔥 Pellet Tracker - Script de Test"
echo "===================================="
echo ""

# Vérification de Flutter
echo "1️⃣ Vérification de Flutter..."
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter n'est pas installé!"
    echo ""
    echo "Installez Flutter depuis: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter détecté: $(flutter --version | head -n 1)"
echo ""

# Vérification des dépendances
echo "2️⃣ Installation des dépendances..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de l'installation des dépendances"
    exit 1
fi

echo "✅ Dépendances installées"
echo ""

# Vérification des appareils disponibles
echo "3️⃣ Recherche d'appareils disponibles..."
flutter devices

echo ""
echo "===================================="
echo "Choisissez une option de test:"
echo ""
echo "1) 🌐 Lancer sur Chrome (Web)"
echo "2) 📱 Lancer sur appareil/émulateur Android"
echo "3) 🍎 Lancer sur simulateur iOS (macOS uniquement)"
echo "4) 📊 Analyser le code"
echo "5) ❌ Quitter"
echo ""
read -p "Votre choix (1-5): " choice

case $choice in
    1)
        echo ""
        echo "🚀 Lancement sur Chrome..."
        flutter run -d chrome
        ;;
    2)
        echo ""
        echo "🚀 Lancement sur Android..."
        flutter run
        ;;
    3)
        echo ""
        echo "🚀 Lancement sur iOS..."
        flutter run -d ios
        ;;
    4)
        echo ""
        echo "📊 Analyse du code..."
        flutter analyze
        ;;
    5)
        echo ""
        echo "👋 Au revoir!"
        exit 0
        ;;
    *)
        echo ""
        echo "❌ Option invalide"
        exit 1
        ;;
esac
