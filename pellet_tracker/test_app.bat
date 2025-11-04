@echo off
REM Script de test de l'application Pellet Tracker pour Windows

echo.
echo ================================
echo 🔥 Pellet Tracker - Test
echo ================================
echo.

REM Vérification de Flutter
echo 1️⃣ Vérification de Flutter...
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Flutter n'est pas installé!
    echo.
    echo Installez Flutter depuis: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

flutter --version | findstr /R "Flutter"
echo ✅ Flutter détecté
echo.

REM Installation des dépendances
echo 2️⃣ Installation des dépendances...
call flutter pub get
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Erreur lors de l'installation
    pause
    exit /b 1
)

echo ✅ Dépendances installées
echo.

REM Affichage des appareils
echo 3️⃣ Appareils disponibles:
call flutter devices
echo.

echo ================================
echo Choisissez une option:
echo.
echo 1) 🌐 Lancer sur Chrome (Web)
echo 2) 📱 Lancer sur Android
echo 3) 📊 Analyser le code
echo 4) ❌ Quitter
echo.

set /p choice="Votre choix (1-4): "

if "%choice%"=="1" (
    echo.
    echo 🚀 Lancement sur Chrome...
    call flutter run -d chrome
) else if "%choice%"=="2" (
    echo.
    echo 🚀 Lancement sur Android...
    call flutter run
) else if "%choice%"=="3" (
    echo.
    echo 📊 Analyse du code...
    call flutter analyze
) else if "%choice%"=="4" (
    echo.
    echo 👋 Au revoir!
    exit /b 0
) else (
    echo.
    echo ❌ Option invalide
    pause
    exit /b 1
)

pause
