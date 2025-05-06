import '../models/ticket_model.dart';

class TicketService {
  // Singleton instance
  static final TicketService _instance = TicketService._internal();
  factory TicketService() => _instance;
  TicketService._internal();

  // Mock data
  final List<Ticket> _tickets = [
    Ticket(
      id: '235383',
      customerName: 'Lone Star Trucking',
      location: 'Midland TX, 79706',
      date: DateTime(2025, 4, 28),
      beginTime: DateTime(2025, 4, 28, 8, 0),
      endTime: DateTime(2025, 4, 28, 16, 30),
      bookingNumber: '7807',
      description: 'Water transport to rig site',
      ticketType: 'OT',
      beginMileage: 12500,
      endingMileage: 12650,
      totalMileage: 150,
      totalBbls: 110.0,
      otDriveTime: '2 hours',
      otDriveTimeCharge: 120.0,
      yardTime: '1 hour',
      yardTimeCharge: 50.0,
      freshWater: '110 BBL',
      freshWaterCharge: 220.0,
      status: 'completed',
      createdAt: DateTime(2025, 4, 28, 8, 0),
      updatedAt: DateTime(2025, 4, 28, 16, 30),
    ),
    Ticket(
      id: '235382',
      customerName: 'ABC Transport',
      location: 'Dallas, TX',
      date: DateTime(2025, 4, 26),
      bookingNumber: '7806',
      description: 'Equipment transport',
      status: 'pending',
      createdAt: DateTime(2025, 4, 26, 10, 15),
    ),
    Ticket(
      id: '235381',
      customerName: 'Johnson Logistics',
      location: 'El Paso, TX',
      date: DateTime(2025, 4, 25),
      beginTime: DateTime(2025, 4, 25, 9, 0),
      ticketType: 'ST',
      status: 'in_progress',
      createdAt: DateTime(2025, 4, 25, 9, 0),
    ),
  ];

  // Get all tickets
  List<Ticket> getAllTickets() {
    return _tickets;
  }

  // Get ticket by ID
  Ticket? getTicketById(String id) {
    try {
      return _tickets.firstWhere((ticket) => ticket.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add a new ticket
  void addTicket(Ticket ticket) {
    _tickets.add(ticket);
  }

  // Update an existing ticket
  void updateTicket(Ticket updatedTicket) {
    final index =
        _tickets.indexWhere((ticket) => ticket.id == updatedTicket.id);
    if (index != -1) {
      _tickets[index] = updatedTicket;
    }
  }

  // Delete a ticket
  void deleteTicket(String id) {
    _tickets.removeWhere((ticket) => ticket.id == id);
  }

  // Generate a new ticket ID
  String generateTicketId() {
    // Find the highest ticket ID and increment by 1
    int highestId = 0;
    for (var ticket in _tickets) {
      final id = int.tryParse(ticket.id) ?? 0;
      if (id > highestId) {
        highestId = id;
      }
    }
    return (highestId + 1).toString();
  }
}
