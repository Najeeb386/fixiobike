/// Bike Model for Fixio Bike App
/// Represents a user's vehicle/bike
class Bike {
  final String id;
  final String brand;
  final String model;
  final int year;
  final String bodyType;
  final String plateNumber;
  final bool isSelected;

  Bike({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.bodyType,
    required this.plateNumber,
    this.isSelected = false,
  });

  Bike copyWith({
    String? id,
    String? brand,
    String? model,
    int? year,
    String? bodyType,
    String? plateNumber,
    bool? isSelected,
  }) {
    return Bike(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      bodyType: bodyType ?? this.bodyType,
      plateNumber: plateNumber ?? this.plateNumber,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

/// Available bike brands in the app
class BikeBrands {
  static const List<String> brands = [
    'Honda',
    'Yamaha',
    'Suzuki',
    'Kawasaki',
    'Harley-Davidson',
    'BMW',
    'TVS',
    'Bajaj',
    'Hero',
    'Royal Enfield',
  ];
}

/// Available bike models grouped by brand
class BikeModels {
  static const Map<String, List<String>> modelsByBrand = {
    'Honda': ['CB 150', 'CB 125F', 'CD 70', 'CG 125', 'Spacy 110', 'Activa 110'],
    'Yamaha': ['YBR 125', 'YBR 150', 'Crypton 110', 'Ray ZR 125', 'FZ 150'],
    'Suzuki': ['GD 110', 'GS 150', 'Hayate 110', 'Burgman 125', 'Access 125'],
    'Kawasaki': ['Ninja 400', 'Z400', 'Versys 650', ' Vulcan S'],
    'Harley-Davidson': ['Iron 883', 'Forty-Eight', 'Street 750', 'Fat Boy'],
    'BMW': ['G 310 R', 'G 310 GS', 'F 900 R'],
    'TVS': ['Apache 160', 'Apache 200', 'Apache 310', 'NTORQ 125'],
    'Bajaj': ['Pulsar 125', 'Pulsar 150', 'Pulsar 200NS', 'Dominar 400'],
    'Hero': ['Splendor Plus', 'Glamour 125', 'Passion Pro', 'HF 100', 'Xtreme 150'],
    'Royal Enfield': ['Classic 350', 'Bullet 350', 'Meteor 350', 'Himalayan 410'],
  };

  static List<String> getModelsForBrand(String brand) {
    return modelsByBrand[brand] ?? [];
  }
}

/// Available body types for bikes
class BikeBodyTypes {
  static const List<String> bodyTypes = [
    'Standard',
    'Sports',
    'Cruiser',
    'Scooter',
    'Commuter',
    'Naked',
    'Adventure',
    'Touring',
    'Retro',
    'Off-Road',
  ];
}

/// Available years for bike selection
class BikeYears {
  static List<int> getYears() {
    final currentYear = DateTime.now().year;
    return List.generate(25, (index) => currentYear - index);
  }
}
