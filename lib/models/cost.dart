import 'package:cloud_firestore/cloud_firestore.dart';

class Cost {
  final Timestamp timestamp; // To store the time of the Cost
  final double amount; // To store the Cost amount
  final String comment; // To store any additional comments about the Cost

  // Constructor
  Cost({
    required this.timestamp,
    required this.amount,
    required this.comment,
  });

  // Factory method to create a Cost instance from a map (e.g., from Firestore)
  factory Cost.fromMap(Map<String, dynamic> map) {
    return Cost(
      // Handle potential null value for timestamp with a default value
      timestamp:
          map['timestamp'] is Timestamp ? map['timestamp'] : Timestamp.now(),
      amount: map['amount'] as double? ?? 0.0, // Default amount if null
      comment: map['comment'] ?? '', // Default empty string if null
    );
  }

  // Method to convert a Cost instance to a map (e.g., for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'amount': amount,
      'comment': comment,
    };
  }
}
