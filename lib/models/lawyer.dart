import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courtdiary/models/cost.dart';

class Lawyer {
  final String lawyerName;
  final String phone;
  final String district;
  final int subFor; // Subscription duration in days (e.g., 25 days)
  final int smsBalance; // Subscription duration in days (e.g., 25 days)
  final Timestamp subStart; // Subscription start timestamp
  final List<Cost> costs; // List of Cost objects
  final List<String> courts; // List of court names/types

  Lawyer( {
    required this.lawyerName,
    required this.smsBalance,
    required this.phone,
    required this.district,
    required this.subFor,
    required this.subStart,
    required this.costs, // Add costs as a parameter
    required this.courts, // Add courts as a parameter
  });

  // Convert a Lawyer instance to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'lawyerName': lawyerName,
      'phone': phone,
      'district': district,
      'subFor': subFor,
      'smsBalance':smsBalance,
      'subStart': subStart,
      'costs': costs
          .map((cost) => cost.toMap())
          .toList(), // Convert costs list to map
      'courts': courts, // Add courts list to map
    };
  }

  // Create a Lawyer instance from a Firestore document
  factory Lawyer.fromMap(Map<String, dynamic> map) {
    var costList = (map['costs'] as List?)
            ?.map((costMap) => Cost.fromMap(costMap as Map<String, dynamic>))
            .toList() ??
        [];

    var courtsList =
        List<String>.from(map['courts'] ?? []); // Parse courts list

    return Lawyer(
      lawyerName: map['lawyerName'] ?? '',
      phone: map['phone'] ?? '',
      district: map['district'] ?? '',
      smsBalance: map['smsBalance'] ?? '',
      subFor: map['subFor'] ?? 0,
      subStart: map['subStart'] ?? Timestamp.now(),
      costs: costList, // Initialize costs list
      courts: courtsList, // Initialize courts list
    );
  }
}
