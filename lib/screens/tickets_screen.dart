import 'package:flutter/material.dart';
import '../features/tickets/screens/ticket_list_screen.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    const TicketListScreen(), // Shows all tickets
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
        backgroundColor: const Color(0xFF15385E),
        foregroundColor: Colors.white,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'All Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'New Ticket',
          ),
        ],
        selectedItemColor: const Color(0xFF15385E),
      ),
    );
  }
}
