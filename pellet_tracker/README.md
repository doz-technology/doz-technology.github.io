# Pellet Tracker 🔥

Application Flutter pour suivre votre consommation et stock de pellets pendant l'hiver.

> **Ne manquez plus jamais de pellets !** Suivez votre stock en temps réel, analysez votre consommation et planifiez vos achats intelligemment.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green)]()
[![License](https://img.shields.io/badge/License-MIT-blue)]()

## ✨ Fonctionnalités

### 📊 Tableau de Bord Intelligent
- **Stock en temps réel** : Visualisation instantanée en kg et nombre de sacs
- **Alertes visuelles** : 🟢 Bon niveau / 🟠 Stock bas / 🔴 Critique
- **Estimation automatique** : Nombre de jours restants selon votre consommation
- **Statistiques clés** : Consommation moyenne, achats totaux, dépenses

### ➕ Gestion des Achats
- Ajout rapide en **sacs** (15kg) ou **kilogrammes**
- Suivi des prix pour analyse budgétaire
- Historique complet avec dates et notes
- Calcul automatique du stock total

### 📈 Analyse & Statistiques
- **Graphique circulaire** : Répartition stock/consommation
- **Graphique en barres** : Évolution mensuelle
- **Consommation moyenne** : Calcul automatique jour/semaine
- **Tendances** : Identifiez vos pics de consommation

### 💾 Données Sécurisées
- Sauvegarde locale automatique
- Pas besoin de connexion internet
- Vos données restent privées
- Export/Import (à venir)

## 🚀 Démarrage Rapide

### Installation Express

**Prérequis :** Flutter SDK ([Installer Flutter](https://flutter.dev/docs/get-started/install))

```bash
cd pellet_tracker

# Méthode 1 : Script automatique
./test_app.sh          # Linux/macOS
test_app.bat           # Windows

# Méthode 2 : Commandes manuelles
flutter pub get
flutter run -d chrome  # Test web rapide
```

📖 **Guide complet** : [`QUICK_START.md`](QUICK_START.md)

## 📱 Plateformes Supportées

- ✅ **Android** (API 21+) - Android 5.0+
- ✅ **iOS** (12+)
- ✅ **Web** (mode responsive)
- 🔜 **Desktop** (Windows, macOS, Linux)

## 📸 Captures d'écran

### Écran d'Accueil
- Vue d'ensemble du stock actuel
- Indicateurs visuels de niveau
- Statistiques résumées

### Ajout de Stock / Consommation
- Interface intuitive
- Conversion automatique sacs ↔ kg
- Suivi optionnel des prix

### Statistiques & Graphiques
- Évolution mensuelle
- Répartition visuelle
- Analyse des tendances

## 🛠️ Technologies

| Technologie | Usage |
|-------------|-------|
| **Flutter** | Framework cross-platform |
| **Dart** | Langage de programmation |
| **Material Design 3** | Interface utilisateur |
| **SharedPreferences** | Stockage local |
| **fl_chart** | Graphiques interactifs |
| **intl** | Internationalisation (FR) |

## 📚 Documentation

- 📖 [Quick Start](QUICK_START.md) - Démarrage en 5 minutes
- 🔧 [Installation Complète](INSTALLATION.md) - Guide détaillé
- 👤 [Guide Utilisateur](GUIDE_UTILISATEUR.md) - Tutoriel complet

## 🏗️ Structure du Projet

```
lib/
├── main.dart                    # Point d'entrée
├── models/                      # Modèles de données
│   ├── transaction.dart         # Transaction (achat/consommation)
│   └── statistics.dart          # Statistiques calculées
├── services/                    # Logique métier
│   └── storage_service.dart     # Gestion du stockage
└── screens/                     # Interfaces utilisateur
    ├── home_screen.dart         # Écran principal
    ├── add_stock_screen.dart    # Ajout de stock
    ├── add_consumption_screen.dart
    ├── history_screen.dart      # Historique
    └── statistics_screen.dart   # Statistiques
```

## 🎯 Cas d'Usage

### Particuliers
- Suivi du stock de pellets pour l'hiver
- Optimisation des achats
- Prévision des besoins

### Professionnels
- Gestion multi-sites (à venir)
- Reporting client
- Optimisation logistique

## 🔜 Roadmap

- [ ] Export PDF des statistiques
- [ ] Notifications de stock bas
- [ ] Multi-utilisateurs / Synchronisation cloud
- [ ] Comparaison d'années
- [ ] Prédictions IA basées sur la météo
- [ ] Support multi-combustibles (bois, gaz, etc.)

## 🤝 Contribuer

Les contributions sont les bienvenues ! N'hésitez pas à :
- 🐛 Signaler des bugs
- 💡 Proposer des fonctionnalités
- 🔧 Soumettre des pull requests

## 📄 Licence

Ce projet est sous licence MIT. Voir [LICENSE](LICENSE) pour plus de détails.

## 👨‍💻 Auteur

**Steeve SAINT MAXIN**
- 🏢 [DOZ Technology](https://doz-technology.github.io)
- 💼 [LinkedIn](http://fr.linkedin.com/in/ssaintma)
- 📧 contact@doz-technology.com

---

Développé avec ❤️ par DOZ Technology | © 2024
