# 🚀 Quick Start - Pellet Tracker

## Test Rapide (5 minutes)

### Prérequis
✅ Flutter SDK installé → https://flutter.dev/docs/get-started/install

### Méthode 1 : Script Automatique (Recommandé)

**Windows :**
```cmd
cd pellet_tracker
test_app.bat
```

**Linux/macOS :**
```bash
cd pellet_tracker
./test_app.sh
```

Le script vous guidera étape par étape.

### Méthode 2 : Manuelle

#### A. Test Web (Plus Rapide)

```bash
cd pellet_tracker

# 1. Installer les dépendances
flutter pub get

# 2. Lancer sur Chrome
flutter run -d chrome
```

L'app s'ouvrira automatiquement dans Chrome en mode responsive mobile.

#### B. Test sur Android

**Option 1 : Émulateur**
```bash
# Lancez Android Studio > AVD Manager > Créez/Lancez un émulateur

# Puis
cd pellet_tracker
flutter run
```

**Option 2 : Téléphone physique**
```bash
# 1. Activez le mode développeur sur votre téléphone
# 2. Activez le débogage USB
# 3. Connectez via USB

# 4. Vérifiez
flutter devices

# 5. Lancez
cd pellet_tracker
flutter run
```

#### C. Test sur iOS (macOS uniquement)

```bash
# 1. Ouvrez le simulateur
open -a Simulator

# 2. Lancez l'app
cd pellet_tracker
flutter run
```

## 🎯 Première Utilisation

Une fois l'app lancée :

1. **Ajoutez votre stock initial**
   - Bouton vert "Ajouter du stock"
   - Ex: 66 sacs de 15kg à 7€/sac

2. **Enregistrez une consommation**
   - Bouton orange "Enregistrer consommation"
   - Ex: 2 sacs cette semaine

3. **Consultez les statistiques**
   - Icône 📊 en haut à droite
   - Visualisez vos graphiques

## 🔧 Dépannage Rapide

**"Flutter command not found"**
```bash
# Flutter n'est pas dans le PATH
# Installez depuis: https://flutter.dev
```

**"No devices found"**
```bash
# Pour tester sur web:
flutter run -d chrome

# Vérifiez les appareils disponibles:
flutter devices
```

**Erreurs de dépendances**
```bash
flutter clean
flutter pub get
```

**Émulateur lent**
```bash
# Utilisez la version web pour tester rapidement:
flutter run -d chrome
```

## 📱 Build Production

### APK Android (Installation directe)
```bash
flutter build apk --release

# Fichier généré dans:
# build/app/outputs/flutter-apk/app-release.apk
```

Transférez le fichier APK sur votre téléphone et installez-le.

### App Bundle (Pour Play Store)
```bash
flutter build appbundle --release
```

## 💡 Astuces

**Hot Reload**
- Pendant le développement, tapez `r` pour recharger
- Tapez `R` pour redémarrer complètement

**Logs**
```bash
flutter run -v  # Mode verbose pour debug
```

**Tests**
```bash
flutter test  # Lancer les tests unitaires
flutter analyze  # Analyser le code
```

## 🆘 Besoin d'Aide ?

1. Documentation complète : `INSTALLATION.md`
2. Guide utilisateur : `GUIDE_UTILISATEUR.md`
3. Flutter Docs : https://docs.flutter.dev
4. Contact : contact@doz-technology.com

---

**Temps estimé de premier test : 5-10 minutes** ⚡
