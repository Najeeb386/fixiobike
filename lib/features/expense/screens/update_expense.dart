import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixiobike/core/constants/app_colors.dart';
import 'package:fixiobike/features/bikes/models/bike_model.dart';
import 'package:fixiobike/features/expense/model/expense_model.dart';
import 'package:fixiobike/features/bikes/widgets/bottom_sheet_selector.dart';

/// Update Expense Screen for Fixio Bike App
/// Form to update an existing expense record
class UpdateExpense extends StatefulWidget {
  final Expense expense;

  const UpdateExpense({super.key, required this.expense});

  @override
  State<UpdateExpense> createState() => _UpdateExpenseState();
}

class _UpdateExpenseState extends State<UpdateExpense> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  late final TextEditingController _amountController;
  late final TextEditingController _detailsController;
  late final TextEditingController _noteController;

  // Selected values
  Bike? _selectedBike;
  late DateTime _selectedDateTime;
  String? _selectedExpenseType;

  // Sample bikes - in production, this would come from the bikes_view
  List<Bike> _availableBikes = [
    Bike(
      id: '1',
      brand: 'Honda',
      model: 'CB 150',
      year: 2023,
      bodyType: 'Sports',
      plateNumber: 'ABC-1234',
    ),
    Bike(
      id: '2',
      brand: 'Yamaha',
      model: 'YBR 125',
      year: 2022,
      bodyType: 'Commuter',
      plateNumber: 'XYZ-5678',
    ),
    Bike(
      id: '3',
      brand: 'Suzuki',
      model: 'GD 110',
      year: 2021,
      bodyType: 'Standard',
      plateNumber: 'LMN-9012',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.expense.amount.toString());
    _detailsController = TextEditingController(text: widget.expense.details);
    _noteController = TextEditingController(text: widget.expense.note ?? '');
    
    _selectedDateTime = widget.expense.dateTime;
    
    // Find matching bike
    _selectedBike = _availableBikes.firstWhere(
      (bike) => bike.id == widget.expense.bikeId,
      orElse: () => Bike(
        id: widget.expense.bikeId,
        brand: widget.expense.bikeBrand,
        model: widget.expense.bikeModel,
        year: 2023,
        bodyType: '',
        plateNumber: widget.expense.plateNumber,
      ),
    );
    
    _selectedExpenseType = widget.expense.details;
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    _detailsController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _showVehicleSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetSelector(
        title: 'Select Vehicle',
        items: _availableBikes.map((b) => '${b.brand} ${b.model} - ${b.plateNumber}').toList(),
        selectedItem: _selectedBike != null ? '${_selectedBike!.brand} ${_selectedBike!.model} - ${_selectedBike!.plateNumber}' : null,
        onItemSelected: (value) {
          final index = _availableBikes.indexWhere((b) => '${b.brand} ${b.model} - ${b.plateNumber}' == value);
          if (index != -1) {
            setState(() {
              _selectedBike = _availableBikes[index];
            });
          }
          Get.back();
        },
      ),
    );
  }

  void _showExpenseTypeSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetSelector(
        title: 'Select Expense Type',
        items: ExpenseTypes.types,
        selectedItem: _selectedExpenseType,
        onItemSelected: (value) {
          setState(() {
            _selectedExpenseType = value;
          });
          Get.back();
        },
      ),
    );
  }

  void _showDateTimePicker() async {
    // First show date picker
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (date != null && mounted) {
      // Then show time picker
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (time != null && mounted) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _updateExpense() {
    if (_formKey.currentState!.validate()) {
      if (_selectedBike == null) {
        Get.snackbar(
          'Error',
          'Please select a vehicle',
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
        );
        return;
      }

      if (_selectedExpenseType == null) {
        Get.snackbar(
          'Error',
          'Please select expense type',
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
        );
        return;
      }

      final updatedExpense = Expense(
        id: widget.expense.id,
        bikeId: _selectedBike!.id,
        bikeBrand: _selectedBike!.brand,
        bikeModel: _selectedBike!.model,
        plateNumber: _selectedBike!.plateNumber,
        dateTime: _selectedDateTime,
        amount: double.parse(_amountController.text.trim()),
        details: _detailsController.text.trim(),
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      );

      Get.back(result: updatedExpense);
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} - $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Update Expense'),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'Update expense details',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Vehicle Selector
                _buildSelectorField(
                  label: 'Select Vehicle',
                  value: _selectedBike != null
                      ? '${_selectedBike!.brand} ${_selectedBike!.model} - ${_selectedBike!.plateNumber}'
                      : null,
                  hint: 'Select your bike',
                  onTap: _showVehicleSelector,
                ),
                
                const SizedBox(height: 16),
                
                // Date and Time Selector
                _buildSelectorField(
                  label: 'Date & Time',
                  value: _formatDateTime(_selectedDateTime),
                  hint: 'Select date and time',
                  onTap: _showDateTimePicker,
                ),
                
                const SizedBox(height: 16),
                
                // Expense Type Selector
                _buildSelectorField(
                  label: 'Expense Type',
                  value: _selectedExpenseType,
                  hint: 'Select expense type',
                  onTap: _showExpenseTypeSelector,
                ),
                
                const SizedBox(height: 16),
                
                // Amount
                _buildTextField(
                  controller: _amountController,
                  label: 'Expense Amount (Rs.)',
                  hint: 'Enter expense amount',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter expense amount';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Details
                _buildTextField(
                  controller: _detailsController,
                  label: 'Expense Details',
                  hint: 'Enter expense details',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter expense details';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Note
                _buildTextField(
                  controller: _noteController,
                  label: 'Note (Optional)',
                  hint: 'Enter any additional note',
                  keyboardType: TextInputType.text,
                  maxLines: 3,
                ),
                
                const SizedBox(height: 32),
                
                // Update Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateExpense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Update Expense',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Delete Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      _showDeleteConfirmation();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Delete Expense',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
              Get.back(result: null); // Return null to indicate deletion
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorField({
    required String label,
    required String? value,
    required String hint,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? hint,
                    style: TextStyle(
                      fontSize: 14,
                      color: value != null ? AppColors.textDark : AppColors.grey,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required TextInputType keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.grey,
              fontSize: 14,
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}
