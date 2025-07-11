// lib/features/customers/models/customer_model.dart
class Customer {
  final String id;
  final String name;
  final String? location;
  final String? contactEmail;
  final String? contactPhone;
  final bool isActive;

  Customer({
    required this.id,
    required this.name,
    this.location,
    this.contactEmail,
    this.contactPhone,
    this.isActive = true,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      contactEmail: json['contactEmail'],
      contactPhone: json['contactPhone'],
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'contactEmail': contactEmail,
      'contactPhone': contactPhone,
      'isActive': isActive,
    };
  }
}

// lib/features/customers/services/customer_service.dart
class CustomerService {
  // Singleton instance
  static final CustomerService _instance = CustomerService._internal();
  factory CustomerService() => _instance;
  CustomerService._internal();

  // Mock customer data - in a real app, this would come from Firebase/API
  final List<Customer> _customers = [
    Customer(
      id: '1',
      name: 'Lone Star Trucking',
      location: 'Midland, TX',
      contactEmail: 'dispatch@lonestartrucking.com',
      contactPhone: '(432) 555-0123',
    ),
    Customer(
      id: '2',
      name: 'ABC Transport',
      location: 'Dallas, TX',
      contactEmail: 'ops@abctransport.com',
      contactPhone: '(214) 555-0456',
    ),
    Customer(
      id: '3',
      name: 'Johnson Logistics',
      location: 'El Paso, TX',
      contactEmail: 'info@johnsonlogistics.com',
      contactPhone: '(915) 555-0789',
    ),
    Customer(
      id: '4',
      name: 'Texas Oil Services',
      location: 'Houston, TX',
      contactEmail: 'contracts@texasoil.com',
      contactPhone: '(713) 555-0321',
    ),
    Customer(
      id: '5',
      name: 'Big Bend Energy',
      location: 'Odessa, TX',
      contactEmail: 'dispatch@bigbendenergy.com',
      contactPhone: '(432) 555-0654',
    ),
    Customer(
      id: '6',
      name: 'Permian Basin Logistics',
      location: 'Midland, TX',
      contactEmail: 'ops@permianlogistics.com',
      contactPhone: '(432) 555-0987',
    ),
  ];

  // Get all active customers
  List<Customer> getAllCustomers() {
    return _customers.where((customer) => customer.isActive).toList();
  }

  // Get customer by ID
  Customer? getCustomerById(String id) {
    try {
      return _customers.firstWhere((customer) => customer.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get customer by name
  Customer? getCustomerByName(String name) {
    try {
      return _customers.firstWhere((customer) => customer.name == name);
    } catch (e) {
      return null;
    }
  }

  // Add new customer (for admin/management features later)
  void addCustomer(Customer customer) {
    _customers.add(customer);
  }

  // Update customer
  void updateCustomer(Customer updatedCustomer) {
    final index = _customers.indexWhere((customer) => customer.id == updatedCustomer.id);
    if (index != -1) {
      _customers[index] = updatedCustomer;
    }
  }

  // Search customers by name (for filtering dropdown)
  List<Customer> searchCustomers(String query) {
    if (query.isEmpty) return getAllCustomers();

    return _customers
        .where((customer) =>
    customer.isActive &&
        customer.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}