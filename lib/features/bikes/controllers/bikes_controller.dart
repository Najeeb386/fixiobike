import 'package:get/get.dart';
import '../models/bike_model.dart';

/// Bikes Controller for GetX state management
class BikesController extends GetxController {
  // Observable list of bikes
  final RxList<Bike> bikes = <Bike>[].obs;
  
  // Selected bike ID
  final RxString selectedBikeId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with sample data
    _loadSampleBikes();
  }

  void _loadSampleBikes() {
    bikes.value = [
      Bike(
        id: '1',
        brand: 'Honda',
        model: 'CB 150',
        year: 2023,
        bodyType: 'Sports',
        plateNumber: 'ABC-1234',
        isSelected: true,
      ),
      Bike(
        id: '2',
        brand: 'Yamaha',
        model: 'YBR 125',
        year: 2022,
        bodyType: 'Commuter',
        plateNumber: 'XYZ-5678',
        isSelected: false,
      ),
      Bike(
        id: '3',
        brand: 'Suzuki',
        model: 'GD 110',
        year: 2021,
        bodyType: 'Standard',
        plateNumber: 'LMN-9012',
        isSelected: false,
      ),
    ];
    
    // Set initial selected bike
    final selectedBike = bikes.firstWhereOrNull((bike) => bike.isSelected);
    if (selectedBike != null) {
      selectedBikeId.value = selectedBike.id;
    }
  }

  // Get selected bike
  Bike? get selectedBike {
    return bikes.firstWhereOrNull((bike) => bike.id == selectedBikeId.value);
  }

  // Select a bike
  void selectBike(String bikeId) {
    selectedBikeId.value = bikeId;
    bikes.value = bikes.map((bike) {
      return bike.copyWith(isSelected: bike.id == bikeId);
    }).toList();
  }

  // Add a new bike
  void addBike(Bike bike) {
    bikes.add(bike);
  }

  // Update an existing bike
  void updateBike(Bike bike) {
    final index = bikes.indexWhere((b) => b.id == bike.id);
    if (index != -1) {
      bikes[index] = bike;
    }
  }

  // Delete a bike
  void deleteBike(String bikeId) {
    bikes.removeWhere((bike) => bike.id == bikeId);
    
    // If deleted bike was selected, select first available
    if (selectedBikeId.value == bikeId && bikes.isNotEmpty) {
      selectBike(bikes.first.id);
    }
  }
}
