import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/bikes_controller.dart';
import '../models/bike_model.dart';
import 'add_new_bike.dart';
import 'update_bike.dart';

/// Bikes View Screen for Fixio Bike App
/// Displays list of user's vehicles with selection option
class BikesView extends StatelessWidget {
  const BikesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the controller
    final bikesController = Get.find<BikesController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('My Vehicles'),
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
      ),
      body: Obx(() {
        final bikes = bikesController.bikes;
        
        if (bikes.isEmpty) {
          return _buildEmptyState();
        }
        
        return _buildVehicleList(bikesController);
      }),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pedal_bike_outlined,
            size: 80,
            color: AppColors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            'No vehicles added yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tap the button below to add your first bike',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleList(BikesController controller) {
    return Obx(() {
      final bikes = controller.bikes;
      final selectedBikeId = controller.selectedBikeId.value;
      
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bikes.length,
        itemBuilder: (context, index) {
          final bike = bikes[index];
          return _buildVehicleCard(bike, bike.id == selectedBikeId, controller);
        },
      );
    });
  }

  Widget _buildVehicleCard(Bike bike, bool isSelected, BikesController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primaryColor : AppColors.inputBorder,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => controller.selectBike(bike.id),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Radio button
                Radio<String>(
                  value: bike.id,
                  groupValue: controller.selectedBikeId.value,
                  onChanged: (value) {
                    if (value != null) {
                      controller.selectBike(value);
                    }
                  },
                  activeColor: AppColors.primaryColor,
                ),
                
                const SizedBox(width: 12),
                
                // Vehicle info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Brand and Model
                      Row(
                        children: [
                          Text(
                            bike.brand,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            bike.model,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 4),
                      
                      // Year and Body Type
                      Row(
                        children: [
                          Text(
                            '${bike.year}',
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
                            bike.bodyType,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Plate Number - Clickable to update
                      GestureDetector(
                        onTap: () => _navigateToUpdateBike(bike),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.confirmation_number_outlined,
                                size: 16,
                                color: AppColors.primaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                bike.plateNumber,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.edit,
                                size: 14,
                                color: AppColors.primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Bike icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.pedal_bike,
                    size: 32,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToUpdateBike(Bike bike) async {
    final bikesController = Get.find<BikesController>();
    final result = await Get.to<Bike>(
      () => UpdateBike(bike: bike),
    );

    if (result != null) {
      bikesController.updateBike(result);
    }
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
            onPressed: _navigateToAddNewBike,
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
                  'Add New Vehicle',
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

  void _navigateToAddNewBike() async {
    final bikesController = Get.find<BikesController>();
    final result = await Get.to<Bike>(
      () => const AddNewBike(),
    );

    if (result != null) {
      bikesController.addBike(result);
    }
  }
}
