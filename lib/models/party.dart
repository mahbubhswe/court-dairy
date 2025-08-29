class Party {
  final String name;
  final String phone;
  final String address;
  final String lawyerId; // New field added

  // Map to hold dynamic fields
  Map<String, dynamic> _dynamicFields = {};

  // Constructor
  Party({
    required this.name,
    required this.phone,
    required this.address,
    required this.lawyerId, // Include the new field in the constructor
  });

  // Method to convert Party object to a Map (for example, to store in a database)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'address': address,
      'lawyerId': lawyerId, // Include the new field in the map
      ..._dynamicFields, // Include dynamic fields in the map
    };
  }

  // Method to create a Party object from a Map (for example, when retrieving from a database)
  factory Party.fromMap(Map<String, dynamic> map) {
    Party party = Party(
      name: map['name'],
      phone: map['phone'],
      address: map['address'],
      lawyerId: map['lawyerId'], // Extract the new field from the map
    );

    // Extract dynamic fields (fields not predefined in the class)
    party._dynamicFields = Map<String, dynamic>.from(map)
      ..removeWhere((key, value) =>
          ['name', 'phone', 'address', 'lawyerId'].contains(key));

    return party;
  }

  // Method to set a dynamic field
  void setDynamicField({required String key, required dynamic value}) {
    _dynamicFields[key] = value;
  }

  // Method to get a dynamic field
  dynamic getDynamicField({required String key}) {
    return _dynamicFields[key];
  }
}
