import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/ticket_model.dart';
import '../services/ticket_service.dart';
import '../widgets/signature_pad.dart';
import '../widgets/image_picker_widget.dart';

class TicketFormScreen extends StatefulWidget {
  final String? ticketId;

  const TicketFormScreen({super.key, this.ticketId});

  @override
  State<TicketFormScreen> createState() => _TicketFormScreenState();
}


class _TicketFormScreenState extends State<TicketFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TicketService _ticketService = TicketService();

  // Date formatting
  final DateFormat _dateFormat = DateFormat('MM/dd/yyyy');

  // Form controllers
  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _bookingNumberController = TextEditingController();
  final TextEditingController _beginMileageController = TextEditingController();
  final TextEditingController _endingMileageController = TextEditingController();
  final TextEditingController _totalMileageController = TextEditingController();
  final TextEditingController _totalBblsController = TextEditingController();
  final TextEditingController _otDriveTimeController = TextEditingController();
  final TextEditingController _stDriveTimeController = TextEditingController();
  final TextEditingController _yardTimeController = TextEditingController();
  final TextEditingController _waitTimeController = TextEditingController();
  final TextEditingController _truckChargeController = TextEditingController();
  final TextEditingController _freshWaterController = TextEditingController();
  final TextEditingController _disposalWaterController = TextEditingController();
  final TextEditingController _brineController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();

  // Price controllers
  final TextEditingController _otDriveTimePriceController = TextEditingController();
  final TextEditingController _stDriveTimePriceController = TextEditingController();
  final TextEditingController _yardTimePriceController = TextEditingController();
  final TextEditingController _waitTimePriceController = TextEditingController();
  final TextEditingController _truckChargePriceController = TextEditingController();
  final TextEditingController _freshWaterPriceController = TextEditingController();
  final TextEditingController _disposalWaterPriceController = TextEditingController();
  final TextEditingController _brinePriceController = TextEditingController();
  final TextEditingController _otherPriceController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _beginTime = TimeOfDay.now();
  TimeOfDay? _endTime;
  String? _ticketType;
  bool _isEditing = false;
  Ticket? _existingTicket;

  // Signature points
  List<Offset> _driverSignaturePoints = [];
  List<Offset> _customerSignaturePoints = [];

  @override
  void initState() {
    super.initState();

    if (widget.ticketId != null) {
      _isEditing = true;
      _loadExistingTicket();
    }
  }

  void _loadExistingTicket() {
    _existingTicket = _ticketService.getTicketById(widget.ticketId!);

    if (_existingTicket != null) {
      // Populate the form with existing data
      _customerController.text = _existingTicket!.customerName;
      _locationController.text = _existingTicket!.location ?? '';
      _descriptionController.text = _existingTicket!.description ?? '';
      _bookingNumberController.text = _existingTicket!.bookingNumber ?? '';
      _selectedDate = _existingTicket!.date;

      if (_existingTicket!.beginTime != null) {
        _beginTime = TimeOfDay.fromDateTime(_existingTicket!.beginTime!);
      }

      if (_existingTicket!.endTime != null) {
        _endTime = TimeOfDay.fromDateTime(_existingTicket!.endTime!);
      }

      _ticketType = _existingTicket!.ticketType;

      if (_existingTicket!.beginMileage != null) {
        _beginMileageController.text = _existingTicket!.beginMileage.toString();
      }

      if (_existingTicket!.endingMileage != null) {
        _endingMileageController.text =
            _existingTicket!.endingMileage.toString();
      }

      if (_existingTicket!.totalMileage != null) {
        _totalMileageController.text = _existingTicket!.totalMileage.toString();
      }

      if (_existingTicket!.totalBbls != null) {
        _totalBblsController.text = _existingTicket!.totalBbls.toString();
      }

      // Time entries
      _otDriveTimeController.text = _existingTicket!.otDriveTime ?? '';
      _stDriveTimeController.text = _existingTicket!.stDriveTime ?? '';
      _yardTimeController.text = _existingTicket!.yardTime ?? '';
      _waitTimeController.text = _existingTicket!.waitTime ?? '';

      // Other entries
      _truckChargeController.text = _existingTicket!.truckCharge ?? '';
      _freshWaterController.text = _existingTicket!.freshWater ?? '';
      _disposalWaterController.text = _existingTicket!.disposalWater ?? '';
      _brineController.text = _existingTicket!.brine ?? '';
      _otherController.text = _existingTicket!.other ?? '';

      // Price entries
      if (_existingTicket!.otDriveTimeCharge != null) {
        _otDriveTimePriceController.text =
            _existingTicket!.otDriveTimeCharge.toString();
      }

      if (_existingTicket!.stDriveTimeCharge != null) {
        _stDriveTimePriceController.text =
            _existingTicket!.stDriveTimeCharge.toString();
      }

      if (_existingTicket!.yardTimeCharge != null) {
        _yardTimePriceController.text =
            _existingTicket!.yardTimeCharge.toString();
      }

      if (_existingTicket!.waitTimeCharge != null) {
        _waitTimePriceController.text =
            _existingTicket!.waitTimeCharge.toString();
      }

      if (_existingTicket!.truckChargeAmount != null) {
        _truckChargePriceController.text =
            _existingTicket!.truckChargeAmount.toString();
      }

      if (_existingTicket!.freshWaterCharge != null) {
        _freshWaterPriceController.text =
            _existingTicket!.freshWaterCharge.toString();
      }

      if (_existingTicket!.disposalWaterCharge != null) {
        _disposalWaterPriceController.text =
            _existingTicket!.disposalWaterCharge.toString();
      }

      if (_existingTicket!.brineCharge != null) {
        _brinePriceController.text = _existingTicket!.brineCharge.toString();
      }

      if (_existingTicket!.otherCharge != null) {
        _otherPriceController.text = _existingTicket!.otherCharge.toString();
      }
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    _customerController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _bookingNumberController.dispose();
    _beginMileageController.dispose();
    _endingMileageController.dispose();
    _totalMileageController.dispose();
    _totalBblsController.dispose();
    _otDriveTimeController.dispose();
    _stDriveTimeController.dispose();
    _yardTimeController.dispose();
    _waitTimeController.dispose();
    _truckChargeController.dispose();
    _freshWaterController.dispose();
    _disposalWaterController.dispose();
    _brineController.dispose();
    _otherController.dispose();

    // Price controllers
    _otDriveTimePriceController.dispose();
    _stDriveTimePriceController.dispose();
    _yardTimePriceController.dispose();
    _waitTimePriceController.dispose();
    _truckChargePriceController.dispose();
    _freshWaterPriceController.dispose();
    _disposalWaterPriceController.dispose();
    _brinePriceController.dispose();
    _otherPriceController.dispose();

    super.dispose();
  }

  // Date picker helper
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
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

  // Time picker helper
  Future<void> _selectTime(BuildContext context, bool isBeginTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isBeginTime
          ? _beginTime
          : _endTime ?? TimeOfDay.now(),
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
  }

  // Save ticket
  void _saveTicket() {
    if (_formKey.currentState!.validate()) {
      // Create a new ticket or update existing
      final String ticketId = _isEditing
          ? widget.ticketId!
          : _ticketService.generateTicketId();

      // Convert begin time to DateTime
      DateTime beginDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _beginTime.hour,
        _beginTime.minute,
      );

      // Convert end time to DateTime if available
      DateTime? endDateTime;
      if (_endTime != null) {
        endDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _endTime!.hour,
          _endTime!.minute,
        );
      }

      // Parse numeric values
      int? beginMileage = int.tryParse(_beginMileageController.text);
      int? endingMileage = int.tryParse(_endingMileageController.text);
      int? totalMileage = int.tryParse(_totalMileageController.text);
      double? totalBbls = double.tryParse(_totalBblsController.text);

      // Parse price values
      double? otDriveTimeCharge = double.tryParse(
          _otDriveTimePriceController.text);
      double? stDriveTimeCharge = double.tryParse(
          _stDriveTimePriceController.text);
      double? yardTimeCharge = double.tryParse(_yardTimePriceController.text);
      double? waitTimeCharge = double.tryParse(_waitTimePriceController.text);
      double? truckChargeAmount = double.tryParse(
          _truckChargePriceController.text);
      double? freshWaterCharge = double.tryParse(
          _freshWaterPriceController.text);
      double? disposalWaterCharge = double.tryParse(
          _disposalWaterPriceController.text);
      double? brineCharge = double.tryParse(_brinePriceController.text);
      double? otherCharge = double.tryParse(_otherPriceController.text);

      // Create the ticket
      final ticket = Ticket(
        id: ticketId,
        customerName: _customerController.text,
        location: _locationController.text.isEmpty ? null : _locationController
            .text,
        bookingNumber: _bookingNumberController.text.isEmpty
            ? null
            : _bookingNumberController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        date: _selectedDate,
        beginTime: beginDateTime,
        endTime: endDateTime,
        ticketType: _ticketType,
        beginMileage: beginMileage,
        endingMileage: endingMileage,
        totalMileage: totalMileage,
        totalBbls: totalBbls,
        otDriveTime: _otDriveTimeController.text.isEmpty
            ? null
            : _otDriveTimeController.text,
        otDriveTimeCharge: otDriveTimeCharge,
        stDriveTime: _stDriveTimeController.text.isEmpty
            ? null
            : _stDriveTimeController.text,
        stDriveTimeCharge: stDriveTimeCharge,
        yardTime: _yardTimeController.text.isEmpty ? null : _yardTimeController
            .text,
        yardTimeCharge: yardTimeCharge,
        waitTime: _waitTimeController.text.isEmpty ? null : _waitTimeController
            .text,
        waitTimeCharge: waitTimeCharge,
        truckCharge: _truckChargeController.text.isEmpty
            ? null
            : _truckChargeController.text,
        truckChargeAmount: truckChargeAmount,
        freshWater: _freshWaterController.text.isEmpty
            ? null
            : _freshWaterController.text,
        freshWaterCharge: freshWaterCharge,
        disposalWater: _disposalWaterController.text.isEmpty
            ? null
            : _disposalWaterController.text,
        disposalWaterCharge: disposalWaterCharge,
        brine: _brineController.text.isEmpty ? null : _brineController.text,
        brineCharge: brineCharge,
        other: _otherController.text.isEmpty ? null : _otherController.text,
        otherCharge: otherCharge,
        // In a real app, we would save the signature data or image
        driverSignatureUrl: _driverSignaturePoints.isNotEmpty
            ? 'signature_data'
            : null,
        customerSignatureUrl: _customerSignaturePoints.isNotEmpty
            ? 'signature_data'
            : null,
        status: _isEditing ? _existingTicket!.status : 'draft',
        createdAt: _isEditing ? _existingTicket!.createdAt : DateTime.now(),
        updatedAt: _isEditing ? DateTime.now() : null,
      );

      // Save the ticket
      if (_isEditing) {
        _ticketService.updateTicket(ticket);
      } else {
        _ticketService.addTicket(ticket);
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isEditing
              ? 'Ticket updated successfully!'
              : 'Ticket created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back or reset form
      if (_isEditing) {
        Navigator.pop(context);
      } else {
        _resetForm();
      }
    }
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _customerController.clear();
      _locationController.clear();
      _descriptionController.clear();
      _bookingNumberController.clear();
      _beginMileageController.clear();
      _endingMileageController.clear();
      _totalMileageController.clear();
      _totalBblsController.clear();
      _otDriveTimeController.clear();
      _stDriveTimeController.clear();
      _yardTimeController.clear();
      _waitTimeController.clear();
      _truckChargeController.clear();
      _freshWaterController.clear();
      _disposalWaterController.clear();
      _brineController.clear();
      _otherController.clear();

      // Price controllers
      _otDriveTimePriceController.clear();
      _stDriveTimePriceController.clear();
      _yardTimePriceController.clear();
      _waitTimePriceController.clear();
      _truckChargePriceController.clear();
      _freshWaterPriceController.clear();
      _disposalWaterPriceController.clear();
      _brinePriceController.clear();
      _otherPriceController.clear();

      _selectedDate = DateTime.now();
      _beginTime = TimeOfDay.now();
      _endTime = null;
      _ticketType = null;
      _driverSignaturePoints = [];
      _customerSignaturePoints = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Ticket' : 'New Ticket'),
        backgroundColor: const Color(0xFF15385E),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ticket Number
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Text(
                      _isEditing
                          ? 'FIELD TICKET #${widget.ticketId}'
                          : 'NEW FIELD TICKET',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: _isEditing ? Colors.red : const Color(
                            0xFF15385E),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Basic Information
                const Text(
                  'Customer Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),

                TextFormField(
                  controller: _customerController,
                  decoration: const InputDecoration(
                    labelText: 'Customer',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter customer name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),

                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8.0),

                // Booking Number
                TextFormField(
                  controller: _bookingNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Booking #',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Service Description
                const Text(
                  'Description of Service',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),

                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Date and Times
                const Text(
                  'Date and Time',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _dateFormat.format(_selectedDate),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context, true),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Begin Time',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _beginTime.format(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectTime(context, false),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'End Time',
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _endTime != null
                                ? _endTime!.format(context)
                                : 'Select End Time',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                  ],
                ),
                const SizedBox(height: 16.0),

                // Mileage
                const Text(
                  'Mileage',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _beginMileageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Beginning Mileage',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          // Auto-calculate total mileage
                          if (value.isNotEmpty &&
                              _endingMileageController.text.isNotEmpty) {
                            final begin = int.tryParse(value) ?? 0;
                            final end = int.tryParse(
                                _endingMileageController.text) ?? 0;
                            if (end >= begin) {
                              _totalMileageController.text =
                                  (end - begin).toString();
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextFormField(
                        controller: _endingMileageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Ending Mileage',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          // Auto-calculate total mileage
                          if (value.isNotEmpty &&
                              _beginMileageController.text.isNotEmpty) {
                            final begin = int.tryParse(
                                _beginMileageController.text) ?? 0;
                            final end = int.tryParse(value) ?? 0;
                            if (end >= begin) {
                              _totalMileageController.text =
                                  (end - begin).toString();
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),

                TextFormField(
                  controller: _totalMileageController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Total Mileage',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Load details
                const Text(
                  'Load Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),

                TextFormField(
                  controller: _totalBblsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Total BBLS',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Charges Section
                const Text(
                  'Charges',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),

                // Truck Charge
                _buildChargeRow(
                    'Truck Charge',
                    _truckChargeController,
                    _truckChargePriceController
                ),
                const SizedBox(height: 8.0),

                // Fresh Water
                _buildChargeRow(
                    'Fresh Water',
                    _freshWaterController,
                    _freshWaterPriceController
                ),
                const SizedBox(height: 8.0),

                // Disposal Water
                _buildChargeRow(
                    'Disposal Water',
                    _disposalWaterController,
                    _disposalWaterPriceController
                ),
                const SizedBox(height: 8.0),

                // Brine
                _buildChargeRow(
                    'Brine',
                    _brineController,
                    _brinePriceController
                ),
                const SizedBox(height: 8.0),

                // Other
                _buildChargeRow(
                    'Other',
                    _otherController,
                    _otherPriceController
                ),
                const SizedBox(height: 24.0),

                // Signature section
                const Text(
                  'Driver Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),

                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Driver Signature:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SignaturePad(
                        onSignatureChanged: (points) {
                          _driverSignaturePoints = points;
                        },
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Customer Signature:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SignaturePad(
                        onSignatureChanged: (points) {
                          _customerSignaturePoints = points;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF15385E),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _saveTicket,
                    child: Text(_isEditing ? 'Update Ticket' : 'Save Ticket'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  }

Widget _buildChargeRow(
    String label,
    TextEditingController timeController,
    TextEditingController priceController,
    ) {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: TextFormField(
          controller: timeController,
          decoration: InputDecoration(
            labelText: '$label Time',
            border: const OutlineInputBorder(),
          ),
        ),
      ),
      const SizedBox(width: 8.0),
      Expanded(
        child: TextFormField(
          controller: priceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Price',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    ],
  );
  }