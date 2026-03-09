import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../bikes/screens/bikes_view.dart';
import '../../fuel/screens/fuel_log.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentNavIndex = 0;

  // Sample vehicles for carousel
  final List<Map<String, dynamic>> vehicles = [
    {'name': 'Honda Civic 2023', 'number': 'ABC-1234', 'icon': Icons.directions_car},
    {'name': 'Toyota Corolla 2022', 'number': 'XYZ-5678', 'icon': Icons.directions_car},
    {'name': 'Suzuki Cultus 2021', 'number': 'PQR-9012', 'icon': Icons.directions_car},
  ];

  int _currentVehicleIndex = 0;

  // Quick actions
  final List<Map<String, dynamic>> quickActions = [
    {'name': 'Book Service', 'icon': Icons.build, 'color': Colors.blue},
    {'name': 'Log Fuel', 'icon': Icons.local_gas_station, 'color': Colors.orange},
    {'name': 'Orders', 'icon': Icons.shopping_bag, 'color': Colors.purple},
    {'name': 'Documents', 'icon': Icons.folder, 'color': Colors.teal},
  ];

  // Vehicle metrics
  final List<Map<String, dynamic>> metrics = [
    {'title': 'Fuel', 'value': '65%', 'color': Colors.orange},
    {'title': 'Service', 'value': '80%', 'color': Colors.green},
    {'title': 'Maintenance', 'value': '45%', 'color': Colors.blue},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVehicleOverview(),
            const SizedBox(height: 16),
            _buildHealthStatus(),
            const SizedBox(height: 16),
            _buildOdometerSection(),
            const SizedBox(height: 16),
            _buildQuickActions(),
            const SizedBox(height: 16),
            _buildMetricsSection(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: const TextStyle(color: Colors.white70),
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
        Builder(builder: (context) => IconButton(icon: const Icon(Icons.menu, color: Colors.white), onPressed: () => Scaffold.of(context).openDrawer())),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            color: AppColors.primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: AppColors.primaryColor),
                ),
                const SizedBox(height: 12),
                const Text('John Doe', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Text('john.doe@email.com', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.directions_car, 'My Vehicles', onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BikesView()),
                  );
                }),
                _buildDrawerItem(Icons.local_gas_station, 'My Fuel Log', onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FuelLog()),
                  );
                }),
                _buildDrawerItem(Icons.description, 'My Documents'),
                _buildDrawerItem(Icons.receipt_long, 'My Expenses'),
                _buildDrawerItem(Icons.map, 'My Trips'),
                _buildDrawerItem(Icons.settings, 'My Parts'),
                _buildDrawerItem(Icons.store, 'Parts Marketplace'),
                _buildDrawerItem(Icons.fact_check, 'My Inspections'),
                _buildDrawerItem(Icons.notifications_active, 'Service Reminders'),
                _buildDrawerItem(Icons.report, 'Accident Reports'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      onTap: onTap ?? () {},
    );
  }

  Widget _buildVehicleOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Vehicle Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark))),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: PageView.builder(
            itemCount: vehicles.length,
            onPageChanged: (index) => setState(() => _currentVehicleIndex = index),
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                      child: Icon(vehicle['icon'], color: Colors.white, size: 40),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(vehicle['name'], style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(vehicle['number'], style: const TextStyle(color: Colors.white70, fontSize: 14)),
                          const SizedBox(height: 8),
                          TextButton(onPressed: () {}, style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap), child: const Text('Change Vehicle >', style: TextStyle(color: Colors.white, fontSize: 12))),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(vehicles.length, (index) => Container(
            width: 8, height: 8, margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(shape: BoxShape.circle, color: index == _currentVehicleIndex ? AppColors.primaryColor : Colors.grey.shade300),
          )),
        ),
      ],
    );
  }

  Widget _buildHealthStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Vehicle Health Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildHealthBadge('Good', Colors.green, Icons.check_circle),
              const SizedBox(width: 12),
              _buildHealthBadge('Normal', Colors.orange, Icons.warning),
              const SizedBox(width: 12),
              _buildHealthBadge('Bad', Colors.red, Icons.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthBadge(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildOdometerSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Current Odometer', style: TextStyle(fontSize: 14, color: AppColors.grey)),
                Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Text('kms', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w600, fontSize: 12))),
              ],
            ),
            const SizedBox(height: 8),
            const Align(alignment: Alignment.centerLeft, child: Text('45,230', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.textDark))),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Log New Mileage'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 12),
          Row(
            children: quickActions.map((action) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
                  child: Column(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(color: (action['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                        child: Icon(action['icon'], color: action['color'], size: 22),
                      ),
                      const SizedBox(height: 8),
                      Text(action['name'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textDark), textAlign: TextAlign.center, maxLines: 2),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Vehicle Metrics & Cost Analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
            child: Column(
              children: [
                Row(
                  children: metrics.map((metric) {
                    return Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 60, height: 60,
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: metric['color'] as Color, width: 4)),
                            child: Center(child: Text(metric['value'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: metric['color']))),
                          ),
                          const SizedBox(height: 8),
                          Text(metric['title'], style: const TextStyle(fontSize: 12, color: AppColors.grey)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                _buildMetricRow('Fuel Efficiency Trend', '12.5 km/L', Icons.trending_up),
                const SizedBox(height: 12),
                _buildMetricRow('Total Cost of Ownership', 'Rs. 2,45,000', Icons.account_balance_wallet),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String title, String value, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 20),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 14, color: AppColors.textDark)),
          ],
        ),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryColor)),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 65,
      decoration: const BoxDecoration(color: AppColors.primaryColor),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home, 'Home'),
            _buildNavItem(1, Icons.request_quote, 'RFQs'),
            _buildNavItem(2, Icons.add_circle, ''),
            _buildNavItem(3, Icons.shopping_bag, 'Orders'),
            _buildNavItem(4, Icons.location_on, 'Nearby'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentNavIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: index == 2 ? 32 : 22),
            if (label.isNotEmpty) Text(label, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
