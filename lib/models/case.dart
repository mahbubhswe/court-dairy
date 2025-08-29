
import '../services/firebase_export.dart';

class Case {
  final String caseNumber; // Unique identifier for the case
  final String caseName; // Name of the case
  final String courtName; // Name of the court handling the case
  final String partyName; // Name of the party involved
  final String partyNumber; // Contact number of the party
  final String partyId; // Unique identifier for the party
  final String lawyerId; // Unique identifier for the lawyer
  final bool isNotify; // Notification status
  final bool isSendSms; // Indicates if SMS has been sent
  final String plaintiffName; // Name of the plaintiff
  final String defendantName; // Name of the defendant
  final String underSection; // Relevant section of the law
  final Timestamp nextDate; // Next hearing date
  final Timestamp previousDate; // Previous hearing date
  final String nextAction; // Description of the next action
  final String previousAction; // Description of the previous action
  final String casePriority; // Priority level (e.g., Low, Medium, High)
  final String caseOutcome; // Outcome (e.g., Win, Loss, Pending)
  final Timestamp lastUpdated; // Timestamp of the last update
  final Timestamp createdAt; // Timestamp when the case was created
  final String caseStatus; // Status (e.g., Active, Closed, Pending)
  final String partyType; // Type of the party (e.g., Plaintiff, Defendant)
  final int
      notificationId; // Unique notification ID for the case (changed to int)

  Case({
    required this.caseNumber,
    required this.caseName,
    required this.courtName,
    required this.partyName,
    required this.partyNumber,
    required this.partyId,
    required this.lawyerId,
    required this.isNotify,
    required this.isSendSms,
    required this.plaintiffName,
    required this.defendantName,
    required this.underSection,
    required this.nextDate,
    required this.previousDate,
    required this.nextAction,
    required this.previousAction,
    required this.casePriority,
    required this.caseOutcome,
    required this.lastUpdated,
    required this.createdAt, // Include createdAt in the constructor
    required this.caseStatus,
    required this.partyType, // Include partyType in the constructor
    required this.notificationId, // Include notificationId as int in the constructor

  });

  factory Case.fromMap(Map<String, dynamic> map) {
    return Case(
      caseNumber: map['caseNumber'] as String,
      caseName: map['caseName'] as String,
      courtName: map['courtName'] as String,
      partyName: map['partyName'] as String,
      partyNumber: map['partyNumber'] as String,
      partyId: map['partyId'] as String,
      lawyerId: map['lawyerId'] as String,
      isNotify: map['isNotify'] as bool,
      isSendSms: map['isSendSms'] as bool,
      plaintiffName: map['plaintiffName'] as String,
      defendantName: map['defendantName'] as String,
      underSection: map['underSection'] as String,
      nextDate: map['nextDate'] as Timestamp,
      previousDate: map['previousDate'] as Timestamp,
      nextAction: map['nextAction'] as String,
      previousAction: map['previousAction'] as String,
      casePriority: map['casePriority'] as String,
      caseOutcome: map['caseOutcome'] as String,
      lastUpdated: map['lastUpdated'] as Timestamp,
      createdAt: map['createdAt'] as Timestamp, // Extract createdAt from map
      caseStatus: map['caseStatus'] as String,
      partyType: map['partyType'] as String, // Extract partyType from map
      notificationId: map['notificationId']
          as int, 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'caseNumber': caseNumber,
      'caseName': caseName,
      'courtName': courtName,
      'partyName': partyName,
      'partyNumber': partyNumber,
      'partyId': partyId,
      'lawyerId': lawyerId,
      'isNotify': isNotify,
      'isSendSms': isSendSms,
      'plaintiffName': plaintiffName,
      'defendantName': defendantName,
      'underSection': underSection,
      'nextDate': nextDate,
      'previousDate': previousDate,
      'nextAction': nextAction,
      'previousAction': previousAction,
      'casePriority': casePriority,
      'caseOutcome': caseOutcome,
      'lastUpdated': lastUpdated,
      'createdAt': createdAt, // Add createdAt to map
      'caseStatus': caseStatus,
      'partyType': partyType, // Add partyType to map
      'notificationId': notificationId, // Add notificationId as int to map
    };
  }


}
