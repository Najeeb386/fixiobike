import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../model/fuel_expense_model.dart';
import 'add_fuel_expense.dart';
import 'update_fuel_expense.dart';

/// Fuel Log Screen for Fixio Bike App
/// Displays list of fuel expense records
class FuelLog extends StatefulWidget {
  const FuelLog({super.key});

  @override
  State<FuelLog> createState() => _FuelLogState();
}

class _FuelLogState extends State<FuelLog> {
  // Sample fuel expenses - in production, this would come from API/DB
  List<FuelExpense> _fuelExpenses = [
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

  void _navigateToAddFuelExpense() async {
    final result = await Navigator.push<FuelExpense>(
      context,
      MaterialPageRoute(builder: (context) => const AddFuelExpense()),
    );

    if (result != null) {
      setState(() {
        _fuelExpenses.add(result);
      });
    }
  }

  void _navigateToUpdateFuelExpense(FuelExpense expense) async {
    final result = await Navigator.push<FuelExpense>(
      context,
      MaterialPageRoute(builder: (context) => UpdateFuelExpense(expense: expense)),
    );

    if (result != null) {
      setState(() {
        final index = _fuelExpenses.indexWhere((e) => e.id == result.id);
        if (index != -1) {
          _fuelExpenses[index] = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Fuel Log'),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
      ),
      body: _fuelExpenses.isEmpty
          ? _buildEmptyState()
          : _buildFuelList(),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_gas_station_outlined,
            size: 80,
            color: AppColors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No fuel expenses yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the button below to add your first fuel expense',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFuelList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _fuelExpenses.length,
      itemBuilder: (context, index) {
        final expense = _fuelExpenses[index];
        return _buildFuelCard(expense);
      },
    );
  }

  Widget _buildFuelCard(FuelExpense expense) {
    return GestureDetector(
      onTap: () => _navigateToUpdateFuelExpense(expense),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.inputBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // First row: Brand, Body Type, Plate Number + Image
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Image or Invoice Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: expense.imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              expense.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.receipt_long,
                                  color: AppColors.primaryColor,
                                  size: 28,
                                );
                              },
                            ),
                          )
                        : const Icon(
                            Icons.receipt_long,
                            color: AppColors.primaryColor,
                            size: 28,
                          ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Vehicle info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              expense.bikeBrand,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              expense.bikeModel,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              expense.bikeBodyType,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: AppColors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              expense.plateNumber,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Divider
            const Divider(height: 1),
            
            // Second row: Date and Time
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(expense.dateTime),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(expense.dateTime),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            
            // Divider
            const Divider(height: 1),
            
            // Third row: Vendor, Odometer, Fuel Quantity, Total Price
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Vendor
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Vendor',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          expense.vendor,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Odometer
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Odometer',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${expense.odometerReading} km',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Fuel Quantity
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Fuel',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${expense.fuelQuantity} L',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Total Price
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Rs. ${expense.totalPrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Widget _buildBottomAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _navigateToAddFuelExpense,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add),
                SizedBox(width: 8),
                Text(
                  'Add Fuel Expense',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
