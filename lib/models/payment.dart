import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final Timestamp timestamp; // To store the time of the payment
  final double amount; // To store the payment amount
  final String comment; // To store any additional comments about the payment

  // Constructor
  Payment({
    required this.timestamp,
    required this.amount,
    required this.comment,
  });

  // Factory method to create a Payment instance from a map (e.g., from Firestore)
  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      timestamp: map['timestamp'] as Timestamp,
      amount: map['amount'] as double,
      comment: map['comment'] ?? '',
    );
  }

  // Method to convert a Payment instance to a map (e.g., for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp,
      'amount': amount,
      'comment': comment,
    };
  }

}
