import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixiobike/core/constants/app_colors.dart';
import 'package:fixiobike/features/bikes/models/bike_model.dart';
import 'package:fixiobike/features/fuel/widgets/vehicle_bottom_sheet.dart';
import 'package:fixiobike/features/inspection/send_RFQ.dart';

/// Inspection Model
class Inspection {
  final String id;
  final Bike bike;
  final DateTime inspectionDate;
  final int odometerReading;
  final double fuelGauge; // 0-100 percentage
  final String additionalService;
  final String vehicleStatus;
  final DateTime deadline;
  final String? note;

  Inspection({
    required this.id,
    required this.bike,
    required this.inspectionDate,
    required this.odometerReading,
    required this.fuelGauge,
    required this.additionalService,
    required this.vehicleStatus,
    required this.deadline,
    this.note,
  });
}

/// Available vehicle statuses
class VehicleStatuses {
  static const List<String> statuses = [
    'Excellent',
    'Good',
    'Fair',
    'Needs Attention',
    'Critical',
  ];
}

/// Available additional services
class AdditionalServices {
  static const List<String> services = [
    'Oil Change',
    'Tire Check',
    'Brake Service',
    'Chain Maintenance',
    'Battery Check',
    'Filter Replacement',
    'General Service',
    'None',
  ];
}

/// Main Inspection Screen
class InspectionScreen extends StatefulWidget {
  const InspectionScreen({super.key});

  @override
  State<InspectionScreen> createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  List<Inspection> _inspections = [
    Inspection(
      id: '1',
      bike: Bike(
        id: '1',
        brand: 'Honda',
        model: 'CB 150',
        year: 2023,
        bodyType: 'Sports',
        plateNumber: 'ABC-1234',
      ),
      inspectionDate: DateTime(2026, 3, 9, 10, 30),
      odometerReading: 15000,
      fuelGauge: 75.0,
      additionalService: 'Oil Change',
      vehicleStatus: 'Good',
      deadline: DateTime(2026, 4, 9),
    ),
  ];

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

  // ── Helpers ───────────────────────────────────────────────────────────────

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

