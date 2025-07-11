// lib/features/tickets/services/ticket_service.dart
import '../models/ticket.dart';

class TicketService {
  static final TicketService _instance = TicketService._internal();
  factory TicketService() => _instance;
  TicketService._internal();

  final List<Ticket> _tickets = [];

  // Get all tickets
  List<Ticket> getAllTickets() {
    return List.from(_tickets);
  }

  // Add a new ticket
  Future<void> addTicket(Ticket ticket) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    _tickets.add(ticket);
  }

  // Get ticket by ID
  Ticket? getTicketById(String id) {
    try {
      return _tickets.firstWhere((ticket) => ticket.id == id);
    } catch (e) {
      return null;
    }
  }

  // Generate a new ticket ID
  String generateTicketId() {
    // Simple ID generation - in production, use UUID or server-generated ID
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'TKT-${timestamp.toString().substring(8)}';
  }

  // Update ticket status
  Future<void> updateTicketStatus(String ticketId, String status) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _tickets.indexWhere((ticket) => ticket.id == ticketId);
    if (index != -1) {
      _tickets[index] = _tickets[index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
    }
  }

  // Delete ticket
  Future<void> deleteTicket(String ticketId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _tickets.removeWhere((ticket) => ticket.id == ticketId);
  }

  // Get tickets by status
  List<Ticket> getTicketsByStatus(String status) {
    return _tickets.where((ticket) => ticket.status == status).toList();
  }

  // Search tickets by customer name
  List<Ticket> searchTicketsByCustomer(String customerName) {
    return _tickets
        .where((ticket) => ticket.customerName
            .toLowerCase()
            .contains(customerName.toLowerCase()))
        .toList();
  }

  // Add sample tickets for demo
  Future<void> addSampleTickets() async {
    if (_tickets.isNotEmpty) return; // Don't add if tickets already exist

    final sampleTickets = [
      Ticket(
        id: '235383',
        bookingNumber: '7807',
        customerName: 'Lone Star Trucking',
        rig: 'Rig 15',
        location: 'Midland TX, 79706',
        date: DateTime(2025, 4, 28),
        beginTime: DateTime(2025, 4, 28, 8, 0),
        endTime: DateTime(2025, 4, 28, 16, 30),
        unitNumber: 'TRK-001',
        workOrderNumber: 'WO-2025-001',
        afeNumber: 'AFE-12345',
        description: 'Water transport to rig site',
        status: 'completed',
        createdAt: DateTime(2025, 4, 28, 8, 0),
      ),
      Ticket(
        id: '235382',
        bookingNumber: '7806',
        customerName: 'ABC Transport',
        rig: 'Rig 22',
        location: 'Dallas, TX',
        date: DateTime(2025, 4, 26),
        beginTime: DateTime(2025, 4, 26, 9, 15),
        endTime: DateTime(2025, 4, 26, 14, 45),
        unitNumber: 'TRK-002',
        workOrderNumber: 'WO-2025-002',
        afeNumber: 'AFE-12346',
        description: 'Equipment transport',
        status: 'pending',
        createdAt: DateTime(2025, 4, 26, 10, 15),
      ),
      Ticket(
        id: '235381',
        customerName: 'Johnson Logistics',
        rig: 'Rig 8',
        location: 'El Paso, TX',
        date: DateTime(2025, 4, 25),
        beginTime: DateTime(2025, 4, 25, 7, 30),
        unitNumber: 'TRK-003',
        workOrderNumber: 'WO-2025-003',
        description: 'Material delivery',
        status: 'in progress',
        createdAt: DateTime(2025, 4, 25, 9, 0),
      ),
      Ticket(
        id: '235380',
        bookingNumber: '7805',
        customerName: 'Pioneer Resources',
        rig: 'Rig 12',
        location: 'Odessa, TX',
        date: DateTime(2025, 4, 24),
        unitNumber: 'TRK-004',
        workOrderNumber: 'WO-2025-004',
        afeNumber: 'AFE-12347',
        description: 'Mud transport',
        status: 'submitted',
        createdAt: DateTime(2025, 4, 24, 14, 30),
      ),
    ];

    for (final ticket in sampleTickets) {
      _tickets.add(ticket);
    }
  }
}
