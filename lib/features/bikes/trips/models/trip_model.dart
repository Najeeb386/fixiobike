/// Trip Model for Fixio Bike App
/// Represents a trip taken by a user's vehicle
class Trip {
  final String id;
  final String vehicleName;
  final String plateNumber;
  final String pickupLocation;
  final String dropoffLocation;
  final DateTime pickupDate;
  final String? tripPurpose;
  final String? cargoDetails;
  final String? note;
  final String status;

  Trip({
    required this.id,
    required this.vehicleName,
    required this.plateNumber,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupDate,
    this.tripPurpose,
    this.cargoDetails,
    this.note,
    this.status = 'In Progress',
  });

  Trip copyWith({
    String? id,
    String? vehicleName,
    String? plateNumber,
    String? pickupLocation,
    String? dropoffLocation,
    DateTime? pickupDate,
    String? tripPurpose,
    String? cargoDetails,
    String? note,
    String? status,
  }) {
    return Trip(
      id: id ?? this.id,
      vehicleName: vehicleName ?? this.vehicleName,
      plateNumber: plateNumber ?? this.plateNumber,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      pickupDate: pickupDate ?? this.pickupDate,
      tripPurpose: tripPurpose ?? this.tripPurpose,
      cargoDetails: cargoDetails ?? this.cargoDetails,
      note: note ?? this.note,
      status: status ?? this.status,
    );
  }
}

/// Available trip purposes
class TripPurposes {
  static const List<String> purposes = [
    'Business',
    'Personal',
    'Delivery',
    'Tourism',
    'Commute',
    'Emergency',
    'Other',
  ];
}
