import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixiobike/core/constants/app_colors.dart';
import 'package:fixiobike/features/bikes/models/bike_model.dart';
import 'package:fixiobike/features/fuel/widgets/vehicle_bottom_sheet.dart';

/// New Accident Report Screen
class NewAccidentScreen extends StatefulWidget {
  const NewAccidentScreen({super.key});

  @override
  State<NewAccidentScreen> createState() => _NewAccidentScreenState();
}

class _NewAccidentScreenState extends State<NewAccidentScreen> {
  final _formKey = GlobalKey<FormState>();

  // Sample bikes
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

  // Selected values
  Bike? _selectedBike;
  DateTime _selectedDateTime = DateTime.now();
  String _reportType = 'accident'; // accident, non_accident_breakdown
  final _locationController = TextEditingController();
  String _accidentType = 'Collision';
  String _severityLevel = 'Minor';
  
  // Media controllers
  String? _media1Path;
  String? _media2Path;
  
  // Damage details
  String _damageType = 'vehicle_damage'; // vehicle_damage, property_damage
  final _propertyDamageDescriptionController = TextEditingController();
  
  // Action taken
  String _actionTaken = 'police';
  
  // Next steps
  final _nextStepsController = TextEditingController();

  // Dropdown options
  final List<String> _accidentTypes = ['Collision', 'Vehicle Damage'];
  final List<String> _severityLevels = ['Minor', 'Moderate', 'Severe'];
  final List<String> _actionTakenList = ['Police', 'Contacted Supervisor'];

