import '../../../constants/app_collections.dart';
import '../../../models/court_case.dart';
import '../../../services/app_firebase.dart';
import '../../../services/firebase_export.dart';

class CaseService {
  static final _firestore = AppFirebase().firestore;

  static Future<void> addCase(Case c) async {
    await _firestore
        .collection(AppCollections.lawyers)
        .doc(c.lawyerId)
        .collection(AppCollections.cases)
        .add(c.toMap());
  }

  static Future<void> updateCase(Case c) async {
    if (c.docId == null) throw Exception('Case document id required');
    await _firestore
        .collection(AppCollections.lawyers)
        .doc(c.lawyerId)
        .collection(AppCollections.cases)
        .doc(c.docId)
        .update(c.toMap());
  }

  static Future<void> deleteCase(Case c) async {
    if (c.docId == null) throw Exception('Case document id required');
    await _firestore
        .collection(AppCollections.lawyers)
        .doc(c.lawyerId)
        .collection(AppCollections.cases)
        .doc(c.docId)
        .delete();
  }

  static Stream<List<Case>> getCases(String lawyerId, {DateTime? date}) {
    final ref = _firestore
        .collection(AppCollections.lawyers)
        .doc(lawyerId)
        .collection(AppCollections.cases);
    Query query = ref;
    if (date != null) {
      final start = DateTime(date.year, date.month, date.day);
      final end = start.add(const Duration(days: 1));
      query = ref.where('nextDate', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
                 .where('nextDate', isLessThan: Timestamp.fromDate(end));
    }
    return query.snapshots().map((snap) =>
        snap.docs.map((d) => Case.fromMap(d.data() as Map<String, dynamic>, docId: d.id)).toList());
  }
}
