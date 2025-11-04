import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import '../models/statistics.dart';

class StorageService {
  static const String _transactionsKey = 'pellet_transactions';
  static const String _initialStockKey = 'initial_stock';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Initialisation
  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Sauvegarder toutes les transactions
  Future<void> saveTransactions(List<PelletTransaction> transactions) async {
    final jsonList = transactions.map((t) => t.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString(_transactionsKey, jsonString);
  }

  // Charger toutes les transactions
  List<PelletTransaction> loadTransactions() {
    final jsonString = _prefs.getString(_transactionsKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => PelletTransaction.fromJson(json))
        .toList();
  }

  // Ajouter une transaction
  Future<void> addTransaction(PelletTransaction transaction) async {
    final transactions = loadTransactions();
    transactions.add(transaction);
    // Trier par date (plus récent en premier)
    transactions.sort((a, b) => b.date.compareTo(a.date));
    await saveTransactions(transactions);
  }

  // Supprimer une transaction
  Future<void> deleteTransaction(String id) async {
    final transactions = loadTransactions();
    transactions.removeWhere((t) => t.id == id);
    await saveTransactions(transactions);
  }

  // Mettre à jour une transaction
  Future<void> updateTransaction(PelletTransaction transaction) async {
    final transactions = loadTransactions();
    final index = transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      transactions[index] = transaction;
      transactions.sort((a, b) => b.date.compareTo(a.date));
      await saveTransactions(transactions);
    }
  }

  // Calculer le stock actuel
  double calculateCurrentStock() {
    final transactions = loadTransactions();
    double stock = 0;

    for (var transaction in transactions) {
      if (transaction.type == TransactionType.achat) {
        stock += transaction.quantity;
      } else {
        stock -= transaction.quantity;
      }
    }

    return stock;
  }

  // Calculer les statistiques
  PelletStatistics calculateStatistics() {
    final transactions = loadTransactions();

    double totalAchats = 0;
    double totalConsommation = 0;
    double totalSpent = 0;
    bool hasPrice = false;

    for (var transaction in transactions) {
      if (transaction.type == TransactionType.achat) {
        totalAchats += transaction.quantity;
        if (transaction.pricePerUnit != null) {
          totalSpent += transaction.quantity * transaction.pricePerUnit!;
          hasPrice = true;
        }
      } else {
        totalConsommation += transaction.quantity;
      }
    }

    final currentStock = totalAchats - totalConsommation;

    // Calculer la consommation moyenne par jour
    double averageDaily = 0;
    if (transactions.isNotEmpty) {
      final consommations = transactions
          .where((t) => t.type == TransactionType.consommation)
          .toList();

      if (consommations.isNotEmpty) {
        final oldestDate = consommations.last.date;
        final daysDiff = DateTime.now().difference(oldestDate).inDays;

        if (daysDiff > 0) {
          averageDaily = totalConsommation / daysDiff;
        }
      }
    }

    // Estimation des jours restants
    int daysRemaining = 0;
    if (averageDaily > 0) {
      daysRemaining = (currentStock / averageDaily).round();
    } else {
      daysRemaining = 999; // Stock infini si pas de consommation
    }

    return PelletStatistics(
      currentStock: currentStock,
      totalAchats: totalAchats,
      totalConsommation: totalConsommation,
      averageDaily: averageDaily,
      averageWeekly: averageDaily * 7,
      daysRemaining: daysRemaining,
      totalSpent: hasPrice ? totalSpent : null,
      lastUpdate: DateTime.now(),
    );
  }

  // Obtenir les transactions par période
  List<PelletTransaction> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) {
    final transactions = loadTransactions();
    return transactions.where((t) {
      return t.date.isAfter(start.subtract(const Duration(days: 1))) &&
          t.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  // Obtenir les transactions du mois en cours
  List<PelletTransaction> getCurrentMonthTransactions() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);
    return getTransactionsByDateRange(start, end);
  }

  // Effacer toutes les données
  Future<void> clearAllData() async {
    await _prefs.remove(_transactionsKey);
  }
}
