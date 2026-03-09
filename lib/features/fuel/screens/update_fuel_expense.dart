import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixiobike/core/constants/app_colors.dart';
import '../../bikes/models/bike_model.dart';
import '../model/fuel_expense_model.dart';
import 'add_fuel_expense.dart';
import '../widgets/vehicle_bottom_sheet.dart';
import 'add_fuel_expense.dart';

/// Update Fuel Expense Screen for Fixio Bike App
/// Form to update an existing fuel expense record
class UpdateFuelExpense extends StatefulWidget {
  final FuelExpense expense;

  const UpdateFuelExpense({super.key, required this.expense});

  @override
  State<UpdateFuelExpense> createState() => _UpdateFuelExpenseState();
}

class _UpdateFuelExpenseState extends State<UpdateFuelExpense> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  late final TextEditingController _odometerController;
  late final TextEditingController _fuelQuantityController;
  late final TextEditingController _costPerUnitController;
  late final TextEditingController _vendorController;
  late final TextEditingController _noteController;

  // Selected values
  Bike? _selectedBike;
  late DateTime _selectedDateTime;

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
    _odometerController = TextEditingController(text: widget.expense.odometerReading.toString());
    _fuelQuantityController = TextEditingController(text: widget.expense.fuelQuantity.toString());
    _costPerUnitController = TextEditingController(text: widget.expense.costPerUnit.toString());
    _vendorController = TextEditingController(text: widget.expense.vendor);
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
        bodyType: widget.expense.bikeBodyType,
        plateNumber: widget.expense.plateNumber,
      ),
    );
  }
  
  @override
  void dispose() {
    _odometerController.dispose();
    _fuelQuantityController.dispose();
    _costPerUnitController.dispose();
    _vendorController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  double get _totalPrice {
    final quantity = double.tryParse(_fuelQuantityController.text) ?? 0;
    final cost = double.tryParse(_costPerUnitController.text) ?? 0;
    return quantity * cost;
  }

  void _showVehicleSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VehicleBottomSheet(
        bikes: _availableBikes,
        selectedBike: _selectedBike,
        onBikeSelected: (bike) {
          setState(() {
            _selectedBike = bike;
          });
          Navigator.pop(context);
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

  void _updateFuelExpense() {
    if (_formKey.currentState!.validate()) {
      if (_selectedBike == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a vehicle'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final updatedExpense = FuelExpense(
        id: widget.expense.id,
        bikeId: _selectedBike!.id,
        bikeBrand: _selectedBike!.brand,
        bikeModel: _selectedBike!.model,
        bikeBodyType: _selectedBike!.bodyType,
        plateNumber: _selectedBike!.plateNumber,
        dateTime: _selectedDateTime,
        odometerReading: int.parse(_odometerController.text.trim()),
        fuelQuantity: double.parse(_fuelQuantityController.text.trim()),
        costPerUnit: double.parse(_costPerUnitController.text.trim()),
        vendor: _vendorController.text.trim(),
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        imageUrl: widget.expense.imageUrl,
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
        title: const Text('Update Fuel Expense'),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
                  'Update fuel expense details',
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
                
                // Odometer Reading
                _buildTextField(
                  controller: _odometerController,
                  label: 'Odometer Reading (km)',
                  hint: 'Enter current odometer reading',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter odometer reading';
                    }
                    if (int.tryParse(value.trim()) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Fuel Quantity
                _buildTextField(
                  controller: _fuelQuantityController,
                  label: 'Fuel Quantity (Liters)',
                  hint: 'Enter fuel quantity',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter fuel quantity';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                ),
                
                const SizedBox(height: 16),
                
                // Cost Per Unit
                _buildTextField(
                  controller: _costPerUnitController,
                  label: 'Cost Per Unit (Rs.)',
                  hint: 'Enter cost per liter',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter cost per unit';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                ),
                
                const SizedBox(height: 16),
                
                // Total Price (calculated)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Price',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'Rs. ${_totalPrice.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Vendor
                _buildTextField(
                  controller: _vendorController,
                  label: 'Fuel Vendor',
                  hint: 'Enter vendor name',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter vendor name';
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
                
                const SizedBox(height: 16),
                
                // Picture Upload
                _buildPictureUpload(),
                
                const SizedBox(height: 32),
                
                // Update Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateFuelExpense,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Update Fuel Expense',
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
                      'Delete Fuel Expense',
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Fuel Expense'),
        content: const Text('Are you sure you want to delete this fuel expense?'),
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
    void Function(String)? onChanged,
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
          onChanged: onChanged,
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

  Widget _buildPictureUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Picture (Optional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.inputBorder,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                size: 48,
                color: AppColors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tap to upload image',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Supports: JPG, PNG',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
