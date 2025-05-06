import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../features/timecard/services/timecard_service.dart';
import '../features/timecard/models/timecard_model.dart';
import '../features/timecard/screens/timecard_detail_screen.dart';

class TimecardScreen extends StatefulWidget {
  const TimecardScreen({super.key});

  @override
  State<TimecardScreen> createState() => _TimecardScreenState();
}

class _TimecardScreenState extends State<TimecardScreen> {
  final TimecardService _timecardService = TimecardService();
  late List<Map<String, dynamic>> _availableWeeks;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Get available weeks
    _availableWeeks = _timecardService.getAvailableWeeks();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timecards'),
        backgroundColor: const Color(0xFF15385E),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_availableWeeks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_busy,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No Timecards Available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create tickets to generate timecards.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _availableWeeks.length,
        itemBuilder: (context, index) {
          final week = _availableWeeks[index];
          final DateTime weekStart = week['weekStart'] as DateTime;
          final DateTime weekEnd = week['weekEnd'] as DateTime;
          final bool hasTimecard = week['hasTimecard'] as bool;

          // Format date range (e.g., "May 1 - May 7, 2025")
          final DateFormat monthDayFormat = DateFormat('MMM d');
          final DateFormat yearFormat = DateFormat('yyyy');

          String dateRange;
          if (weekStart.year == weekEnd.year && weekStart.month == weekEnd.month) {
            // Same month and year (e.g., "May 1 - 7, 2025")
            dateRange = '${monthDayFormat.format(weekStart)} - ${weekStart.day != weekEnd.day ? weekEnd.day.toString() : ""}, ${yearFormat.format(weekEnd)}';
          } else if (weekStart.year == weekEnd.year) {
            // Same year, different month (e.g., "Apr 29 - May 5, 2025")
            dateRange = '${monthDayFormat.format(weekStart)} - ${monthDayFormat.format(weekEnd)}, ${yearFormat.format(weekEnd)}';
          } else {
            // Different year (e.g., "Dec 30 - Jan 5, 2024-2025")
            dateRange = '${monthDayFormat.format(weekStart)}, ${yearFormat.format(weekStart)} - ${monthDayFormat.format(weekEnd)}, ${yearFormat.format(weekEnd)}';
          }

          // Week number
          final int weekNumber = ((weekStart.difference(DateTime(weekStart.year, 1, 1)).inDays) / 7).floor() + 1;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimecardDetailScreen(date: weekStart),
                  ),
                ).then((_) {
                  // Refresh data when returning from detail screen
                  _loadData();
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF15385E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Week $weekNumber',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (hasTimecard)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Created',
                              style: TextStyle(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      dateRange,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to ${hasTimecard ? 'view' : 'create'} timecard',
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}