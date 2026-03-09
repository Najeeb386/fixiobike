import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixiobike/features/fuel/screens/add_fuel_expense.dart';
import 'package:fixiobike/core/constants/app_colors.dart';
import 'package:fixiobike/features/fuel/model/fuel_expense_model.dart';
import 'package:fixiobike/features/fuel/screens/update_fuel_expense.dart';

// ─── Model ───────────────────────────────────────────────────────────────────

class FuelExpense {
  final String id;
  final String brand;
  final String model;
  final String plate;
  final DateTime dateTime;
  final String vendor;
  final double odometerReading;
  final double fuelQuantity;
  final double costPerUnit;
  final String? imageUrl;
  final String? note;

  FuelExpense({
    required this.id,
    required this.brand,
    required this.model,
    required this.plate,
    required this.dateTime,
    required this.vendor,
    required this.odometerReading,
    required this.fuelQuantity,
    required this.costPerUnit,
    this.imageUrl,
    this.note,
  });

  double get totalPrice => fuelQuantity * costPerUnit;
}

// ─── Constants ────────────────────────────────────────────────────────────────

class AppColors {
  static const Color primary = Color(0xFF2BC5BF);
  static const Color background = Color(0xFFEFEFEF);
  static const Color white = Colors.white;
  static const Color textDark = Color(0xFF111111);
  static const Color textGrey = Color(0xFFAAAAAA);
  static const Color tagBg = Color(0xFFEBEBEB);
  static const Color divider = Color(0xFFF2F2F2);
  static const Color cardBorder = Color(0xFFE0E0E0);
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class FuelLog extends StatefulWidget {
  const FuelLog({super.key});

  @override
  State<FuelLog> createState() => _FuelLogState();
}

class _FuelLogState extends State<FuelLog> {
  List<FuelExpense> _expenses = [
    FuelExpense(
      id: '1',
      brand: 'Changan',
      model: 'Sedan',
      plate: 'KJH887',
      dateTime: DateTime(2026, 3, 9, 15, 1),
      vendor: 'PSO',
      odometerReading: 1,
      fuelQuantity: 5.0,
      costPerUnit: 330,
    ),
  ];

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _formatDateTime(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final day = dt.day.toString().padLeft(2, '0');
    final month = months[dt.month - 1];
    final year = dt.year;
    final hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = (hour % 12 == 0 ? 12 : hour % 12).toString().padLeft(2, '0');
    return '$day $month $year at $displayHour:$minute $period';
  }

  // ── Navigation ────────────────────────────────────────────────────────────

   void _addExpense() {
    Get.to(() => const AddFuelExpense());
   }

  void _openExpense(FuelExpense expense) {
    // Navigate to update screen
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _expenses.isEmpty ? _buildEmpty() : _buildList(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.white),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        'Fuel Expenses',
        style: TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_gas_station_outlined,
              size: 80, color: AppColors.textGrey.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text('No fuel expenses yet',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGrey)),
          const SizedBox(height: 8),
          const Text(
            'Tap the button below to add your first fuel expense',
            style: TextStyle(fontSize: 14, color: AppColors.textGrey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: _expenses.length,
      itemBuilder: (context, index) => _buildCard(_expenses[index]),
    );
  }

  // ── Card ──────────────────────────────────────────────────────────────────

