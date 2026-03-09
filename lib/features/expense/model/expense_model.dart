/// Expense Model for Fixio Bike App
/// Represents a general expense record
class Expense {
  final String id;
  final String bikeId;
  final String bikeBrand;
  final String bikeModel;
  final String plateNumber;
  final DateTime dateTime;
  final double amount;
  final String details;
  final String? note;

  Expense({
    required this.id,
    required this.bikeId,
    required this.bikeBrand,
    required this.bikeModel,
    required this.plateNumber,
    required this.dateTime,
    required this.amount,
    required this.details,
    this.note,
  });

  Expense copyWith({
    String? id,
    String? bikeId,
    String? bikeBrand,
    String? bikeModel,
    String? plateNumber,
    DateTime? dateTime,
    double? amount,
    String? details,
    String? note,
  }) {
    return Expense(
      id: id ?? this.id,
      bikeId: bikeId ?? this.bikeId,
      bikeBrand: bikeBrand ?? this.bikeBrand,
      bikeModel: bikeModel ?? this.bikeModel,
      plateNumber: plateNumber ?? this.plateNumber,
      dateTime: dateTime ?? this.dateTime,
      amount: amount ?? this.amount,
      details: details ?? this.details,
      note: note ?? this.note,
    );
  }
}

/// Expense categories/types
class ExpenseTypes {
  static const List<String> types = [
    'Service',
    'Repair',
    'Maintenance',
    'Oil Change',
    'Tire',
    'Battery',
    'Brake',
    'Chain',
    'Spark Plug',
    'Filter',
    'Other',
  ];
}
