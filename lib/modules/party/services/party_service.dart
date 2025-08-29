import 'dart:io';

import '../../../constants/app_collections.dart';
import '../../../models/party.dart';
import '../../../services/app_firebase.dart';

class PartyService {
  static final _firestore = AppFirebase().firestore;
  static final _storage = AppFirebase().storage;

  static Future<void> addParty(Party party) async {
    await _firestore.collection(AppCollections.parties).add(party.toMap());
  }

  static Future<String> uploadPartyPhoto(File file, String userId) async {
    final path = 'party_photos/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref().child(path);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  static Stream<List<Party>> getParties(String lawyerId) {
    return _firestore
        .collection(AppCollections.parties)
        .where('lawyerId', isEqualTo: lawyerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Party.fromMap(doc.data(), docId: doc.id))
            .toList());
  }
}

