import '../../../constants/app_collections.dart';
import '../../../models/party.dart';
import '../../../services/app_firebase.dart';

class PartyService {
  static final _firestore = AppFirebase().firestore;

  static Future<void> addParty(Party party) async {
    await _firestore.collection(AppCollections.parties).add(party.toMap());
  }
}

