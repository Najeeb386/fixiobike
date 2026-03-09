import 'package:get/get.dart';
import '../model/fuel_expense_model.dart';

/// Fuel Controller for GetX state management
class FuelController extends GetxController {
  // Observable list of fuel expenses
  final RxList<FuelExpense> fuelExpenses = <FuelExpense>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with sample data
    _loadSampleFuelExpenses();
  }

  void _loadSampleFuelExpenses() {
    fuelExpenses.value = [
      FuelExpense(
        id: '1',
        bikeId: '1',
        bikeBrand: 'Honda',
        bikeModel: 'CB 150',
        bikeBodyType: 'Sports',
        plateNumber: 'ABC-1234',
        dateTime: DateTime(2024, 1, 15, 10, 30),
        odometerReading: 15000,
        fuelQuantity: 3.5,
        costPerUnit: 280,
        vendor: 'Shell Station',
        note: 'Regular fill up',
        imageUrl: null,
      ),
      FuelExpense(
        id: '2',
        bikeId: '1',
        bikeBrand: 'Honda',
        bikeModel: 'CB 150',
        bikeBodyType: 'Sports',
        plateNumber: 'ABC-1234',
        dateTime: DateTime(2024, 1, 8, 14, 45),
        odometerReading: 14500,
        fuelQuantity: 3.2,
        costPerUnit: 275,
        vendor: 'PSO',
        note: null,
        imageUrl: 'https://example.com/image.jpg',
      ),
      FuelExpense(
        id: '3',
        bikeId: '2',
        bikeBrand: 'Yamaha',
        bikeModel: 'YBR 125',
        bikeBodyType: 'Commuter',
        plateNumber: 'XYZ-5678',
        dateTime: DateTime(2024, 1, 12, 9, 15),
        odometerReading: 22000,
        fuelQuantity: 2.8,
        costPerUnit: 282,
        vendor: 'Total Petrol',
        note: 'Full tank',
      ),
    ];
  }

  // Add a new fuel expense
  void addFuelExpense(FuelExpense expense) {
    fuelExpenses.add(expense);
  }

  // Update an existing fuel expense
  void updateFuelExpense(FuelExpense expense) {
    final index = fuelExpenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      fuelExpenses[index] = expense;
    }
  }

  // Delete a fuel expense
  void deleteFuelExpense(String expenseId) {
    fuelExpenses.removeWhere((expense) => expense.id == expenseId);
  }

  // Get fuel expenses for a specific bike
  List<FuelExpense> getExpensesForBike(String bikeId) {
    return fuelExpenses.where((expense) => expense.bikeId == bikeId).toList();
  }

  // Get total fuel cost for a specific bike
  double getTotalCostForBike(String bikeId) {
    return getExpensesForBike(bikeId)
        .fold(0.0, (sum, expense) => sum + expense.totalPrice);
  }
}
