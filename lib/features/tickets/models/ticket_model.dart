class Ticket {
  final String id;
  final String? customerId;
  final String customerName;
  final String? location;
  final String? bookingNumber;
  final String? description;
  final DateTime date;
  final DateTime? beginTime;
  final DateTime? endTime;
  final String? ticketType;
  final int? beginMileage;
  final int? endingMileage;
  final int? totalMileage;
  final double? totalBbls;

  // Time categories
  final String? otDriveTime;
  final double? otDriveTimeCharge;
  final String? stDriveTime;
  final double? stDriveTimeCharge;
  final String? yardTime;
  final double? yardTimeCharge;
  final String? waitTime;
  final double? waitTimeCharge;

  // Charges
  final String? truckCharge;
  final double? truckChargeAmount;
  final String? freshWater;
  final double? freshWaterCharge;
  final String? disposalWater;
  final double? disposalWaterCharge;
  final String? brine;
  final double? brineCharge;
  final String? other;
  final double? otherCharge;

  // Signatures
  final String? driverSignatureUrl;
  final String? customerSignatureUrl;

  // Status
  final String status; // 'draft', 'pending', 'in_progress', 'completed'

  // Timestamps
  final DateTime createdAt;
  final DateTime? updatedAt;

  Ticket({
    required this.id,
    this.customerId,
    required this.customerName,
    this.location,
    this.bookingNumber,
    this.description,
    required this.date,
    this.beginTime,
    this.endTime,
    this.ticketType,
    this.beginMileage,
    this.endingMileage,
    this.totalMileage,
    this.totalBbls,
    this.otDriveTime,
    this.otDriveTimeCharge,
    this.stDriveTime,
    this.stDriveTimeCharge,
    this.yardTime,
    this.yardTimeCharge,
    this.waitTime,
    this.waitTimeCharge,
    this.truckCharge,
    this.truckChargeAmount,
    this.freshWater,
    this.freshWaterCharge,
    this.disposalWater,
    this.disposalWaterCharge,
    this.brine,
    this.brineCharge,
    this.other,
    this.otherCharge,
    this.driverSignatureUrl,
    this.customerSignatureUrl,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  // Create a Ticket from a JSON Map
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      location: json['location'],
      bookingNumber: json['bookingNumber'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      beginTime:
          json['beginTime'] != null ? DateTime.parse(json['beginTime']) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      ticketType: json['ticketType'],
      beginMileage: json['beginMileage'],
      endingMileage: json['endingMileage'],
      totalMileage: json['totalMileage'],
      totalBbls: json['totalBbls'],
      otDriveTime: json['otDriveTime'],
      otDriveTimeCharge: json['otDriveTimeCharge'],
      stDriveTime: json['stDriveTime'],
      stDriveTimeCharge: json['stDriveTimeCharge'],
      yardTime: json['yardTime'],
      yardTimeCharge: json['yardTimeCharge'],
      waitTime: json['waitTime'],
      waitTimeCharge: json['waitTimeCharge'],
      truckCharge: json['truckCharge'],
      truckChargeAmount: json['truckChargeAmount'],
      freshWater: json['freshWater'],
      freshWaterCharge: json['freshWaterCharge'],
      disposalWater: json['disposalWater'],
      disposalWaterCharge: json['disposalWaterCharge'],
      brine: json['brine'],
      brineCharge: json['brineCharge'],
      other: json['other'],
      otherCharge: json['otherCharge'],
      driverSignatureUrl: json['driverSignatureUrl'],
      customerSignatureUrl: json['customerSignatureUrl'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Convert Ticket to a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'location': location,
      'bookingNumber': bookingNumber,
      'description': description,
      'date': date.toIso8601String(),
      'beginTime': beginTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'ticketType': ticketType,
      'beginMileage': beginMileage,
      'endingMileage': endingMileage,
      'totalMileage': totalMileage,
      'totalBbls': totalBbls,
      'otDriveTime': otDriveTime,
      'otDriveTimeCharge': otDriveTimeCharge,
      'stDriveTime': stDriveTime,
      'stDriveTimeCharge': stDriveTimeCharge,
      'yardTime': yardTime,
      'yardTimeCharge': yardTimeCharge,
      'waitTime': waitTime,
      'waitTimeCharge': waitTimeCharge,
      'truckCharge': truckCharge,
      'truckChargeAmount': truckChargeAmount,
      'freshWater': freshWater,
      'freshWaterCharge': freshWaterCharge,
      'disposalWater': disposalWater,
      'disposalWaterCharge': disposalWaterCharge,
      'brine': brine,
      'brineCharge': brineCharge,
      'other': other,
      'otherCharge': otherCharge,
      'driverSignatureUrl': driverSignatureUrl,
      'customerSignatureUrl': customerSignatureUrl,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Calculate total charges
  double calculateTotalCharges() {
    double total = 0;

    // Add all charges
    if (otDriveTimeCharge != null) total += otDriveTimeCharge!;
    if (stDriveTimeCharge != null) total += stDriveTimeCharge!;
    if (yardTimeCharge != null) total += yardTimeCharge!;
    if (waitTimeCharge != null) total += waitTimeCharge!;
    if (truckChargeAmount != null) total += truckChargeAmount!;
    if (freshWaterCharge != null) total += freshWaterCharge!;
    if (disposalWaterCharge != null) total += disposalWaterCharge!;
    if (brineCharge != null) total += brineCharge!;
    if (otherCharge != null) total += otherCharge!;

    return total;
  }

  // Create a copy of the ticket with updated fields
  Ticket copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? location,
    String? bookingNumber,
    String? description,
    DateTime? date,
    DateTime? beginTime,
    DateTime? endTime,
    String? ticketType,
    int? beginMileage,
    int? endingMileage,
    int? totalMileage,
    double? totalBbls,
    String? otDriveTime,
    double? otDriveTimeCharge,
    String? stDriveTime,
    double? stDriveTimeCharge,
    String? yardTime,
    double? yardTimeCharge,
    String? waitTime,
    double? waitTimeCharge,
    String? truckCharge,
    double? truckChargeAmount,
    String? freshWater,
    double? freshWaterCharge,
    String? disposalWater,
    double? disposalWaterCharge,
    String? brine,
    double? brineCharge,
    String? other,
    double? otherCharge,
    String? driverSignatureUrl,
    String? customerSignatureUrl,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Ticket(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      location: location ?? this.location,
      bookingNumber: bookingNumber ?? this.bookingNumber,
      description: description ?? this.description,
      date: date ?? this.date,
      beginTime: beginTime ?? this.beginTime,
      endTime: endTime ?? this.endTime,
      ticketType: ticketType ?? this.ticketType,
      beginMileage: beginMileage ?? this.beginMileage,
      endingMileage: endingMileage ?? this.endingMileage,
      totalMileage: totalMileage ?? this.totalMileage,
      totalBbls: totalBbls ?? this.totalBbls,
      otDriveTime: otDriveTime ?? this.otDriveTime,
      otDriveTimeCharge: otDriveTimeCharge ?? this.otDriveTimeCharge,
      stDriveTime: stDriveTime ?? this.stDriveTime,
      stDriveTimeCharge: stDriveTimeCharge ?? this.stDriveTimeCharge,
      yardTime: yardTime ?? this.yardTime,
      yardTimeCharge: yardTimeCharge ?? this.yardTimeCharge,
      waitTime: waitTime ?? this.waitTime,
      waitTimeCharge: waitTimeCharge ?? this.waitTimeCharge,
      truckCharge: truckCharge ?? this.truckCharge,
      truckChargeAmount: truckChargeAmount ?? this.truckChargeAmount,
      freshWater: freshWater ?? this.freshWater,
      freshWaterCharge: freshWaterCharge ?? this.freshWaterCharge,
      disposalWater: disposalWater ?? this.disposalWater,
      disposalWaterCharge: disposalWaterCharge ?? this.disposalWaterCharge,
      brine: brine ?? this.brine,
      brineCharge: brineCharge ?? this.brineCharge,
      other: other ?? this.other,
      otherCharge: otherCharge ?? this.otherCharge,
      driverSignatureUrl: driverSignatureUrl ?? this.driverSignatureUrl,
      customerSignatureUrl: customerSignatureUrl ?? this.customerSignatureUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
