// lib/features/tickets/models/ticket.dart
import 'package:intl/intl.dart'; // Add this import

class Ticket {
  final String id;
  final String? bookingNumber;
  final String customerName;
  final String? rig;
  final String? location;
  final DateTime date;
  final DateTime? beginTime;
  final DateTime? endTime;
  final String? unitNumber;
  final String? workOrderNumber;
  final String? afeNumber;
  final String? description;
  final String status; // 'in progress', 'completed', 'submitted'
  final DateTime createdAt;
  final DateTime? updatedAt;

  Ticket({
    required this.id,
    this.bookingNumber,
    required this.customerName,
    this.rig,
    this.location,
    required this.date,
    this.beginTime,
    this.endTime,
    this.unitNumber,
    this.workOrderNumber,
    this.afeNumber,
    this.description,
    this.status = 'in progress',
    required this.createdAt,
    this.updatedAt,
  });

  // Calculate total hours worked
  double get totalHours {
    if (beginTime != null && endTime != null) {
      final duration = endTime!.difference(beginTime!);
      return duration.inMinutes / 60.0;
    }
    return 0.0;
  }

  // Get formatted time range
  String get timeRange {
    if (beginTime != null && endTime != null) {
      final timeFormat = DateFormat('h:mm a');
      return '${timeFormat.format(beginTime!)} - ${timeFormat.format(endTime!)}';
    } else if (beginTime != null) {
      final timeFormat = DateFormat('h:mm a');
      return 'Started at ${timeFormat.format(beginTime!)}';
    }
    return 'No time recorded';
  }

  Ticket copyWith({
    String? id,
    String? bookingNumber,
    String? customerName,
    String? rig,
    String? location,
    DateTime? date,
    DateTime? beginTime,
    DateTime? endTime,
    String? unitNumber,
    String? workOrderNumber,
    String? afeNumber,
    String? description,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Ticket(
      id: id ?? this.id,
      bookingNumber: bookingNumber ?? this.bookingNumber,
      customerName: customerName ?? this.customerName,
      rig: rig ?? this.rig,
      location: location ?? this.location,
      date: date ?? this.date,
      beginTime: beginTime ?? this.beginTime,
      endTime: endTime ?? this.endTime,
      unitNumber: unitNumber ?? this.unitNumber,
      workOrderNumber: workOrderNumber ?? this.workOrderNumber,
      afeNumber: afeNumber ?? this.afeNumber,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingNumber': bookingNumber,
      'customerName': customerName,
      'rig': rig,
      'location': location,
      'date': date.toIso8601String(),
      'beginTime': beginTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'unitNumber': unitNumber,
      'workOrderNumber': workOrderNumber,
      'afeNumber': afeNumber,
      'description': description,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      bookingNumber: json['bookingNumber'],
      customerName: json['customerName'],
      rig: json['rig'],
      location: json['location'],
      date: DateTime.parse(json['date']),
      beginTime:
          json['beginTime'] != null ? DateTime.parse(json['beginTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      unitNumber: json['unitNumber'],
      workOrderNumber: json['workOrderNumber'],
      afeNumber: json['afeNumber'],
      description: json['description'],
      status: json['status'] ?? 'in progress',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
