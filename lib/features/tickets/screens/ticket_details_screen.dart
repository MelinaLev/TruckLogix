import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/ticket_model.dart';
import '../services/ticket_service.dart';
import 'ticket_form_screen.dart';

class TicketDetailsScreen extends StatefulWidget {
  final String ticketId;

  const TicketDetailsScreen({
    super.key,
    required this.ticketId,
  });

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  final TicketService _ticketService = TicketService();
  Ticket? _ticket;

  @override
  void initState() {
    super.initState();
    _loadTicket();
  }

  void _loadTicket() {
    _ticket = _ticketService.getTicketById(widget.ticketId);
  }

  @override
  Widget build(BuildContext context) {
    if (_ticket == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ticket Details'),
          backgroundColor: const Color(0xFF15385E),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Ticket not found'),
        ),
      );
    }

    final DateFormat dateFormat = DateFormat('MMMM dd, yyyy');
    final DateFormat timeFormat = DateFormat('h:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Details'),
        backgroundColor: const Color(0xFF15385E),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketFormScreen(ticketId: widget.ticketId),
                ),
              ).then((_) {
                setState(() {
                  _loadTicket();
                });
              });
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _showDeleteConfirmation(context);
              } else if (value == 'share') {
                // Share ticket functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share functionality coming soon')),
                );
              } else if (value == 'print') {
                // Print ticket functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Print functionality coming soon')),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'share',
                  child: Row(
                    children: [
                      Icon(Icons.share, color: Color(0xFF15385E)),
                      SizedBox(width: 8),
                      Text('Share'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'print',
                  child: Row(
                    children: [
                      Icon(Icons.print, color: Color(0xFF15385E)),
                      SizedBox(width: 8),
                      Text('Print'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ticket header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Field Ticket #${_ticket!.id}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF15385E),
                  ),
                ),
                _buildStatusChip(_ticket!.status),
              ],
            ),
            const Divider(height: 32),

            // Date and time
            _buildSectionHeading('Date & Time'),
            _buildInfoRow('Date', dateFormat.format(_ticket!.date)),
            if (_ticket!.beginTime != null)
              _buildInfoRow('Begin Time', timeFormat.format(_ticket!.beginTime!)),
            if (_ticket!.endTime != null)
              _buildInfoRow('End Time', timeFormat.format(_ticket!.endTime!)),
            if (_ticket!.ticketType != null)
              _buildInfoRow('Type', _getTicketTypeText(_ticket!.ticketType!)),
            const SizedBox(height: 16),

            // Customer information
            _buildSectionHeading('Customer Information'),
            _buildInfoRow('Customer', _ticket!.customerName),
            if (_ticket!.location != null)
              _buildInfoRow('Location', _ticket!.location!),
            if (_ticket!.bookingNumber != null)
              _buildInfoRow('Booking #', _ticket!.bookingNumber!),
            const SizedBox(height: 16),

            // Description
            if (_ticket!.description != null) ...[
              _buildSectionHeading('Description'),
              _buildDescription(_ticket!.description!),
              const SizedBox(height: 16),
            ],

            // Mileage
            if (_ticket!.beginMileage != null || _ticket!.endingMileage != null || _ticket!.totalMileage != null) ...[
              _buildSectionHeading('Mileage'),
              if (_ticket!.beginMileage != null)
                _buildInfoRow('Beginning Mileage', _ticket!.beginMileage.toString()),
              if (_ticket!.endingMileage != null)
                _buildInfoRow('Ending Mileage', _ticket!.endingMileage.toString()),
              if (_ticket!.totalMileage != null)
                _buildInfoRow('Total Mileage', _ticket!.totalMileage.toString()),
              const SizedBox(height: 16),
            ],

            // Load details
            if (_ticket!.totalBbls != null) ...[
              _buildSectionHeading('Load Details'),
              _buildInfoRow('Total BBLs', _ticket!.totalBbls.toString()),
              const SizedBox(height: 16),
            ],

            // Charges
            _buildSectionHeading('Charges'),

            // Calculate total
            const SizedBox(height: 8),
            _buildChargesTable(),
            const SizedBox(height: 16),

            // Signatures
            _buildSectionHeading('Signatures'),
            if (_ticket!.driverSignatureUrl != null)
              _buildSignatureDisplay('Driver Signature'),
            if (_ticket!.customerSignatureUrl != null)
              _buildSignatureDisplay('Customer Signature'),

            const SizedBox(height: 32),

            // Update status buttons
            if (_ticket!.status != 'completed') ...[
              _buildSectionHeading('Actions'),
              const SizedBox(height: 8),
              _buildActionButtons(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String statusText;

    switch (status) {
      case 'completed':
        chipColor = Colors.green;
        statusText = 'Completed';
        break;
      case 'in_progress':
        chipColor = Colors.orange;
        statusText = 'In Progress';
        break;
      case 'pending':
        chipColor = Colors.blue;
        statusText = 'Pending';
        break;
      case 'draft':
        chipColor = Colors.grey;
        statusText = 'Draft';
        break;
      default:
        chipColor = Colors.grey;
        statusText = 'Unknown';
    }

    return Chip(
      label: Text(statusText),
      backgroundColor: chipColor.withOpacity(0.2),
      labelStyle: TextStyle(
        color: chipColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  String _getTicketTypeText(String type) {
    switch (type) {
      case 'OT':
        return 'OT - Drive Time';
      case 'ST':
        return 'ST - Standard Time';
      case 'YT':
        return 'YT - Yard Time';
      case 'WT':
        return 'WT - Work Time';
      default:
        return type;
    }
  }

  Widget _buildSectionHeading(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF15385E),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      child: Text(description),
    );
  }

  Widget _buildChargesTable() {
    final List<TableRow> rows = [];
    double total = 0;

    // Add header row
    rows.add(
      const TableRow(
        decoration: BoxDecoration(
          color: Color(0xFF15385E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Item',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Amount',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    // Add charge rows
    if (_ticket!.otDriveTime != null && _ticket!.otDriveTimeCharge != null) {
      rows.add(_buildChargeRow(
        'OT Drive Time',
        _ticket!.otDriveTime!,
        _ticket!.otDriveTimeCharge!,
      ));
      total += _ticket!.otDriveTimeCharge!;
    }

    if (_ticket!.stDriveTime != null && _ticket!.stDriveTimeCharge != null) {
      rows.add(_buildChargeRow(
        'ST Drive Time',
        _ticket!.stDriveTime!,
        _ticket!.stDriveTimeCharge!,
      ));
      total += _ticket!.stDriveTimeCharge!;
    }

    if (_ticket!.yardTime != null && _ticket!.yardTimeCharge != null) {
      rows.add(_buildChargeRow(
        'Yard Time',
        _ticket!.yardTime!,
        _ticket!.yardTimeCharge!,
      ));
      total += _ticket!.yardTimeCharge!;
    }

    if (_ticket!.waitTime != null && _ticket!.waitTimeCharge != null) {
      rows.add(_buildChargeRow(
        'Wait Time',
        _ticket!.waitTime!,
        _ticket!.waitTimeCharge!,
      ));
      total += _ticket!.waitTimeCharge!;
    }

    if (_ticket!.truckCharge != null && _ticket!.truckChargeAmount != null) {
      rows.add(_buildChargeRow(
        'Truck Charge',
        _ticket!.truckCharge!,
        _ticket!.truckChargeAmount!,
      ));
      total += _ticket!.truckChargeAmount!;
    }

    if (_ticket!.freshWater != null && _ticket!.freshWaterCharge != null) {
      rows.add(_buildChargeRow(
        'Fresh Water',
        _ticket!.freshWater!,
        _ticket!.freshWaterCharge!,
      ));
      total += _ticket!.freshWaterCharge!;
    }

    if (_ticket!.disposalWater != null && _ticket!.disposalWaterCharge != null) {
      rows.add(_buildChargeRow(
        'Disposal Water',
        _ticket!.disposalWater!,
        _ticket!.disposalWaterCharge!,
      ));
      total += _ticket!.disposalWaterCharge!;
    }

    if (_ticket!.brine != null && _ticket!.brineCharge != null) {
      rows.add(_buildChargeRow(
        'Brine',
        _ticket!.brine!,
        _ticket!.brineCharge!,
      ));
      total += _ticket!.brineCharge!;
    }

    if (_ticket!.other != null && _ticket!.otherCharge != null) {
      rows.add(_buildChargeRow(
        'Other',
        _ticket!.other!,
        _ticket!.otherCharge!,
      ));
      total += _ticket!.otherCharge!;
    }

    // Add total row
    rows.add(
      TableRow(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Total',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(''),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '\$${total.toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    return Table(
      border: TableBorder.all(
        color: Colors.grey[300]!,
        borderRadius: BorderRadius.circular(8),
      ),
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1),
      },
      children: rows,
    );
  }

  TableRow _buildChargeRow(String label, String details, double amount) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(details),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '\$${amount.toStringAsFixed(2)}',
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildSignatureDisplay(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: const Center(
              child: Text('Signature on file'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.check_circle),
            label: const Text('Mark as Complete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {
              _updateTicketStatus('completed');
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.pending_actions),
            label: const Text('Mark as In Progress'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {
              _updateTicketStatus('in_progress');
            },
          ),
        ),
      ],
    );
  }

  void _updateTicketStatus(String status) {
    if (_ticket == null) return;

    final updatedTicket = _ticket!.copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );

    _ticketService.updateTicket(updatedTicket);

    setState(() {
      _ticket = updatedTicket;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ticket status updated to ${status.replaceAll('_', ' ')}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Ticket'),
          content: const Text('Are you sure you want to delete this ticket? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                _ticketService.deleteTicket(widget.ticketId);
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ticket deleted'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}