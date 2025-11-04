class PelletStatistics {
  final double currentStock; // Stock actuel en kg
  final double totalAchats; // Total des achats en kg
  final double totalConsommation; // Total de la consommation en kg
  final double averageDaily; // Consommation moyenne par jour
  final double averageWeekly; // Consommation moyenne par semaine
  final int daysRemaining; // Jours restants estimés
  final double? totalSpent; // Montant total dépensé
  final DateTime? lastUpdate; // Dernière mise à jour

  PelletStatistics({
    required this.currentStock,
    required this.totalAchats,
    required this.totalConsommation,
    required this.averageDaily,
    required this.averageWeekly,
    required this.daysRemaining,
    this.totalSpent,
    this.lastUpdate,
  });

  // Pourcentage du stock utilisé
  double get usagePercentage {
    if (totalAchats == 0) return 0;
    return (totalConsommation / totalAchats) * 100;
  }

  // Stock en sacs (15kg par sac standard)
  double get stockInBags {
    return currentStock / 15;
  }

  // Vérifie si le stock est critique (moins de 7 jours)
  bool get isCritical {
    return daysRemaining < 7;
  }

  // Vérifie si le stock est bas (moins de 14 jours)
  bool get isLow {
    return daysRemaining < 14;
  }

  @override
  String toString() {
    return 'PelletStatistics(stock: $currentStock kg, consommation moyenne: $averageDaily kg/jour)';
  }
}
