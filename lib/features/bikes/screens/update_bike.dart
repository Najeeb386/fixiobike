import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/bike_model.dart';
import '../widgets/bottom_sheet_selector.dart';

/// Update Bike Screen for Fixio Bike App
/// Form to update existing vehicle with bottom sheet selectors for brand, model, and body type
class UpdateBike extends StatefulWidget {
  final Bike bike;

  const UpdateBike({super.key, required this.bike});

  @override
  State<UpdateBike> createState() => _UpdateBikeState();
}

class _UpdateBikeState extends State<UpdateBike> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  late final TextEditingController _plateNumberController;
  
  // Selected values - initialize with existing bike data
  String? _selectedBrand;
  String? _selectedModel;
  int? _selectedYear;
  String? _selectedBodyType;
  
  // Available data
  List<String> _availableModels = [];
  
  @override
  void initState() {
    super.initState();
    _plateNumberController = TextEditingController(text: widget.bike.plateNumber);
    
    // Initialize with existing values
    _selectedBrand = widget.bike.brand;
    _selectedModel = widget.bike.model;
    _selectedYear = widget.bike.year;
    _selectedBodyType = widget.bike.bodyType;
    _availableModels = BikeModels.getModelsForBrand(widget.bike.brand);
  }
  
  @override
  void dispose() {
    _plateNumberController.dispose();
    super.dispose();
  }

  void _onBrandSelected(String brand) {
    setState(() {
      _selectedBrand = brand;
      _selectedModel = null; // Reset model when brand changes
      _availableModels = BikeModels.getModelsForBrand(brand);
    });
  }

  void _onModelSelected(String model) {
    setState(() {
      _selectedModel = model;
    });
  }

  void _onBodyTypeSelected(String bodyType) {
    setState(() {
      _selectedBodyType = bodyType;
    });
  }

  void _onYearSelected(int year) {
    setState(() {
      _selectedYear = year;
    });
  }

  void _showBrandSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetSelector(
        title: 'Select Brand',
        items: BikeBrands.brands,
        selectedItem: _selectedBrand,
        onItemSelected: (brand) {
          _onBrandSelected(brand);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showModelSelector() {
    if (_selectedBrand == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a brand first'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetSelector(
        title: 'Select Model',
        items: _availableModels,
        selectedItem: _selectedModel,
        onItemSelected: (model) {
          _onModelSelected(model);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showYearSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetSelector(
        title: 'Select Year',
        items: BikeYears.getYears().map((e) => e.toString()).toList(),
        selectedItem: _selectedYear?.toString(),
        onItemSelected: (year) {
          _onYearSelected(int.parse(year));
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showBodyTypeSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetSelector(
        title: 'Select Body Type',
        items: BikeBodyTypes.bodyTypes,
        selectedItem: _selectedBodyType,
        onItemSelected: (bodyType) {
          _onBodyTypeSelected(bodyType);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _updateBike() {
    if (_formKey.currentState!.validate()) {
      if (_selectedBrand == null || 
          _selectedModel == null || 
          _selectedYear == null || 
          _selectedBodyType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all required fields'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final updatedBike = Bike(
        id: widget.bike.id,
        brand: _selectedBrand!,
        model: _selectedModel!,
        year: _selectedYear!,
        bodyType: _selectedBodyType!,
        plateNumber: _plateNumberController.text.trim().toUpperCase(),
        isSelected: widget.bike.isSelected,
      );

      Navigator.pop(context, updatedBike);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Update Bike'),
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
                  'Update your bike details',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Brand Selector
                _buildSelectorField(
                  label: 'Brand',
                  value: _selectedBrand,
                  hint: 'Select brand',
                  onTap: _showBrandSelector,
                ),
                
                const SizedBox(height: 16),
                
                // Model Selector
                _buildSelectorField(
                  label: 'Model',
                  value: _selectedModel,
                  hint: 'Select model',
                  onTap: _showModelSelector,
                ),
                
                const SizedBox(height: 16),
                
                // Year Selector
                _buildSelectorField(
                  label: 'Year',
                  value: _selectedYear?.toString(),
                  hint: 'Select year',
                  onTap: _showYearSelector,
                ),
                
                const SizedBox(height: 16),
                
                // Body Type Selector
                _buildSelectorField(
                  label: 'Body Type',
                  value: _selectedBodyType,
                  hint: 'Select body type',
                  onTap: _showBodyTypeSelector,
                ),
                
                const SizedBox(height: 16),
                
                // Plate Number Input
                _buildTextField(
                  controller: _plateNumberController,
                  label: 'Plate Number',
                  hint: 'Enter plate number',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter plate number';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Update Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateBike,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Update Bike',
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
                      'Delete Bike',
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
        title: const Text('Delete Bike'),
        content: const Text('Are you sure you want to delete this bike?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, null); // Return null to indicate deletion
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
          textCapitalization: TextCapitalization.characters,
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
