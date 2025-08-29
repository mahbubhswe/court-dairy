import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountActivationService {
  static Future<void> markAccountActivated() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No authenticated user found.');
    }

    await FirebaseFirestore.instance.collection('shops').doc(user.uid).update({
      'isActivated': true,
      'activationDate': FieldValue.serverTimestamp(),
    });
  }
}