  Widget _buildCard(FuelExpense expense) {
    return GestureDetector(
      onTap: () => _openExpense(expense),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Top row: vehicle info + receipt icon
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Vehicle info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand - Model + plate badge
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            Text(
                              '${expense.brand} - ${expense.model}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                                letterSpacing: -0.2,
                              ),
                            ),
                            _buildPlateBadge(expense.plate),
                          ],
                        ),
                        const SizedBox(height: 5),
                        // Date & time
                        Text(
                          _formatDateTime(expense.dateTime),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Receipt + coin icon
                  _buildReceiptIcon(),
                ],
              ),
            ),

            // ── Divider
            const Divider(height: 1, thickness: 1, color: AppColors.divider),

            // ── Bottom tag row
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Row(
                children: [
                  _buildTag(expense.vendor),
                  const SizedBox(width: 8),
                  _buildTag('${expense.odometerReading.toStringAsFixed(0)} kms'),
                  const SizedBox(width: 8),
                  _buildTag('${expense.fuelQuantity} Litre'),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTag(expense.totalPrice.toStringAsFixed(0), expand: true)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlateBadge(String plate) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        plate,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  Widget _buildTag(String label, {bool expand = false}) {
    final child = Container(
      padding: EdgeInsets.symmetric(
          horizontal: expand ? 0 : 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.tagBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        textAlign: expand ? TextAlign.center : TextAlign.start,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textDark,
        ),
      ),
    );
    return expand ? child : child;
  }

  Widget _buildReceiptIcon() {
    return SizedBox(
      width: 58,
      height: 58,
      child: CustomPaint(painter: _ReceiptIconPainter()),
    );
  }

  // ── Bottom bar ────────────────────────────────────────────────────────────

  Widget _buildBottomBar() {
    return SafeArea(
      top: false,
      child: GestureDetector(
        onTap: _addExpense,
        child: Container(
          width: double.infinity,
          color: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: const Text(
            'Add Fuel Expense',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Receipt + Coin Custom Painter ───────────────────────────────────────────

class _ReceiptIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final darkPaint = Paint()..color = const Color(0xFF1A1A1A);
    final whitePaint = Paint()..color = Colors.white;
    final greyPaint = Paint()..color = const Color(0xFFCCCCCC);
    final goldPaint = Paint()..color = const Color(0xFFE8B800);
    final goldDarkPaint = Paint()..color = const Color(0xFFC89F00);

    final w = size.width;
    final h = size.height;

    // ── Back receipt (rotated slightly)
    canvas.save();
    canvas.translate(w * 0.1, h * 0.05);
    canvas.rotate(-0.18);
    final backRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w * 0.55, h * 0.72),
      const Radius.circular(5),
    );
    canvas.drawRRect(backRect, darkPaint);
    canvas.restore();

    // ── Front receipt body
    final receiptRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.12, 0, w * 0.55, h * 0.72),
      const Radius.circular(5),
    );
    canvas.drawRRect(receiptRect, darkPaint);

    // Inner white paper
    final innerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.15, h * 0.03, w * 0.49, h * 0.66),
      const Radius.circular(3),
    );
    canvas.drawRRect(innerRect, whitePaint);

    // Header band (black with "EXPENSES" text)
    final headerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.15, h * 0.03, w * 0.49, h * 0.15),
      const Radius.circular(3),
    );
    canvas.drawRRect(headerRect, darkPaint);

    // Lines on receipt
    final lineLeft = w * 0.18;
    final lineWidth = w * 0.40;
    for (int i = 0; i < 4; i++) {
      final y = h * (0.24 + i * 0.10);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(lineLeft, y, i == 2 ? lineWidth * 0.7 : lineWidth, 2.5),
          const Radius.circular(1),
        ),
        greyPaint,
      );
    }

    // ── Coin stack (bottom right)
    final coinCx = w * 0.78;
    final coinRx = w * 0.20;
    final coinRy = h * 0.065;
    final coinPositions = [h * 0.88, h * 0.80, h * 0.72, h * 0.64];
    for (int i = 0; i < coinPositions.length; i++) {
      final cy = coinPositions[i];
      canvas.drawOval(Rect.fromCenter(center: Offset(coinCx, cy), width: coinRx * 2, height: coinRy * 2), darkPaint);
      canvas.drawOval(Rect.fromCenter(center: Offset(coinCx, cy - h * 0.025), width: coinRx * 2, height: coinRy * 2),
          i % 2 == 0 ? goldPaint : goldDarkPaint);
    }

    // Dollar sign on top coin
    final tp = TextPainter(
      text: const TextSpan(
        text: '\$',
        style: TextStyle(
          color: Color(0xFF111111),
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(coinCx - 4.5, coinPositions.last - h * 0.07));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}