import '../../../constants/app_collections.dart';
import '../../../models/court_case.dart';
import '../../../services/app_firebase.dart';

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
    if (docId.isEmpty) {
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
            .map((doc) => CourtCase.fromMap(doc.data()))
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
}
