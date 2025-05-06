import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../services/ticket_service.dart';
import '../widgets/ticket_card.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key});

  @override
  State<TicketListScreen> createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  final TicketService _ticketService = TicketService();
  late List<Ticket> _tickets;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tickets = _ticketService.getAllTickets();
  }

  List<Ticket> get filteredTickets {
    if (_selectedFilter == 'all') {
      return _tickets;
    } else {
      return _tickets
          .where((ticket) => ticket.status == _selectedFilter)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter chips
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('All', 'all'),
                _buildFilterChip('Pending', 'pending'),
                _buildFilterChip('In Progress', 'in_progress'),
                _buildFilterChip('Completed', 'completed'),
                _buildFilterChip('Draft', 'draft'),
              ],
            ),
          ),
        ),

        // Tickets list
        Expanded(
          child: filteredTickets.isEmpty
              ? Center(
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the "New Ticket" tab to create one',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredTickets.length,
                  itemBuilder: (context, index) {
                    final ticket = filteredTickets[index];
                    return TicketCard(
                      ticket: ticket,
                      onTap: () {
                        // Navigate to ticket details
                        Navigator.pushNamed(
                          context,
                          '/ticket/details',
                          arguments: ticket.id,
                        ).then((_) {
                          // Refresh ticket list when returning
                          setState(() {
                            _tickets = _ticketService.getAllTickets();
                          });
                        });
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final bool isSelected = _selectedFilter == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
        },
        backgroundColor: Colors.grey[200],
        selectedColor: const Color(0xFF15385E).withOpacity(0.2),
        checkmarkColor: const Color(0xFF15385E),
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF15385E) : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
