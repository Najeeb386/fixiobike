import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../models/trip_model.dart';
import 'add_trip_screen.dart';

class TripView extends StatefulWidget {
  const TripView({super.key});

  @override
  State<TripView> createState() => _TripViewState();
}

class _TripViewState extends State<TripView> {
  // Sample trips data
  final List<Trip> trips = [
    Trip(
      id: '1',
      vehicleName: 'Honda CB 150',
      plateNumber: 'ABC-1234',
      pickupLocation: ' Karachi',
      dropoffLocation: 'Lahore',
      pickupDate: DateTime(2024, 1, 15, 09, 00),
      tripPurpose: 'Business',
      status: 'Completed',
    ),
    Trip(
      id: '2',
      vehicleName: 'Yamaha YBR 125',
      plateNumber: 'XYZ-5678',
      pickupLocation: 'Islamabad',
      dropoffLocation: 'Rawalpindi',
      pickupDate: DateTime(2024, 1, 20, 14, 30),
      tripPurpose: 'Personal',
      status: 'Completed',
    ),
    Trip(
      id: '3',
      vehicleName: 'Suzuki GD 110',
      plateNumber: 'PQR-9012',
      pickupLocation: 'Lahore',
      dropoffLocation: 'Multan',
      pickupDate: DateTime(2024, 2, 1, 08, 00),
      tripPurpose: 'Delivery',
      status: 'In Progress',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text('My Trips', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: trips.isEmpty
          ? _buildEmptyState()
          : _buildTripList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const AddTripScreen()),
        backgroundColor: AppColors.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add New Trip', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No trips yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to add your first trip',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildTripList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return _buildTripCard(trip);
      },
    );
  }

  Widget _buildTripCard(Trip trip) {
    final isCompleted = trip.status == 'Completed';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.directions_car, color: AppColors.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    trip.vehicleName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted 
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  trip.status,
                  style: TextStyle(
                    color: isCompleted ? Colors.green : Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            trip.plateNumber,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.trip_origin, size: 16, color: Colors.green),
                        const SizedBox(width: 6),
                        const Text('Pickup', style: TextStyle(fontSize: 11, color: AppColors.grey)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trip.pickupLocation,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward, color: AppColors.grey, size: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Dropoff', style: TextStyle(fontSize: 11, color: AppColors.grey)),
                        const SizedBox(width: 6),
                        Icon(Icons.location_on, size: 16, color: Colors.red),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trip.dropoffLocation,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: AppColors.grey),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(trip.pickupDate),
                    style: const TextStyle(fontSize: 12, color: AppColors.grey),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.flag, size: 14, color: AppColors.grey),
                  const SizedBox(width: 6),
                  Text(
                    trip.tripPurpose ?? 'N/A',
                    style: const TextStyle(fontSize: 12, color: AppColors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
