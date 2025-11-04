import 'package:uuid/uuid.dart';

enum TransactionType {
  achat, // Ajout de stock
  consommation, // Retrait de stock
}

class PelletTransaction {
  final String id;
  final TransactionType type;
  final double quantity; // en kg
  final DateTime date;
  final String? note;
  final double? pricePerUnit; // Prix par kg (optionnel)

  PelletTransaction({
    String? id,
    required this.type,
    required this.quantity,
    required this.date,
    this.note,
    this.pricePerUnit,
  }) : id = id ?? const Uuid().v4();

  // Sérialisation JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'quantity': quantity,
      'date': date.toIso8601String(),
      'note': note,
      'pricePerUnit': pricePerUnit,
    };
  }

  // Désérialisation JSON
  factory PelletTransaction.fromJson(Map<String, dynamic> json) {
    return PelletTransaction(
      id: json['id'] as String,
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      quantity: (json['quantity'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String?,
      pricePerUnit: json['pricePerUnit'] != null
          ? (json['pricePerUnit'] as num).toDouble()
          : null,
    );
  }

  // Copie avec modifications
  PelletTransaction copyWith({
    String? id,
    TransactionType? type,
    double? quantity,
    DateTime? date,
    String? note,
    double? pricePerUnit,
  }) {
    return PelletTransaction(
      id: id ?? this.id,
      type: type ?? this.type,
      quantity: quantity ?? this.quantity,
      date: date ?? this.date,
      note: note ?? this.note,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
    );
  }

  // Calcul du coût total
  double? get totalCost {
    if (pricePerUnit == null) return null;
    return quantity * pricePerUnit!;
  }

  @override
  String toString() {
    return 'PelletTransaction(id: $id, type: ${type.name}, quantity: $quantity kg, date: $date)';
  }
}
