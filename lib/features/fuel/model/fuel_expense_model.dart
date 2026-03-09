/// Fuel Expense Model for Fixio Bike App
/// Represents a fuel expense record
class FuelExpense {
  final String id;
  final String bikeId;
  final String bikeBrand;
  final String bikeModel;
  final String bikeBodyType;
  final String plateNumber;
  final DateTime dateTime;
  final int odometerReading;
  final double fuelQuantity;
  final double costPerUnit;
  final String vendor;
  final String? note;
  final String? imageUrl;
  final double totalPrice;

  FuelExpense({
    required this.id,
    required this.bikeId,
    required this.bikeBrand,
    required this.bikeModel,
    required this.bikeBodyType,
    required this.plateNumber,
    required this.dateTime,
    required this.odometerReading,
    required this.fuelQuantity,
    required this.costPerUnit,
    required this.vendor,
    this.note,
    this.imageUrl,
    double? totalPrice,
  }) : totalPrice = totalPrice ?? (fuelQuantity * costPerUnit);

  FuelExpense copyWith({
    String? id,
    String? bikeId,
    String? bikeBrand,
    String? bikeModel,
    String? bikeBodyType,
    String? plateNumber,
    DateTime? dateTime,
    int? odometerReading,
    double? fuelQuantity,
    double? costPerUnit,
    String? vendor,
    String? note,
    String? imageUrl,
    double? totalPrice,
  }) {
    return FuelExpense(
      id: id ?? this.id,
      bikeId: bikeId ?? this.bikeId,
      bikeBrand: bikeBrand ?? this.bikeBrand,
      bikeModel: bikeModel ?? this.bikeModel,
      bikeBodyType: bikeBodyType ?? this.bikeBodyType,
      plateNumber: plateNumber ?? this.plateNumber,
      dateTime: dateTime ?? this.dateTime,
      odometerReading: odometerReading ?? this.odometerReading,
      fuelQuantity: fuelQuantity ?? this.fuelQuantity,
      costPerUnit: costPerUnit ?? this.costPerUnit,
      vendor: vendor ?? this.vendor,
      note: note ?? this.note,
      imageUrl: imageUrl ?? this.imageUrl,
      totalPrice: totalPrice ?? (fuelQuantity! * costPerUnit!),
    );
  }
}
