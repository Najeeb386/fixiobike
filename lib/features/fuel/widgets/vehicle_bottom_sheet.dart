import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../bikes/models/bike_model.dart';

/// Vehicle Bottom Sheet Selector Widget
/// Displays a full-page bottom sheet with selectable vehicles
class VehicleBottomSheet extends StatelessWidget {
  final List<Bike> bikes;
  final Bike? selectedBike;
  final Function(Bike) onBikeSelected;

  const VehicleBottomSheet({
    super.key,
    required this.bikes,
    required this.selectedBike,
    required this.onBikeSelected,
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
                const Text(
                  'Select Vehicle',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Bikes list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: bikes.length,
              itemBuilder: (context, index) {
                final bike = bikes[index];
                final isSelected = bike.id == selectedBike?.id;
                
                return ListTile(
                  onTap: () => onBikeSelected(bike),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.pedal_bike,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  title: Text(
                    '${bike.brand} ${bike.model}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? AppColors.primaryColor : AppColors.textDark,
                    ),
                  ),
                  subtitle: Text(
                    '${bike.bodyType} - ${bike.plateNumber}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
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
