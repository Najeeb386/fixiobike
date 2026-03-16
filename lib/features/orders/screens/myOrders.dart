import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Sample orders data
  final List<Order> allOrders = [
    Order(
      id: 'ORD-001',
      orderNumber: '12345',
      date: DateTime(2024, 1, 15),
      total: 2500.00,
      items: 'Oil Filter, Air Filter',
      status: 'Completed',
    ),
    Order(
      id: 'ORD-002',
      orderNumber: '12346',
      date: DateTime(2024, 1, 18),
      total: 1500.00,
      items: 'Brake Pads',
      status: 'Invoiced',
    ),
    Order(
      id: 'ORD-003',
      orderNumber: '12347',
      date: DateTime(2024, 1, 20),
      total: 3500.00,
      items: 'Tire, Tube',
      status: 'Pending',
    ),
    Order(
      id: 'ORD-004',
      orderNumber: '12348',
      date: DateTime(2024, 1, 22),
      total: 800.00,
      items: 'Chain Lubricant',
      status: 'Completed',
    ),
    Order(
      id: 'ORD-005',
      orderNumber: '12349',
      date: DateTime(2024, 1, 25),
      total: 4200.00,
      items: 'Spark Plugs, Clutch Plate',
      status: 'Pending',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Order> get filteredOrders {
    switch (_tabController.index) {
      case 1:
        return allOrders.where((o) => o.status == 'Pending').toList();
      case 2:
        return allOrders.where((o) => o.status == 'Invoiced').toList();
      case 3:
        return allOrders.where((o) => o.status == 'Completed').toList();
      default:
        return allOrders;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        title: const Text('My Orders', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          onTap: (index) {
            setState(() {});
          },
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Invoiced'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(allOrders),
          _buildOrderList(allOrders.where((o) => o.status == 'Pending').toList()),
          _buildOrderList(allOrders.where((o) => o.status == 'Invoiced').toList()),
          _buildOrderList(allOrders.where((o) => o.status == 'Completed').toList()),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No orders found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index]);
      },
    );
  }

  Widget _buildOrderCard(Order order) {
    Color statusColor;
    switch (order.status) {
      case 'Pending':
        statusColor = Colors.orange;
        break;
      case 'Invoiced':
        statusColor = Colors.blue;
        break;
      case 'Completed':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

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
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.shopping_bag,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.orderNumber,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Order ID: ${order.id}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: AppColors.grey),
              const SizedBox(width: 6),
              Text(
                _formatDate(order.date),
                style: const TextStyle(fontSize: 12, color: AppColors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.inventory_2_outlined, size: 14, color: AppColors.grey),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  order.items,
                  style: const TextStyle(fontSize: 12, color: AppColors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  color: AppColors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                'Rs. ${order.total.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Order Model
class Order {
  final String id;
  final String orderNumber;
  final DateTime date;
  final double total;
  final String items;
  final String status;

  Order({
    required this.id,
    required this.orderNumber,
    required this.date,
    required this.total,
    required this.items,
    required this.status,
  });
}