  String _formatDate(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  // ── Navigation ───────────────────────────────────────────────────────────

  void _addInspection() {
    Get.to(() => AddInspectionScreen(
      availableBikes: _availableBikes,
      onSave: (inspection) {
        setState(() {
          _inspections.add(inspection);
        });
      },
    ));
  }

  void _openInspection(Inspection inspection) {
    Get.to(() => SendRfqScreen(inspection: inspection));
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      body: _inspections.isEmpty ? _buildEmpty() : _buildList(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.white),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        'Inspections',
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
          Icon(Icons.assignment_outlined,
              size: 80, color: AppColors.grey.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text('No inspections yet',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey)),
          const SizedBox(height: 8),
          const Text(
            'Tap the button below to add your first inspection',
            style: TextStyle(fontSize: 14, color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: _inspections.length,
      itemBuilder: (context, index) => _buildCard(_inspections[index]),
    );
  }

  // ── Card ──────────────────────────────────────────────────────────────────

  Widget _buildCard(Inspection inspection) {
    return GestureDetector(
      onTap: () => _openInspection(inspection),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.inputBorder),
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
            // ── Top row: vehicle info + inspection icon
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
                              '${inspection.bike.brand} - ${inspection.bike.model}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textDark,
                                letterSpacing: -0.2,
                              ),
                            ),
                            _buildPlateBadge(inspection.bike.plateNumber),
                          ],
                        ),
                        const SizedBox(height: 5),
                        // Inspection date
                        Text(
                          _formatDateTime(inspection.inspectionDate),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Inspection icon
                  _buildInspectionIcon(),
                ],
              ),
            ),

            // ── Divider
            const Divider(height: 1, thickness: 1, color: AppColors.inputBorder),

            // ── Bottom tag row
           ],
        ),
      ),
    );
  }

  Widget _buildPlateBadge(String plate) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
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
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: expand ? 0 : 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
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
  }

  Widget _buildStatusTag(String status) {
    Color statusColor;
    switch (status) {
      case 'Excellent':
        statusColor = Colors.green;
        break;
      case 'Good':
        statusColor = AppColors.primaryColor;
        break;
      case 'Fair':
        statusColor = Colors.orange;
        break;
      case 'Needs Attention':
        statusColor = Colors.deepOrange;
        break;
      case 'Critical':
        statusColor = Colors.red;
        break;
      default:
        statusColor = AppColors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: statusColor,
        ),
      ),
    );
  }

  Widget _buildServiceTag(String service) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.build_outlined, size: 14, color: AppColors.primaryColor),
          const SizedBox(width: 4),
          Text(
            service,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeadlineTag(DateTime deadline) {
    final now = DateTime.now();
    final daysRemaining = deadline.difference(now).inDays;
    Color deadlineColor;
    String prefix;
    
    if (daysRemaining < 0) {
      deadlineColor = Colors.red;
      prefix = 'Overdue';
    } else if (daysRemaining <= 7) {
      deadlineColor = Colors.orange;
      prefix = '$daysRemaining days';
    } else {
      deadlineColor = AppColors.grey;
      prefix = _formatDate(deadline);
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: deadlineColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.schedule, size: 14, color: deadlineColor),
          const SizedBox(width: 4),
          Text(
            prefix,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: deadlineColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspectionIcon() {
    return SizedBox(
      width: 58,
      height: 58,
      child: CustomPaint(painter: _InspectionIconPainter()),
    );
  }

  // ── Bottom bar ────────────────────────────────────────────────────────────

  Widget _buildBottomBar() {
    return SafeArea(
      top: false,
      child: GestureDetector(
        onTap: _addInspection,
        child: Container(
          width: double.infinity,
          color: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: const Text(
            'Add Inspection',
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

// ─── Inspection Icon Custom Painter ───────────────────────────────────────

class _InspectionIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final darkPaint = Paint()..color = const Color(0xFF1A1A1A);
    final whitePaint = Paint()..color = Colors.white;
    final primaryPaint = Paint()..color = AppColors.primaryColor;
    final greyPaint = Paint()..color = const Color(0xFFCCCCCC);
    
    final w = size.width;
    final h = size.height;
    
    // Clipboard background
    final clipboardRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.15, h * 0.08, w * 0.7, h * 0.75),
      const Radius.circular(6),
    );
    canvas.drawRRect(clipboardRect, darkPaint);
    
    // White paper
    final paperRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.2, h * 0.15, w * 0.6, h * 0.55),
      const Radius.circular(3),
    );
    canvas.drawRRect(paperRect, whitePaint);
    
    // Clipboard clip
    final clipRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.3, h * 0.02, w * 0.4, h * 0.18),
      const Radius.circular(4),
    );
    canvas.drawRRect(clipRect, darkPaint);
    
    // Lines on paper
    final lineY1 = h * 0.28;
    final lineY2 = h * 0.4;
    final lineY3 = h * 0.52;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.25, lineY1, w * 0.5, 3),
        const Radius.circular(1.5),
      ),
      greyPaint,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.25, lineY2, w * 0.4, 3),
        const Radius.circular(1.5),
      ),
      greyPaint,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.25, lineY3, w * 0.45, 3),
        const Radius.circular(1.5),
      ),
      primaryPaint,
    );
    
    // Checkmark
    final checkPath = Path();
    checkPath.moveTo(w * 0.58, h * 0.58);
    checkPath.lineTo(w * 0.52, h * 0.68);
    checkPath.lineTo(w * 0.42, h * 0.56);
    
    final checkPaint = Paint()
      ..color = AppColors.primaryColor
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    
    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Add Inspection Screen
class AddInspectionScreen extends StatefulWidget {
  final List<Bike> availableBikes;
  final Function(Inspection) onSave;

  const AddInspectionScreen({
    super.key,
    required this.availableBikes,
    required this.onSave,
  });

  @override
  State<AddInspectionScreen> createState() => _AddInspectionScreenState();
}

