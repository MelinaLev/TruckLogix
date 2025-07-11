import '../models/timecard_model.dart';
import '../../tickets/services/ticket_service.dart';
import '../../tickets/models/ticket.dart';

class TimecardService {
  // Singleton instance
  static final TimecardService _instance = TimecardService._internal();
  factory TimecardService() => _instance;
  TimecardService._internal();

  // Mock storage for timecards
  final List<Timecard> _timecards = [];

  // Get the ticket service to access ticket data
  final TicketService _ticketService = TicketService();

  // Get all timecards
  List<Timecard> getAllTimecards() {
    return _timecards;
  }

  // Get a timecard for a specific week
  Timecard? getTimecardForWeek(DateTime date) {
    // Find the Monday of the week
    final weekStart = _findWeekStartDate(date);
    final weekEnd = weekStart.add(const Duration(days: 6)); // Sunday

    try {
      return _timecards.firstWhere(
              (timecard) =>
          timecard.weekStartDate.year == weekStart.year &&
              timecard.weekStartDate.month == weekStart.month &&
              timecard.weekStartDate.day == weekStart.day
      );
    } catch (e) {
      // No timecard found for this week, create one
      return createTimecardForWeek(date);
    }
  }

  // Create a new timecard for a specific week
  Timecard createTimecardForWeek(DateTime date) {
    // Find the Monday of the week
    final weekStart = _findWeekStartDate(date);
    final weekEnd = weekStart.add(const Duration(days: 6)); // Sunday

    // Check if timecard already exists
    try {
      return _timecards.firstWhere(
              (timecard) =>
          timecard.weekStartDate.year == weekStart.year &&
              timecard.weekStartDate.month == weekStart.month &&
              timecard.weekStartDate.day == weekStart.day
      );
    } catch (e) {
      // Timecard doesn't exist, create a new one
      final tickets = _getTicketsForDateRange(weekStart, weekEnd);
      final entries = tickets.map((ticket) => TimecardEntry.fromTicket(ticket)).toList();

      final timecard = Timecard(
        weekStartDate: weekStart,
        weekEndDate: weekEnd,
        entries: entries,
        status: 'draft',
        createdAt: DateTime.now(),
      );

      _timecards.add(timecard);
      return timecard;
    }
  }

  // Update an existing timecard
  void updateTimecard(Timecard timecard) {
    final index = _timecards.indexWhere(
            (t) =>
        t.weekStartDate.year == timecard.weekStartDate.year &&
            t.weekStartDate.month == timecard.weekStartDate.month &&
            t.weekStartDate.day == timecard.weekStartDate.day
    );

    if (index != -1) {
      _timecards[index] = timecard.copyWith(
        updatedAt: DateTime.now(),
      );
    }
  }

  // Submit timecard for approval
  void submitTimecard(Timecard timecard) {
    final updatedTimecard = timecard.copyWith(
      status: 'submitted',
      updatedAt: DateTime.now(),
    );

    updateTimecard(updatedTimecard);
  }

  // Helper to find the Monday of the week for a given date
  DateTime _findWeekStartDate(DateTime date) {
    // Find the Monday of this week (weekday 1 = Monday, 7 = Sunday)
    final int daysToSubtract = date.weekday - 1;
    return DateTime(date.year, date.month, date.day - daysToSubtract);
  }

  // Helper to get all tickets for a date range
  List<Ticket> _getTicketsForDateRange(DateTime startDate, DateTime endDate) {
    final tickets = _ticketService.getAllTickets();

    // Normalize dates to compare only year, month, day
    final startDay = DateTime(startDate.year, startDate.month, startDate.day);
    final endDay = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    return tickets.where((ticket) {
      final ticketDate = DateTime(ticket.date.year, ticket.date.month, ticket.date.day);
      return !ticketDate.isBefore(startDay) && !ticketDate.isAfter(endDay);
    }).toList();
  }

  // Get all available weeks that have tickets (for timecard selection)
  List<Map<String, dynamic>> getAvailableWeeks() {
    // Get all tickets
    final tickets = _ticketService.getAllTickets();

    // If no tickets, return current week
    if (tickets.isEmpty) {
      final now = DateTime.now();
      final weekStart = _findWeekStartDate(now);
      final weekEnd = weekStart.add(const Duration(days: 6));

      return [
        {
          'weekStart': weekStart,
          'weekEnd': weekEnd,
          'hasTimecard': false,
        }
      ];
    }

    // Find earliest and latest ticket dates
    DateTime? earliestDate;
    DateTime? latestDate;

    for (final ticket in tickets) {
      if (earliestDate == null || ticket.date.isBefore(earliestDate)) {
        earliestDate = ticket.date;
      }

      if (latestDate == null || ticket.date.isAfter(latestDate)) {
        latestDate = ticket.date;
      }
    }

    // Ensure we have valid dates
    earliestDate ??= DateTime.now();
    latestDate ??= DateTime.now();

    // Find the Monday of the earliest week
    final firstWeekStart = _findWeekStartDate(earliestDate);
    // Find the Sunday of the latest week
    final lastWeekEnd = _findWeekStartDate(latestDate).add(const Duration(days: 6));

    // Generate all week ranges between firstWeekStart and lastWeekEnd
    List<Map<String, dynamic>> weeks = [];
    DateTime currentWeekStart = firstWeekStart;

    while (!currentWeekStart.isAfter(lastWeekEnd)) {
      final weekEnd = currentWeekStart.add(const Duration(days: 6));

      // Check if there's a timecard for this week
      bool hasTimecard = _timecards.any(
              (timecard) =>
          timecard.weekStartDate.year == currentWeekStart.year &&
              timecard.weekStartDate.month == currentWeekStart.month &&
              timecard.weekStartDate.day == currentWeekStart.day
      );

      weeks.add({
        'weekStart': currentWeekStart,
        'weekEnd': weekEnd,
        'hasTimecard': hasTimecard,
      });

      // Move to next week
      currentWeekStart = currentWeekStart.add(const Duration(days: 7));
    }

    // Always include current week if not already included
    final now = DateTime.now();
    final thisWeekStart = _findWeekStartDate(now);

    bool thisWeekIncluded = weeks.any(
            (week) =>
        (week['weekStart'] as DateTime).year == thisWeekStart.year &&
            (week['weekStart'] as DateTime).month == thisWeekStart.month &&
            (week['weekStart'] as DateTime).day == thisWeekStart.day
    );

    if (!thisWeekIncluded) {
      // Check if there's a timecard for the current week
      bool hasTimecard = _timecards.any(
              (timecard) =>
          timecard.weekStartDate.year == thisWeekStart.year &&
              timecard.weekStartDate.month == thisWeekStart.month &&
              timecard.weekStartDate.day == thisWeekStart.day
      );

      weeks.add({
        'weekStart': thisWeekStart,
        'weekEnd': thisWeekStart.add(const Duration(days: 6)),
        'hasTimecard': hasTimecard,
      });
    }

    // Sort weeks by date, most recent first
    weeks.sort((a, b) => (b['weekStart'] as DateTime).compareTo(a['weekStart'] as DateTime));

    return weeks;
  }
}