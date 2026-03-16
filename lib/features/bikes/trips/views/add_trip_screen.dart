import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../models/bike_model.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  // Text controllers
  final pickupLocationController = TextEditingController();
  final dropoffLocationController = TextEditingController();
  final tripPurposeController = TextEditingController();
  final cargoDetailsController = TextEditingController();
  final noteController = TextEditingController();
  
  // Selected values
  String? selectedVehicle;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  
  // Sample vehicles list
  final List<Map<String, String>> vehicles = [
    {'name': 'Honda CB 150', 'plate': 'ABC-1234'},
    {'name': 'Yamaha YBR 125', 'plate': 'XYZ-5678'},
    {'name': 'Suzuki GD 110', 'plate': 'PQR-9012'},
    {'name': 'Honda Activa 110', 'plate': 'DEF-3456'},
    {'name': 'Yamaha YBR 150', 'plate': 'GHI-7890'},
  ];

  @override
  void dispose() {
    pickupLocationController.dispose();
    dropoffLocationController.dispose();
    tripPurposeController.dispose();
    cargoDetailsController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text('Add New Trip', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Select Vehicle Dropdown
              _buildLabel('Select Vehicle'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedVehicle,
                decoration: InputDecoration(
                  hintText: 'Choose your vehicle',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: vehicles.map((vehicle) {
                  return DropdownMenuItem<String>(
                    value: vehicle['name'],
                    child: Text('${vehicle['name']} (${vehicle['plate']})'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedVehicle = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a vehicle';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Pickup Date and Time
              _buildLabel('Pickup Date & Time'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 20, color: AppColors.grey),
                            const SizedBox(width: 10),
                            Text(
                              selectedDate != null
                                  ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                  : 'Select Date',
                              style: TextStyle(
                                color: selectedDate != null ? AppColors.textDark : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, size: 20, color: AppColors.grey),
                            const SizedBox(width: 10),
                            Text(
                              selectedTime != null
                                  ? selectedTime!.format(context)
                                  : 'Select Time',
                              style: TextStyle(
                                color: selectedTime != null ? AppColors.textDark : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Pickup Location
              _buildLabel('Pickup Location'),
              const SizedBox(height: 8),
              TextFormField(
                controller: pickupLocationController,
                decoration: InputDecoration(
                  hintText: 'Enter pickup location',
                  prefixIcon: const Icon(Icons.trip_origin, color: Colors.green),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pickup location';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Dropoff Location
              _buildLabel('Dropoff Location'),
              const SizedBox(height: 8),
              TextFormField(
                controller: dropoffLocationController,
                decoration: InputDecoration(
                  hintText: 'Enter dropoff location',
                  prefixIcon: const Icon(Icons.location_on, color: Colors.red),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter dropoff location';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Trip Purpose
              _buildLabel('Trip Purpose'),
              const SizedBox(height: 8),
              TextFormField(
                controller: tripPurposeController,
                decoration: InputDecoration(
                  hintText: 'Enter trip purpose',
                  prefixIcon: const Icon(Icons.flag, color: AppColors.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter trip purpose';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Cargo Details
              _buildLabel('Cargo Details (Optional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: cargoDetailsController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Enter cargo details if any',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Note
              _buildLabel('Note (Optional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add any additional notes',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitTrip,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _submitTrip() {
    if (_formKey.currentState!.validate()) {
      // Validate date and time
      if (selectedDate == null) {
        Get.snackbar(
          'Error',
          'Please select pickup date',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      
      if (selectedTime == null) {
        Get.snackbar(
          'Error',
          'Please select pickup time',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      
      // Combine date and time
      final pickupDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
      
      // Get selected vehicle plate
      String plateNumber = '';
      for (var vehicle in vehicles) {
        if (vehicle['name'] == selectedVehicle) {
          plateNumber = vehicle['plate'] ?? '';
          break;
        }
      }
      
      // Show success message
      Get.back();
      Get.snackbar(
        'Success',
        'Trip added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Here you would typically save the trip to your backend/database
      print('Trip Details:');
      print('Vehicle: $selectedVehicle ($plateNumber)');
      print('Pickup: $pickupDateTime');
      print('From: ${pickupLocationController.text}');
      print('To: ${dropoffLocationController.text}');
      print('Purpose: ${tripPurposeController.text}');
      print('Cargo: ${cargoDetailsController.text}');
      print('Note: ${noteController.text}');
    }
  }
}
