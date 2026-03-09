import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../models/bike_model.dart';
import '../widgets/bottom_sheet_selector.dart';

/// Add New Bike Screen for Fixio Bike App
/// Form to add a new vehicle with bottom sheet selectors for brand, model, and body type
class AddNewBike extends StatefulWidget {
  const AddNewBike({super.key});

  @override
  State<AddNewBike> createState() => _AddNewBikeState();
}

class _AddNewBikeState extends State<AddNewBike> {
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _plateNumberController = TextEditingController();
  
  // Selected values
  String? _selectedBrand;
  String? _selectedModel;
  int? _selectedYear;
  String? _selectedBodyType;
  
  // Available data
  List<String> _availableModels = [];
  
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
          Get.back();
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
          Get.back();
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
          Get.back();
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
          Get.back();
        },
      ),
    );
  }

  void _saveBike() {
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

      final newBike = Bike(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        brand: _selectedBrand!,
        model: _selectedModel!,
        year: _selectedYear!,
        bodyType: _selectedBodyType!,
        plateNumber: _plateNumberController.text.trim().toUpperCase(),
        isSelected: false,
      );

      Get.back(result: newBike);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Add New Bike'),
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
                  'Enter your bike details',
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
                
                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveBike,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Bike',
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

/// Bottom Sheet Selector Widget
/// Displays a full-page bottom sheet with selectable items
class _BottomSheetSelector extends StatelessWidget {
  final String title;
  final List<String> items;
  final String? selectedItem;
  final Function(String) onItemSelected;

  const _BottomSheetSelector({
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Items list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = item == selectedItem;
                
                return ListTile(
                  onTap: () => onItemSelected(item),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  title: Text(
                    item,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? AppColors.primaryColor : AppColors.textDark,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.primaryColor,
                        )
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
