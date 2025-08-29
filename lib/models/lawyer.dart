import 'package:courtdiary/services/firebase_export.dart';

class Lawyer {
  String? docId;
  final String name;
  final String address;
  final String fcmToken;
  final String phone;
  final int smsBalance;
  final double balance;
  final bool isActive;
  final int subFor;
  final DateTime subStartsAt;
  final List<String> courts; // ✅ New field

  Lawyer({
    this.docId,
    required this.name,
    required this.address,
    required this.fcmToken,
    required this.phone,
    required this.smsBalance,
    required this.balance,
    required this.isActive,
    required this.subFor,
    required this.subStartsAt,
    this.courts = const [], // ✅ Default empty list
  });

  /// Convert to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'fcmToken': fcmToken,
      'phone': phone,
      'smsBalance': smsBalance,
      'balance': balance,
      'isActive': isActive,
      'subFor': subFor,
      'subStartsAt': subStartsAt,
      'courts': courts, // ✅ Save courts list
    };
  }

  /// Create from Firestore Map
  factory Lawyer.fromMap(Map<String, dynamic> map, {String? docId}) {
    return Lawyer(
      docId: docId,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      fcmToken: map['fcmToken'] ?? '',
      phone: map['phone'] ?? '',
      smsBalance: map['smsBalance'] ?? 0,
      balance: (map['balance'] ?? 0).toDouble(),
      isActive: map['isActive'] ?? false,
      subFor: map['subFor'] ?? 0,
      subStartsAt: (map['subStartsAt'] as Timestamp).toDate(),
      courts: List<String>.from(map['courts'] ?? []), // ✅ Load courts safely
    );
  }

  /// Get subscription end date
  DateTime get subscriptionEndsAt => subStartsAt.add(Duration(days: subFor));
}
