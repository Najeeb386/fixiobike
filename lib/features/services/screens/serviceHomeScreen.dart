import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ServiceHomeScreen extends StatefulWidget {
  const ServiceHomeScreen({super.key});

  @override
  State<ServiceHomeScreen> createState() => _ServiceHomeScreenState();
}

class _ServiceHomeScreenState extends State<ServiceHomeScreen> {
  String? selectedCity;
  String? selectedBike;

  final List<Map<String, dynamic>> cities = [
    {'name': 'Karachi', 'landmark': 'Mazar-e-Quaid', 'icon': Icons.location_city},
    {'name': 'Lahore', 'landmark': 'Minar-e-Pakistan', 'icon': Icons.location_city},
    {'name': 'Islamabad', 'landmark': 'Faisal Mosque', 'icon': Icons.location_city},
    {'name': 'Peshawar', 'landmark': 'Khyber Pass', 'icon': Icons.location_city},
  ];

  final List<Map<String, dynamic>> bikes = [
    {'name': 'Honda CB 150', 'brand': 'Honda', 'icon': Icons.pedal_bike},
    {'name': 'Yamaha YBR 125', 'brand': 'Yamaha', 'icon': Icons.pedal_bike},
    {'name': 'Suzuki GD 110', 'brand': 'Suzuki', 'icon': Icons.pedal_bike},
  ];

  final List<Map<String, dynamic>> serviceCategories = [
    {'name': 'Oil Change', 'icon': Icons.opacity, 'color': Colors.blue},
    {'name': 'Brake Service', 'icon': Icons.handyman, 'color': Colors.orange},
    {'name': 'Tire Service', 'icon': Icons.settings, 'color': Colors.purple},
    {'name': 'Battery', 'icon': Icons.battery_charging_full, 'color': Colors.green},
    {'name': 'Chain Sprocket', 'icon': Icons.link, 'color': Colors.red},
    {'name': 'Engine Tune', 'icon': Icons.tune, 'color': Colors.teal},
  ];

  final List<Map<String, dynamic>> trendingServices = [
    {'name': 'Full Service', 'image': null},
    {'name': 'Oil Change', 'image': null},
    {'name': 'Brake Pads', 'image': null},
    {'name': 'Tire Replace', 'image': null},
    {'name': 'Battery Svc', 'image': null},
    {'name': 'Chain Maint', 'image': null},
  ];

  final List<Map<String, dynamic>> tailoredServices = [
    {'name': 'Monthly Maint', 'description': 'Regular checkups', 'image': null},
    {'name': 'Annual Pkg', 'description': 'Yearly coverage', 'image': null},
  ];

  void _showCityModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Your City', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities[index];
                  return ListTile(
                    leading: Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: Icon(city['icon'], color: AppColors.primaryColor),
                    ),
                    title: Text(city['name'], style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    subtitle: Text(city['landmark'], style: const TextStyle(color: AppColors.grey, fontSize: 12)),
                    trailing: selectedCity == city['name'] ? const Icon(Icons.check_circle, color: AppColors.primaryColor) : null,
                    onTap: () {
                      setState(() => selectedCity = city['name']);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBikeModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Your Bike', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: bikes.length,
                itemBuilder: (context, index) {
                  final bike = bikes[index];
                  return ListTile(
                    leading: Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: Icon(bike['icon'], color: AppColors.primaryColor),
                    ),
                    title: Text(bike['name'], style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    subtitle: Text(bike['brand'], style: const TextStyle(color: AppColors.grey, fontSize: 12)),
                    trailing: selectedBike == bike['name'] ? const Icon(Icons.check_circle, color: AppColors.primaryColor) : null,
                    onTap: () {
                      setState(() => selectedBike = bike['name']);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchSection(),
              const SizedBox(height: 16),
              _buildCityBikeSelection(),
              const SizedBox(height: 24),
              _buildServiceCategories(),
              const SizedBox(height: 24),
              _buildTrendingServices(),
              const SizedBox(height: 24),
              _buildTailoredServices(),
              const SizedBox(height: 24),
              _buildHowItWorks(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search services...',
          hintStyle: const TextStyle(color: AppColors.grey),
          prefixIcon: const Icon(Icons.search, color: AppColors.primaryColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          filled: true,
          fillColor: AppColors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCityBikeSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _showCityModal,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selectedCity != null ? AppColors.primaryColor : AppColors.inputBorder),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: selectedCity != null ? AppColors.primaryColor : AppColors.grey, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(selectedCity ?? 'City', style: TextStyle(color: selectedCity != null ? AppColors.textDark : AppColors.grey, fontSize: 13, fontWeight: selectedCity != null ? FontWeight.w600 : FontWeight.normal), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: _showBikeModal,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selectedBike != null ? AppColors.primaryColor : AppColors.inputBorder),
                ),
                child: Row(
                  children: [
                    Icon(Icons.pedal_bike, color: selectedBike != null ? AppColors.primaryColor : AppColors.grey, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(selectedBike ?? 'Bike', style: TextStyle(color: selectedBike != null ? AppColors.textDark : AppColors.grey, fontSize: 13, fontWeight: selectedBike != null ? FontWeight.w600 : FontWeight.normal), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Services for Bikes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark))),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: serviceCategories.length,
            itemBuilder: (context, index) {
              final service = serviceCategories[index];
              return Container(
                width: 80, margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  children: [
                    Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(color: (service['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
                      child: Icon(service['icon'], color: service['color'], size: 26),
                    ),
                    const SizedBox(height: 6),
                    Text(service['name'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textDark), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Trending Services', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark)),
            Text('See All', style: TextStyle(fontSize: 14, color: AppColors.primaryColor, fontWeight: FontWeight.w600)),
          ]),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 115,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: trendingServices.length,
            itemBuilder: (context, index) {
              final service = trendingServices[index];
              return Column(
                children: [
                  Container(
                    width: 85, height: 85, margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
                    ),
                    child: service['image'] != null
                        ? ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.network(service['image'], fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.pedal_bike, color: AppColors.primaryColor, size: 32)))
                        : const Center(child: Icon(Icons.pedal_bike, color: AppColors.primaryColor, size: 32)),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(width: 85, child: Text(service['name'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textDark), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTailoredServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Tailored Services', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark))),
        const SizedBox(height: 16),
        SizedBox(
          height: 115,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: tailoredServices.length,
            itemBuilder: (context, index) {
              final service = tailoredServices[index];
              return Column(
                children: [
                  Container(
                    width: 85, height: 85, margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))]),
                    child: service['image'] != null
                        ? ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.network(service['image'], fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.card_membership, color: AppColors.primaryColor, size: 32)))
                        : const Center(child: Icon(Icons.card_membership, color: AppColors.primaryColor, size: 32)),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(width: 85, child: Text(service['name'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textDark), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHowItWorks() {
    final steps = [
      {'title': 'Select Service', 'description': 'Choose from our wide range', 'icon': Icons.pedal_bike},
      {'title': 'Track Real-Time', 'description': 'Get live updates', 'icon': Icons.location_searching},
      {'title': 'Earn Rewards', 'description': 'Get discounts', 'icon': Icons.card_giftcard},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('How Fixio Works', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark))),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text('${index + 1}', style: const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(step['icon'] as IconData, color: AppColors.primaryColor, size: 16),
                              const SizedBox(width: 6),
                              Expanded(child: Text(step['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark))),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(step['description'] as String, style: const TextStyle(fontSize: 12, color: AppColors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
