import 'package:flutter/material.dart';

class TimecardScreen extends StatelessWidget {
  const TimecardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for now
    final List<Map<String, String>> timecards = [
      {
        "date": "April 23, 2025",
        "start": "08:00 AM",
        "end": "04:00 PM",
        "note": "Route 12 - Westside"
      },
      {
        "date": "April 22, 2025",
        "start": "07:30 AM",
        "end": "03:30 PM",
        "note": "Yard work"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timecards'),
        backgroundColor: const Color(0xFF15385E),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to new timecard form
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('New Timecard Form (coming soon)')),
              );
            },
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: timecards.length,
        itemBuilder: (context, index) {
          final timecard = timecards[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.access_time, color: Color(0xFF15385E)),
              title: Text(timecard["date"] ?? ""),
              subtitle: Text(
                  "${timecard["start"]} - ${timecard["end"]}\n${timecard["note"]}"),
              isThreeLine: true,
              onTap: () {
                // TODO: Navigate to detail view
              },
            ),
          );
        },
      ),
    );
  }
}