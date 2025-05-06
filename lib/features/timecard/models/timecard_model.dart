import 'package:intl/intl.dart';
import '../../tickets/models/ticket_model.dart';

class TimecardEntry {
  final String ticketId;
  final DateTime date;
  final String? location;
  final double regularHours;
  final double overtimeHours;
  final double totalHours;

  TimecardEntry({
    required this.ticketId,
    required this.date,
    this.location,
    required this.regularHours,
    required this.overtimeHours,
    required this.totalHours,
  });

  // Create a TimecardEntry from a Ticket
  factory TimecardEntry.fromTicket(Ticket ticket) {
    double regularHours = 0;
    double overtimeHours = 0;
    double totalHours = 0;

    // Calculate total hours
    if (ticket.beginTime != null && ticket.endTime != null) {
      final Duration duration = ticket.endTime!.difference(ticket.beginTime!);
      totalHours = duration.inMinutes / 60.0;

      // Determine regular vs overtime based on type or other factors
      if (ticket.ticketType == 'OT') {
        overtimeHours = totalHours;
      } else {
        // Assume 8 hours is standard, anything over is overtime
        regularHours = totalHours > 8 ? 8 : totalHours;
        overtimeHours = totalHours > 8 ? totalHours - 8 : 0;
      }
    }

    return TimecardEntry(
      ticketId: ticket.id,
      date: ticket.date,
      location: ticket.location,
      regularHours: regularHours,
      overtimeHours: overtimeHours,
      totalHours: totalHours,
    );
  }
}

class Timecard {
  final DateTime weekStartDate; // Monday
  final DateTime weekEndDate;   // Sunday
  final List<TimecardEntry> entries;
  final String status; // draft, submitted, approved, rejected
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? comments;

  Timecard({
    required this.weekStartDate,
    required this.weekEndDate,
    required this.entries,
    required this.status,
    required this.createdAt,
    this.updatedAt,
    this.comments,
  });

  // Calculate total regular hours for the week
  double get totalRegularHours {
    return entries.fold(0, (sum, entry) => sum + entry.regularHours);
  }

  // Calculate total overtime hours for the week
  double get totalOvertimeHours {
    return entries.fold(0, (sum, entry) => sum + entry.overtimeHours);
  }

  // Calculate total hours (regular + overtime) for the week
  double get totalHours {
    return entries.fold(0, (sum, entry) => sum + entry.totalHours);
  }

  // Get entries for a specific day
  List<TimecardEntry> getEntriesForDay(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    return entries.where((entry) {
      final entryDay = DateTime(entry.date.year, entry.date.month, entry.date.day);
      return entryDay.isAtSameMomentAs(day);
    }).toList();
  }

  // Get formatted date range (e.g., "May 1 - May 7, 2025")
  String get formattedDateRange {
    final DateFormat formatter = DateFormat('MMM d');
    final DateFormat yearFormatter = DateFormat('MMM d, yyyy');

    if (weekStartDate.year == weekEndDate.year &&
        weekStartDate.month == weekEndDate.month) {
      // Same month and year
      return '${formatter.format(weekStartDate)} - ${yearFormatter.format(weekEndDate)}';
    } else if (weekStartDate.year == weekEndDate.year) {
      // Same year, different month
      return '${formatter.format(weekStartDate)} - ${yearFormatter.format(weekEndDate)}';
    } else {
      // Different year
      return '${yearFormatter.format(weekStartDate)} - ${yearFormatter.format(weekEndDate)}';
    }
  }

  // Calculate week number of the year
  int get weekNumber {
    // The week containing January 4th is defined as week 1
    // See: https://en.wikipedia.org/wiki/ISO_week_date
    final dayOfYear = int.parse(DateFormat('D').format(weekStartDate));
    return ((dayOfYear - weekStartDate.weekday + 10) / 7).floor();
  }

  // Create a copy of the timecard with updated fields
  Timecard copyWith({
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    List<TimecardEntry>? entries,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? comments,
  }) {
    return Timecard(
      weekStartDate: weekStartDate ?? this.weekStartDate,
      weekEndDate: weekEndDate ?? this.weekEndDate,
      entries: entries ?? this.entries,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      comments: comments ?? this.comments,
    );
  }
}