  @override
  void dispose() {
    _locationController.dispose();
    _propertyDamageDescriptionController.dispose();
    _nextStepsController.dispose();
    super.dispose();
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

  void _showAccidentTypeSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildSelectorSheet(
        title: 'Select Accident Type',
        items: _accidentTypes,
        selectedItem: _accidentType,
        onSelected: (type) {
          setState(() {
            _accidentType = type;
          });
          Get.back();
        },
      ),
    );
  }

  void _showSeveritySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildSelectorSheet(
        title: 'Select Severity Level',
        items: _severityLevels,
        selectedItem: _severityLevel,
        onSelected: (severity) {
          setState(() {
            _severityLevel = severity;
          });
          Get.back();
        },
      ),
    );
  }

  void _showActionTakenSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildSelectorSheet(
        title: 'Action Taken',
        items: _actionTakenList,
        selectedItem: _actionTaken == 'police' ? 'Police' : 'Contacted Supervisor',
        onSelected: (action) {
          setState(() {
            _actionTaken = action == 'Police' ? 'police' : 'contacted_supervisor';
          });
          Get.back();
        },
      ),
    );
  }

  Widget _buildSelectorSheet({
    required String title,
    required List<String> items,
    required String selectedItem,
    required Function(String) onSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              item,
              style: TextStyle(
                fontSize: 16,
                color: item == selectedItem ? AppColors.primaryColor : AppColors.textDark,
                fontWeight: item == selectedItem ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            trailing: item == selectedItem
                ? const Icon(Icons.check, color: AppColors.primaryColor)
                : null,
            onTap: () => onSelected(item),
          )),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = (hour % 12 == 0 ? 12 : hour % 12).toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} - $displayHour:$minute $period';
  }

  void _submitReport() {
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

      // Show success message
      Get.snackbar(
        'Success',
        'Accident report submitted successfully!',
        backgroundColor: AppColors.primaryColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate back
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('New Accident Report'),
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
                  'Report an Incident',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Fill in the details below to report an accident or breakdown',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // ─── Select Vehicle ─────────────────────────────────────────────────
                _buildSelectorField(
                  label: 'Select Vehicle',
                  value: _selectedBike != null
                      ? '${_selectedBike!.brand} ${_selectedBike!.model} - ${_selectedBike!.plateNumber}'
                      : null,
                  hint: 'Select your bike',
                  onTap: _showVehicleSelector,
                ),
                
                const SizedBox(height: 16),
                
                // ─── Date and Time ─────────────────────────────────────────────────
                _buildSelectorField(
                  label: 'Date & Time',
                  value: _formatDateTime(_selectedDateTime),
                  hint: 'Select date and time',
                  onTap: _showDateTimePicker,
                ),
                
                const SizedBox(height: 16),
                
                // ─── Report Type ─────────────────────────────────────────────────
                const Text(
                  'Report Type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildRadioButton(
                        label: 'Accident',
                        value: 'accident',
                        groupValue: _reportType,
                        onChanged: (value) {
                          setState(() {
                            _reportType = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildRadioButton(
                        label: 'Non-Accident Breakdown',
                        value: 'non_accident_breakdown',
                        groupValue: _reportType,
                        onChanged: (value) {
                          setState(() {
                            _reportType = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // ─── Location ─────────────────────────────────────────────────
                _buildTextField(
                  controller: _locationController,
                  label: 'Location',
                  hint: 'Enter incident location',
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter location';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // ─── Accident Type ─────────────────────────────────────────────────
                _buildSelectorField(
                  label: 'Accident Type',
                  value: _accidentType,
                  hint: 'Select accident type',
                  onTap: _showAccidentTypeSelector,
                ),
                
                const SizedBox(height: 16),
                
                // ─── Severity Level ─────────────────────────────────────────────────
                _buildSelectorField(
                  label: 'Severity Level',
                  value: _severityLevel,
                  hint: 'Select severity level',
                  onTap: _showSeveritySelector,
                ),
                
                const SizedBox(height: 24),
                
                // ─── Upload Media and Documents ─────────────────────────────────
                const Text(
                  'Upload Media & Documents',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildMediaUploadBox(1)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildMediaUploadBox(2)),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // ─── Damage Details ─────────────────────────────────────────────────
                const Text(
                  'Damage Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildRadioButton(
                        label: 'Vehicle Damage',
                        value: 'vehicle_damage',
                        groupValue: _damageType,
                        onChanged: (value) {
                          setState(() {
                            _damageType = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildRadioButton(
                        label: 'Property Damage',
                        value: 'property_damage',
                        groupValue: _damageType,
                        onChanged: (value) {
                          setState(() {
                            _damageType = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Show bike sketch if vehicle damage selected
                if (_damageType == 'vehicle_damage') ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.inputBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Vehicle Damage Sketch',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assests/sketchs/bike_sketch.png',
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: AppColors.backgroundColor,
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image_not_supported, 
                                           size: 48, color: AppColors.grey),
                                      SizedBox(height: 8),
                                      Text('Image not found',
                                          style: TextStyle(color: AppColors.grey)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                // Show description field if property damage selected
                if (_damageType == 'property_damage') ...[
                  _buildTextField(
                    controller: _propertyDamageDescriptionController,
                    label: 'Property Damage Description',
                    hint: 'Describe the property damage',
                    keyboardType: TextInputType.text,
                    maxLines: 3,
                    validator: (value) {
                      if (_damageType == 'property_damage' && 
                          (value == null || value.trim().isEmpty)) {
                        return 'Please describe the property damage';
                      }
                      return null;
                    },
                  ),
                ],
                
                const SizedBox(height: 24),
                
                // ─── Action Taken ─────────────────────────────────────────────────
                _buildSelectorField(
                  label: 'Action Taken',
                  value: _actionTaken == 'police' ? 'Police' : 'Contacted Supervisor',
                  hint: 'Select action taken',
                  onTap: _showActionTakenSelector,
                ),
                
                const SizedBox(height: 16),
                
                // ─── Next Steps ─────────────────────────────────────────────────
                _buildTextField(
                  controller: _nextStepsController,
                  label: 'Describe Next Steps',
                  hint: 'Describe what needs to be done next',
                  keyboardType: TextInputType.text,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please describe next steps';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 32),
                
                // ─── Submit Button ─────────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Submit Report',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioButton({
    required String label,
    required String value,
    required String groupValue,
    required Function(String?) onChanged,
  }) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor.withOpacity(0.1) : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : AppColors.inputBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryColor : AppColors.grey,
                  width: 2,
                ),
                color: isSelected ? AppColors.primaryColor : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColors.primaryColor : AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaUploadBox(int boxNumber) {
    final path = boxNumber == 1 ? _media1Path : _media2Path;
    return GestureDetector(
      onTap: () {
        // Implement image picker functionality here
        setState(() {
          if (boxNumber == 1) {
            _media1Path = 'selected';
          } else {
            _media2Path = 'selected';
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Media $boxNumber selected'),
            backgroundColor: AppColors.primaryColor,
          ),
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: path != null
            ? const Center(
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.primaryColor,
                  size: 40,
                ),
              )
            : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: AppColors.grey,
                    size: 32,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add Media',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                ],
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
