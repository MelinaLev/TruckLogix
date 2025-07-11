// lib/features/tickets/screens/create_ticket_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/ticket.dart';
import '../services/ticket_service.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final TicketService _ticketService = TicketService();

  // Form controllers
  final _bookingNumberController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _rigController = TextEditingController();
  final _locationController = TextEditingController();
  final _unitNumberController = TextEditingController();
  final _workOrderController = TextEditingController();
  final _afeNumberController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _beginTime;
  TimeOfDay? _endTime;
  bool _isLoading = false;

  @override
  void dispose() {
    _bookingNumberController.dispose();
    _customerNameController.dispose();
    _rigController.dispose();
    _locationController.dispose();
    _unitNumberController.dispose();
    _workOrderController.dispose();
    _afeNumberController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF15385E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(bool isBeginTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isBeginTime
          ? (_beginTime ?? TimeOfDay.now())
          : (_endTime ?? TimeOfDay.now()),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF15385E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isBeginTime) {
          _beginTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  } // Fixed: Added missing closing brace

  Future<void> _saveTicket() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Convert TimeOfDay to DateTime if times are selected
      DateTime? beginDateTime;
      DateTime? endDateTime;

      if (_beginTime != null) {
        beginDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _beginTime!.hour,
          _beginTime!.minute,
        );
      }

      if (_endTime != null) {
        endDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _endTime!.hour,
          _endTime!.minute,
        );
      }

      final ticket = Ticket(
        id: _ticketService.generateTicketId(),
        bookingNumber: _bookingNumberController.text.trim().isEmpty
            ? null
            : _bookingNumberController.text.trim(),
        customerName: _customerNameController.text.trim(),
        rig: _rigController.text.trim().isEmpty
            ? null
            : _rigController.text.trim(),
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        date: _selectedDate,
        beginTime: beginDateTime,
        endTime: endDateTime,
        unitNumber: _unitNumberController.text.trim().isEmpty
            ? null
            : _unitNumberController.text.trim(),
        workOrderNumber: _workOrderController.text.trim().isEmpty
            ? null
            : _workOrderController.text.trim(),
        afeNumber: _afeNumberController.text.trim().isEmpty
            ? null
            : _afeNumberController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        createdAt: DateTime.now(),
      );

      await _ticketService.addTicket(ticket);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ticket created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        _clearForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating ticket: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    _bookingNumberController.clear();
    _customerNameController.clear();
    _rigController.clear();
    _locationController.clear();
    _unitNumberController.clear();
    _workOrderController.clear();
    _afeNumberController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedDate = DateTime.now();
      _beginTime = null;
      _endTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create Ticket'),
        backgroundColor: const Color(0xFF15385E),
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _clearForm,
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF15385E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF15385E).withOpacity(0.3),
                    ),
                  ),
                  child: const Text(
                    'NEW FIELD TICKET',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF15385E),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Booking Number
              TextFormField(
                controller: _bookingNumberController,
                decoration: const InputDecoration(
                  labelText: 'Booking Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Customer Name (Required)
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(
                  labelText: 'Customer *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Customer name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Rig
              TextFormField(
                controller: _rigController,
                decoration: const InputDecoration(
                  labelText: 'Rig',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Date (Required)
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date *',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    DateFormat('MM/dd/yyyy').format(_selectedDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Begin Time and End Time
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(true),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Begin Time',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        child: Text(
                          _beginTime != null
                              ? _beginTime!.format(context)
                              : 'Select time',
                          style: TextStyle(
                            fontSize: 16,
                            color: _beginTime != null
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(false),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'End Time',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.access_time),
                        ),
                        child: Text(
                          _endTime != null
                              ? _endTime!.format(context)
                              : 'Select time',
                          style: TextStyle(
                            fontSize: 16,
                            color: _endTime != null
                                ? Colors.black
                                : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Unit Number
              TextFormField(
                controller: _unitNumberController,
                decoration: const InputDecoration(
                  labelText: 'Unit Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Work Order #
              TextFormField(
                controller: _workOrderController,
                decoration: const InputDecoration(
                  labelText: 'Work Order #',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // AFE #
              TextFormField(
                controller: _afeNumberController,
                decoration: const InputDecoration(
                  labelText: 'AFE #',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Description of Service
              const Text(
                'Description of Service',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Enter service description...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveTicket,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF15385E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Create Ticket',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // Required fields note
              const Text(
                '* Required fields',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
