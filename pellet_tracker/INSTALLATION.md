# Guide d'Installation - Pellet Tracker 🔥

## Prérequis

### Installation de Flutter

1. **Téléchargez Flutter SDK**
   - Visitez : https://flutter.dev/docs/get-started/install
   - Choisissez votre système d'exploitation (Windows, macOS, Linux)

2. **Configurez Flutter**
   ```bash
   # Ajoutez Flutter au PATH (exemple Linux/macOS)
   export PATH="$PATH:`pwd`/flutter/bin"

   # Vérifiez l'installation
   flutter doctor
   ```

3. **Installez les dépendances système**
   - **Android** : Android Studio + Android SDK
   - **iOS** : Xcode (macOS uniquement)

## Installation du Projet

### 1. Clonez le dépôt ou copiez le dossier pellet_tracker

```bash
cd pellet_tracker
```

### 2. Installez les dépendances

```bash
flutter pub get
```

### 3. Vérifiez la configuration

```bash
flutter doctor -v
```

Résolvez tous les problèmes signalés par Flutter Doctor.

## Lancement de l'Application

### Sur Émulateur/Simulateur

**Android :**
```bash
# Lancez un émulateur depuis Android Studio
# ou via ligne de commande
flutter emulators --launch <emulator_id>

# Lancez l'app
flutter run
```

**iOS (macOS uniquement) :**
```bash
# Ouvrez le simulateur
open -a Simulator

# Lancez l'app
flutter run
```

### Sur Appareil Physique

**Android :**
1. Activez le mode développeur sur votre appareil
2. Activez le débogage USB
3. Connectez votre appareil
4. ```bash
   flutter devices  # Vérifiez que l'appareil est détecté
   flutter run
   ```

**iOS :**
1. Connectez votre iPhone/iPad
2. Faites confiance à votre ordinateur
3. ```bash
   flutter run
   ```

## Build pour Production

### Android (APK)

```bash
# Build APK
flutter build apk --release

# Le fichier sera dans : build/app/outputs/flutter-apk/app-release.apk
```

### Android (App Bundle pour Play Store)

```bash
flutter build appbundle --release

# Le fichier sera dans : build/app/outputs/bundle/release/app-release.aab
```

### iOS (pour App Store)

```bash
flutter build ios --release

# Ensuite, ouvrez Xcode pour soumettre à l'App Store
open ios/Runner.xcworkspace
```

## Problèmes Courants

### Erreur : "Unable to find bundled Java version"
```bash
# Dans Android Studio : File > Project Structure > SDK Location
# Vérifiez que le JDK est configuré
```

### Erreur Gradle
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Problèmes de dépendances
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

## Configuration Avancée

### Modifier le nom de l'app

1. **Android** : `android/app/src/main/AndroidManifest.xml`
   ```xml
   <application android:label="Votre Nom">
   ```

2. **iOS** : `ios/Runner/Info.plist`
   ```xml
   <key>CFBundleDisplayName</key>
   <string>Votre Nom</string>
   ```

### Modifier l'icône de l'app

Utilisez le package `flutter_launcher_icons` :

```yaml
# pubspec.yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_icons:
  android: true
  ios: true
  image_path: "assets/icon.png"
```

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

## Support

Pour toute question ou problème :
- Consultez la documentation Flutter : https://flutter.dev/docs
- GitHub Issues : https://github.com/votre-repo/issues
- Contact : contact@doz-technology.com

---
Développé par Steeve SAINT MAXIN - DOZ Technology
