import 'package:get/get.dart';
import '../model/expense_model.dart';

/// Expense Controller for GetX state management
class ExpenseController extends GetxController {
  // Observable list of expenses
  final RxList<Expense> expenses = <Expense>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with sample data
    _loadSampleExpenses();
  }

  void _loadSampleExpenses() {
    expenses.value = [
      Expense(
        id: '1',
        bikeId: '1',
        bikeBrand: 'Honda',
        bikeModel: 'CB 150',
        plateNumber: 'ABC-1234',
        dateTime: DateTime(2024, 1, 15, 10, 30),
        amount: 1500,
        details: 'Oil Change',
        note: 'Regular service',
      ),
      Expense(
        id: '2',
        bikeId: '1',
        bikeBrand: 'Honda',
        bikeModel: 'CB 150',
        plateNumber: 'ABC-1234',
        dateTime: DateTime(2024, 1, 10, 14, 45),
        amount: 3000,
        details: 'Brake Service',
        note: null,
      ),
      Expense(
        id: '3',
        bikeId: '2',
        bikeBrand: 'Yamaha',
        bikeModel: 'YBR 125',
        plateNumber: 'XYZ-5678',
        dateTime: DateTime(2024, 1, 12, 9, 15),
        amount: 2500,
        details: 'Tire Replacement',
        note: 'Front and rear tires',
      ),
    ];
  }

  // Add a new expense
  void addExpense(Expense expense) {
    expenses.add(expense);
  }

  // Update an existing expense
  void updateExpense(Expense expense) {
    final index = expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      expenses[index] = expense;
    }
  }

  // Delete an expense
  void deleteExpense(String expenseId) {
    expenses.removeWhere((expense) => expense.id == expenseId);
  }

  // Get expenses for a specific bike
  List<Expense> getExpensesForBike(String bikeId) {
    return expenses.where((expense) => expense.bikeId == bikeId).toList();
  }

  // Get total expense cost for a specific bike
  double getTotalCostForBike(String bikeId) {
    return getExpensesForBike(bikeId)
        .fold(0.0, (sum, expense) => sum + expense.amount);
  }
}
