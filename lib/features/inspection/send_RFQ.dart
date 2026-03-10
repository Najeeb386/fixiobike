import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixiobike/core/constants/app_colors.dart';
import 'package:fixiobike/features/inspection/inspection.dart';

/// Send RFQ Screen for Inspection
/// Matches the "Inspection Details" screenshot UI
class SendRfqScreen extends StatefulWidget {
  final Inspection inspection;

  const SendRfqScreen({
    super.key,
    required this.inspection,
  });

  @override
  State<SendRfqScreen> createState() => _SendRfqScreenState();
}

class _SendRfqScreenState extends State<SendRfqScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _notesController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactPhoneController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    _addressController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  void _sendRfq() {
    if (_formKey.currentState!.validate()) {
      Get.snackbar(
        'Success',
        'RFQ sent successfully!',
        backgroundColor: const Color(0xFF1ABFBF),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final inspection = widget.inspection;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1ABFBF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Inspection Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Selected Vehicle Label
                      _sectionLabel('Selected Vehicle'),
                      const SizedBox(height: 8),

                      // Vehicle Card
                      _fieldContainer(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${inspection.bike.brand} ${inspection.bike.model}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8EAF6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                inspection.bike.plateNumber,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF3949AB),
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Odometer + Fuel Gauge Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionLabel('Odometer Reading'),
                                const SizedBox(height: 8),
                                _fieldContainer(
                                  child: Text(
                                    '${inspection.odometerReading}',
                                    style: _fieldTextStyle(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _sectionLabel('Fuel Gauge in %'),
                                const SizedBox(height: 8),
                                _fieldContainer(
                                  child: Text(
                                    '${inspection.fuelGauge.toInt()}',
                                    style: _fieldTextStyle(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Service Items
                      _sectionLabel('Service Items'),
                      const SizedBox(height: 8),
                      _fieldContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              inspection.additionalService,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                ),
                              ),
                              child: Text(
                                inspection.note ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1A1A1A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Vehicle Status
                      _sectionLabel('Vehicle Status'),
                      const SizedBox(height: 8),
                      _fieldContainer(
                        child: Text(
                          inspection.vehicleStatus,
                          style: _fieldTextStyle(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Deadline
                      _sectionLabel('Deadline'),
                      const SizedBox(height: 8),
                      _fieldContainer(
                        child: Text(
                          _formatDate(inspection.deadline),
                          style: _fieldTextStyle(),
                        ),
                      ),

                      const SizedBox(height: 20),

                     
                    ],
                  ),
                ),
              ),

              // Bottom Send RFQ Button
              Container(
                color: const Color(0xFFF2F2F2),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _sendRfq,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1ABFBF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Send RFQ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Grey section label above each field
  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        color: Color(0xFF9E9E9E),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// White rounded container used as a read-only display field
  Widget _fieldContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: child,
    );
  }

  /// Standard text style for read-only field values
  TextStyle _fieldTextStyle() {
    return const TextStyle(
      fontSize: 15,
      color: Color(0xFF1A1A1A),
      fontWeight: FontWeight.w400,
    );
  }

  /// Editable text input field
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required TextInputType keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF1A1A1A),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFBDBDBD),
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1ABFBF), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}