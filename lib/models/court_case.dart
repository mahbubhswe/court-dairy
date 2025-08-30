import 'package:cloud_firestore/cloud_firestore.dart';
import 'party.dart';

class CourtCase {
  // Case Information
  String caseId;
  String caseType;
  String caseTitle;
  String courtName;
  String caseNumber;
  Timestamp filedDate; // Use Timestamp instead of DateTime
  String caseStatus;

  // Plaintiff and Defendant Information
  Party plaintiff;
  Party defendant;

  // Hearing Dates
  List<Timestamp> hearingDates; // Use Timestamp instead of DateTime

  // Judge Information
  String judgeName;

  // Documents Attached
  List<String> documentsAttached;

  // Court Orders
  List<String> courtOrders;

  // Case Summary
  String caseSummary;

  // Constructor
  CourtCase({
    required this.caseId,
    required this.caseType,
    required this.caseTitle,
    required this.courtName,
    required this.caseNumber,
    required this.filedDate,
    required this.caseStatus,
    required this.plaintiff,
    required this.defendant,
    required this.hearingDates,
    required this.judgeName,
    required this.documentsAttached,
    required this.courtOrders,
    required this.caseSummary,
  });

  // Method to convert the case data to a map (for Firebase storage)
  Map<String, dynamic> toMap() {
    return {
      'caseId': caseId,
      'caseType': caseType,
      'caseTitle': caseTitle,
      'courtName': courtName,
      'caseNumber': caseNumber,
      'filedDate': filedDate, // Firestore Timestamp will be directly saved
      'caseStatus': caseStatus,
      'plaintiff': plaintiff.toMap(),
      'defendant': defendant.toMap(),
      'hearingDates': hearingDates
          .map((e) => e)
          .toList(), // Firestore Timestamp will be directly saved
      'judgeName': judgeName,
      'documentsAttached': documentsAttached,
      'courtOrders': courtOrders,
      'caseSummary': caseSummary,
    };
  }

  // Method to convert a map to a CourtCase object (for fetching data from Firebase)
  factory CourtCase.fromMap(Map<String, dynamic> map) {
    return CourtCase(
      caseId: map['caseId'],
      caseType: map['caseType'],
      caseTitle: map['caseTitle'],
      courtName: map['courtName'],
      caseNumber: map['caseNumber'],
      filedDate: map['filedDate'], // Firestore Timestamp
      caseStatus: map['caseStatus'],
      plaintiff: Party.fromMap(map['plaintiff']),
      defendant: Party.fromMap(map['defendant']),
      hearingDates: List<Timestamp>.from(
          map['hearingDates'] ?? []), // Convert to List of Timestamps
      judgeName: map['judgeName'],
      documentsAttached: List<String>.from(map['documentsAttached']),
      courtOrders: List<String>.from(map['courtOrders']),
      caseSummary: map['caseSummary'],
    );
  }
}
