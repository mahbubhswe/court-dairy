import '../../../constants/app_collections.dart';
import '../../../models/transaction.dart';
import '../../../services/app_firebase.dart';

class TransactionService {
  static final _firestore = AppFirebase().firestore;

  static Future<void> addTransaction(Transaction transaction, String userId) async {
    await _firestore
        .collection(AppCollections.lawyers)
        .doc(userId)
        .collection(AppCollections.transactions)
        .add(transaction.toMap());
  }

  static Stream<List<Transaction>> getTransactions(String userId) {
    return _firestore
        .collection(AppCollections.lawyers)
        .doc(userId)
        .collection(AppCollections.transactions)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Transaction.fromMap(doc.data(), docId: doc.id))
            .toList());
  }
}
