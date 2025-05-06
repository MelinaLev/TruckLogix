import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/timecard_model.dart';
import '../services/timecard_service.dart';
import '../../tickets/services/ticket_service.dart';

class TimecardDetailScreen extends StatefulWidget {
  final DateTime date;

  const TimecardDetailScreen({
    super.key,
    required this.date,
  });

  @override
  State<TimecardDetailScreen> createState() => _TimecardDetailScreenState();
}

class _TimecardDetailScreenState extends State<TimecardDetailScreen> {
  final TimecardService _timecardService = TimecardService();
  final TicketService _ticketService = TicketService();
  late Timecard _timecard;
  bool _isLoading = true;
  final TextEditingController _commentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTimecard();
  }

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  Future<void> _loadTimecard() async {
    setState(() {
      _isLoading = true;
    });

    // Get or create timecard for this week
    final timecard = _timecardService.getTimecardForWeek(widget.date);

    if (timecard != null) {
      _timecard = timecard;
      _commentsController.text = timecard.comments ?? '';
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _submitTimecard() {
    // Update comments if changed
    if (_commentsController.text != (_timecard.comments ?? '')) {
      _timecard = _timecard.copyWith(
        comments: _commentsController.text,
        updatedAt: DateTime.now(),
      );
      _timecardService.updateTimecard(_timecard);
    }

    // Submit timecard
    _timecardService.submitTimecard(_timecard);

    // Refresh state
    setState(() {
      _timecard = _timecard.copyWith(status: 'submitted');
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Timecard submitted successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Timecard'),
          backgroundColor: const Color(0xFF15385E),
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timecard'),
        backgroundColor: const Color(0xFF15385E),
        foregroundColor: Colors.white,
        actions: [
          if (_timecard.status == 'draft')
            TextButton(
              onPressed: _submitTimecard,
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildDailyEntries(),
            const SizedBox(height: 24),
            _buildSummary(),
            const SizedBox(height: 24),
            _buildComments(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Week ${_timecard.weekNumber}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(_timecard.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _timecard.formattedDateRange,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoColumn(
                    'Regular Hours',
                    _timecard.totalRegularHours.toStringAsFixed(1),
                  ),
                ),
                Expanded(
                  child: _buildInfoColumn(
                    'Overtime Hours',
                    _timecard.totalOvertimeHours.toStringAsFixed(1),
                  ),
                ),
                Expanded(
                  child: _buildInfoColumn(
                    'Total Hours',
                    _timecard.totalHours.toStringAsFixed(1),
                    isHighlighted: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value,
      {bool isHighlighted = false}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isHighlighted ? 18 : 16,
            fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
            color: isHighlighted ? const Color(0xFF15385E) : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String statusText;

    switch (status) {
      case 'draft':
        chipColor = Colors.grey;
        statusText = 'Draft';
        break;
      case 'submitted':
        chipColor = Colors.blue;
        statusText = 'Submitted';
        break;
      case 'approved':
        chipColor = Colors.green;
        statusText = 'Approved';
        break;
      case 'rejected':
        chipColor = Colors.red;
        statusText = 'Rejected';
        break;
      default:
        chipColor = Colors.grey;
        statusText = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: chipColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDailyEntries() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Entries',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildDayHeader(),
              for (int i = 0; i < 7; i++)
                _buildDayRow(_timecard.weekStartDate.add(Duration(days: i))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF15385E).withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Day',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'In/Out',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Reg Hours',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'OT Hours',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayRow(DateTime day) {
    final DateFormat dayFormat = DateFormat('E, MMM d');
    final DateFormat timeFormat = DateFormat('h:mm a');
    final List<TimecardEntry> entries = _timecard.getEntriesForDay(day);

    // Calculate totals for the day
    double regularHours = 0;
    double overtimeHours = 0;

    for (var entry in entries) {
      regularHours += entry.regularHours;
      overtimeHours += entry.overtimeHours;
    }

    // Determine if this is today
    final bool isToday = day.year == DateTime.now().year &&
        day.month == DateTime.now().month &&
        day.day == DateTime.now().day;

    return Container(
      decoration: BoxDecoration(
        color: isToday ? Colors.yellow.withOpacity(0.1) : null,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            // Day column
            Expanded(
              flex: 2,
              child: Text(
                dayFormat.format(day),
                style: TextStyle(
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),

            // In/Out times column
            Expanded(
              flex: 2,
              child: entries.isEmpty
                  ? const Text('-')
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: entries.map((entry) {
                  String inOutText = '';
                  if (entry.date is DateTime) {
                    final ticket = _ticketService.getTicketById(entry.ticketId);
                    if (ticket != null &&
                        ticket.beginTime != null &&
                        ticket.endTime != null) {
                      inOutText = '${timeFormat.format(ticket.beginTime!)} - ${timeFormat.format(ticket.endTime!)}';
                    }
                  }
                  return Text(
                    inOutText.isEmpty ? '- / -' : inOutText,
                    style: const TextStyle(fontSize: 13),
                  );
                }).toList(),
              ),
            ),

            // Regular hours column
            Expanded(
              flex: 2,
              child: Text(
                regularHours > 0 ? regularHours.toStringAsFixed(1) : '-',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Overtime hours column
            Expanded(
              flex: 2,
              child: Text(
                overtimeHours > 0 ? overtimeHours.toStringAsFixed(1) : '-',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekly Summary',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSummaryRow('Regular Hours', _timecard.totalRegularHours.toStringAsFixed(1)),
                const SizedBox(height: 8),
                _buildSummaryRow('Overtime Hours', _timecard.totalOvertimeHours.toStringAsFixed(1)),
                const Divider(height: 24),
                _buildSummaryRow('Total Hours', _timecard.totalHours.toStringAsFixed(1), isTotal: true),
                const SizedBox(height: 16),

                // Ticket information summary
                const Divider(height: 24),
                const Text(
                  'Tickets Included',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),

                _timecard.entries.isEmpty
                    ? const Text('No tickets for this week', style: TextStyle(fontStyle: FontStyle.italic))
                    : Column(
                  children: _buildTicketsList(),
                ),

                const SizedBox(height: 16),
                const Text(
                  'Hours are automatically calculated from your tickets.',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTicketsList() {
    // Get unique tickets
    final Set<String> uniqueTicketIds = {};
    for (var entry in _timecard.entries) {
      uniqueTicketIds.add(entry.ticketId);
    }

    return uniqueTicketIds.map((ticketId) {
      final ticket = _ticketService.getTicketById(ticketId);
      if (ticket == null) {
        return ListTile(
          title: Text('Ticket #$ticketId'),
          subtitle: const Text('Ticket details not available'),
          dense: true,
        );
      }

      return ListTile(
        title: Text('Ticket #$ticketId'),
        subtitle: Text('${ticket.location ?? 'No location'} • ${DateFormat('MMM d').format(ticket.date)}'),
        trailing: Text(
          '${_getTicketHours(ticketId).toStringAsFixed(1)} hrs',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        dense: true,
      );
    }).toList();
  }

  double _getTicketHours(String ticketId) {
    double hours = 0;
    for (var entry in _timecard.entries) {
      if (entry.ticketId == ticketId) {
        hours += entry.totalHours;
      }
    }
    return hours;
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildComments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comments',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _commentsController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Add any comments about this timecard...',
                    border: OutlineInputBorder(),
                  ),
                  enabled: _timecard.status == 'draft',
                ),
                const SizedBox(height: 8),
                const Text(
                  'Comments are visible to your supervisor.',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (_timecard.status == 'draft')
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF15385E),
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _submitTimecard,
              child: const Text(
                'Submit Timecard',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}