class _AddInspectionScreenState extends State<AddInspectionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _odometerController = TextEditingController();
  final _fuelGaugeController = TextEditingController();
  final _additionalServiceController = TextEditingController();
  final _noteController = TextEditingController();

  // Selected values
  Bike? _selectedBike;
  String _selectedStatus = 'Good';
  String _selectedService = 'None';
  DateTime _inspectionDate = DateTime.now();
  DateTime _deadline = DateTime.now().add(const Duration(days: 30));

  @override
  void dispose() {
    _odometerController.dispose();
    _fuelGaugeController.dispose();
    _additionalServiceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _showVehicleSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VehicleBottomSheet(
        bikes: widget.availableBikes,
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

  void _showDatePicker({required bool isDeadline}) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isDeadline ? _deadline : _inspectionDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null && mounted) {
      setState(() {
        if (isDeadline) {
          _deadline = date;
        } else {
          _inspectionDate = date;
        }
      });
    }
  }

  void _showStatusSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildSelectorSheet(
        title: 'Select Vehicle Status',
        items: VehicleStatuses.statuses,
        selectedItem: _selectedStatus,
        onSelected: (status) {
          setState(() {
            _selectedStatus = status;
          });
          Get.back();
        },
      ),
    );
  }

  void _showServiceSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildSelectorSheet(
        title: 'Select Additional Service',
        items: AdditionalServices.services,
        selectedItem: _selectedService,
        onSelected: (service) {
          setState(() {
            _selectedService = service;
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

  void _saveInspection() {
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

      final inspection = Inspection(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        bike: _selectedBike!,
        inspectionDate: _inspectionDate,
        odometerReading: int.parse(_odometerController.text.trim()),
        fuelGauge: double.parse(_fuelGaugeController.text.trim()),
        additionalService: _selectedService,
        vehicleStatus: _selectedStatus,
        deadline: _deadline,
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
      );

      widget.onSave(inspection);
      Get.back();
    }
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Add Inspection'),
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
                  'Enter inspection details',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.grey,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Vehicle Selector
                _buildSelectorField(
                  label: 'Select Vehicle',
                  value: _selectedBike != null
                      ? '${_selectedBike!.brand} ${_selectedBike!.model} - ${_selectedBike!.plateNumber}'
                      : null,
                  hint: 'Select your bike',
                  onTap: _showVehicleSelector,
                ),
                
                const SizedBox(height: 16),
                
                // Inspection Date
                _buildSelectorField(
                  label: 'Inspection Date',
                  value: _formatDate(_inspectionDate),
                  hint: 'Select inspection date',
                  onTap: () => _showDatePicker(isDeadline: false),
                ),
                
                const SizedBox(height: 16),
                
                // Odometer Reading
                _buildTextField(
                  controller: _odometerController,
                  label: 'Odometer Reading (km)',
                  hint: 'Enter current odometer reading',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter odometer reading';
                    }
                    if (int.tryParse(value.trim()) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Fuel Gauge
                _buildTextField(
                  controller: _fuelGaugeController,
                  label: 'Fuel Gauge (%)',
                  hint: 'Enter fuel level (0-100)',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter fuel gauge reading';
                    }
                    final fuelLevel = double.tryParse(value.trim());
                    if (fuelLevel == null || fuelLevel < 0 || fuelLevel > 100) {
                      return 'Please enter a value between 0 and 100';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Additional Service
                _buildSelectorField(
                  label: 'Additional Service',
                  value: _selectedService,
                  hint: 'Select additional service',
                  onTap: _showServiceSelector,
                ),
                
                const SizedBox(height: 16),
                
                // Vehicle Status
                _buildSelectorField(
                  label: 'Vehicle Status',
                  value: _selectedStatus,
                  hint: 'Select vehicle status',
                  onTap: _showStatusSelector,
                ),
                
                const SizedBox(height: 16),
                
                // Deadline
                _buildSelectorField(
                  label: 'Deadline',
                  value: _formatDate(_deadline),
                  hint: 'Select deadline',
                  onTap: () => _showDatePicker(isDeadline: true),
                ),
                
                const SizedBox(height: 16),
                
                // Note
                _buildTextField(
                  controller: _noteController,
                  label: 'Note (Optional)',
                  hint: 'Enter any additional note',
                  keyboardType: TextInputType.text,
                  maxLines: 3,
                ),
                
                const SizedBox(height: 32),
                
                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveInspection,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Inspection',
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
    void Function(String)? onChanged,
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
          onChanged: onChanged,
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
