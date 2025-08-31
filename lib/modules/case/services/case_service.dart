import '../../../constants/app_collections.dart';
import '../../../models/court_case.dart';
import '../../../services/app_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CaseService {
  static final _firestore = AppFirebase().firestore;

  static Future<void> addCase(CourtCase courtCase, String userId) async {
    final docRef = _firestore
        .collection(AppCollections.lawyers)
        .doc(userId)
        .collection(AppCollections.cases)
        .doc();
    courtCase.docId = docRef.id;
    await docRef.set(courtCase.toMap());
  }

  static Future<void> updateCase(CourtCase courtCase, String userId) async {
    final docId = courtCase.docId;
    if (docId == null || docId.isEmpty) {
      throw Exception('Case document ID is required for update');
    }
    await _firestore
        .collection(AppCollections.lawyers)
        .doc(userId)
        .collection(AppCollections.cases)
        .doc(docId)
        .update(courtCase.toMap());
  }

  static Stream<List<CourtCase>> getCases(String userId) {
    return _firestore
        .collection(AppCollections.lawyers)
        .doc(userId)
        .collection(AppCollections.cases)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CourtCase.fromMap(doc.data(), docId: doc.id))
            .toList());
  }

  static Future<void> deleteCase(String docId, String userId) async {
    await _firestore
        .collection(AppCollections.lawyers)
        .doc(userId)
        .collection(AppCollections.cases)
        .doc(docId)
        .delete();
  }

  static Future<void> addHearingDate(
      String docId, String userId, Timestamp date) async {
    await _firestore
        .collection(AppCollections.lawyers)
        .doc(userId)
        .collection(AppCollections.cases)
        .doc(docId)
        .update({
      'hearingDates': FieldValue.arrayUnion([date])
    });
  }

  static Future<void> removeHearingDate(
      String docId, String userId, Timestamp date) async {
    await _firestore
        .collection(AppCollections.lawyers)
        .doc(userId)
        .collection(AppCollections.cases)
        .doc(docId)
        .update({
      'hearingDates': FieldValue.arrayRemove([date])
    });
  }

  static Future<void> addCourtOrder(
      String docId, String userId, String order) async {
    await _firestore
        .collection(AppCollections.lawyers)
        .doc(userId)
        .collection(AppCollections.cases)
        .doc(docId)
        .update({
      'courtOrders': FieldValue.arrayUnion([order])
    });
  }

  static Future<void> removeCourtOrder(
      String docId, String userId, String order) async {
    await _firestore
        .collection(AppCollections.lawyers)
        .doc(userId)
        .collection(AppCollections.cases)
        .doc(docId)
        .update({
      'courtOrders': FieldValue.arrayRemove([order])
    });
  }

  static Future<void> updateCaseStatus(
      String docId, String userId, String status) async {
    await _firestore
        .collection(AppCollections.lawyers)
        .doc(userId)
        .collection(AppCollections.cases)
        .doc(docId)
        .update({'caseStatus': status});
  }
}
