import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixiobike/features/accident/new_accident.dart';

/// Model representing a single accident report
class AccidentReport {
  final String vehicleName;
  final String plateNumber;
  final DateTime reportDate;
  final List<String> tags;

  const AccidentReport({
    required this.vehicleName,
    required this.plateNumber,
    required this.reportDate,
    required this.tags,
  });
}

/// Accident Reports Screen
class AccidentReportsScreen extends StatefulWidget {
  const AccidentReportsScreen({super.key});

  @override
  State<AccidentReportsScreen> createState() => _AccidentReportsScreenState();
}

class _AccidentReportsScreenState extends State<AccidentReportsScreen> {
  // Sample data — replace with real data source
  final List<AccidentReport> _reports = [
    AccidentReport(
      vehicleName: 'Changan Alsvin',
      plateNumber: 'KJH887',
      reportDate: DateTime(2026, 3, 10, 15, 32),
      tags: ['Accident', 'Collision'],
    ),
    AccidentReport(
      vehicleName: 'Changan Alsvin',
      plateNumber: 'KJH887',
      reportDate: DateTime(2026, 3, 10, 15, 22),
      tags: ['Accident', 'Collision'],
    ),
  ];

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

  void _createAccidentReport() {
    Get.to(() => const NewAccidentScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1ABFBF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Accident Reports',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Report list
            Expanded(
              child: _reports.isEmpty
                  ? const Center(
                      child: Text(
                        'No accident reports yet.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                      itemCount: _reports.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _ReportCard(
                          report: _reports[index],
                          formattedDate: _formatDateTime(_reports[index].reportDate),
                        );
                      },
                    ),
            ),

            // Bottom button
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _createAccidentReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1ABFBF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Create Accident Report',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual report card widget
class _ReportCard extends StatelessWidget {
  final AccidentReport report;
  final String formattedDate;

  const _ReportCard({
    required this.report,
    required this.formattedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vehicle name + plate badge row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.vehicleName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              // Plate number badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1ABFBF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  report.plateNumber,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Tags row
          Row(
            children: report.tags.map((tag) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: tag != report.tags.last ? 10 : 0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF424242),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}