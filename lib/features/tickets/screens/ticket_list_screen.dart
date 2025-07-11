// lib/features/tickets/screens/ticket_list_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/ticket.dart';
import '../services/ticket_service.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  final TicketService _ticketService = TicketService();
  List<Ticket> _tickets = [];
  String _selectedFilter = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    setState(() {
      _isLoading = true;
    });

    // Add some sample tickets for demo
    await _ticketService.addSampleTickets();
    _tickets = _ticketService.getAllTickets();

    setState(() {
      _isLoading = false;
    });
  }

  List<Ticket> get filteredTickets {
    if (_selectedFilter == 'All') {
      return _tickets;
    } else {
      return _tickets
          .where((ticket) =>
              ticket.status.toLowerCase() == _selectedFilter.toLowerCase())
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Tickets'),
        backgroundColor: const Color(0xFF15385E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filter Chips
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: Colors.white,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All'),
                        const SizedBox(width: 12),
                        _buildFilterChip('Pending'),
                        const SizedBox(width: 12),
                        _buildFilterChip('In Progress'),
                        const SizedBox(width: 12),
                        _buildFilterChip('Completed'),
                      ],
                    ),
                  ),
                ),

                // Tickets List
                Expanded(
                  child: filteredTickets.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _loadTickets,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredTickets.length,
                            itemBuilder: (context, index) {
                              final ticket = filteredTickets[index];
                              return _TicketCard(
                                ticket: ticket,
                                onTap: () => _onTicketTap(ticket),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildFilterChip(String label) {
    final bool isSelected = _selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF15385E) : Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected)
              const Icon(Icons.check, size: 16, color: Colors.white),
            if (isSelected) const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No tickets found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first ticket to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.list_alt,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'All Tickets',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFF15385E),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/create-ticket').then((_) {
                    _loadTickets(); // Refresh list when returning
                  });
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'New Ticket',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTicketTap(Ticket ticket) {
    // Navigate to ticket details (we'll create this later)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ticket #${ticket.id} tapped'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final Ticket ticket;
  final VoidCallback onTap;

  const _TicketCard({
    required this.ticket,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('MMMM dd, yyyy');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with ticket number and status
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getStatusColor(ticket.status),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.receipt_long,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ticket #${ticket.id}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          dateFormat.format(ticket.date),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(ticket.status),
                ],
              ),
              const SizedBox(height: 16),

              // Ticket details
              _buildDetailRow(Icons.person, 'Customer', ticket.customerName),
              if (ticket.location != null)
                _buildDetailRow(
                    Icons.location_on, 'Location', ticket.location!),
              if (ticket.description != null)
                _buildDetailRow(
                    Icons.description, 'Description', ticket.description!),
              if (ticket.rig != null)
                _buildDetailRow(Icons.business, 'Rig', ticket.rig!),
              if (ticket.beginTime != null || ticket.endTime != null)
                _buildDetailRow(Icons.access_time, 'Time', ticket.timeRange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[500],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusDisplayText(status),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _getStatusColor(status),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF10B981); // Green
      case 'in progress':
        return const Color(0xFFF59E0B); // Orange
      case 'pending':
        return const Color(0xFF3B82F6); // Blue
      case 'submitted':
        return const Color(0xFF8B5CF6); // Purple
      default:
        return Colors.grey;
    }
  }

  String _getStatusDisplayText(String status) {
    switch (status.toLowerCase()) {
      case 'in progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'submitted':
        return 'Submitted';
      default:
        return status;
    }
  }
}
