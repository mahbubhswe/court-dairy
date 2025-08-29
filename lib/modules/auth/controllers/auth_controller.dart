// ignore_for_file: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courtdiary/models/lawyer.dart';
import 'package:courtdiary/services/firebase_services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../constants/app_collections.dart';

class AuthController extends GetxController {
  final email = TextEditingController();
  final password = TextEditingController();
  DateTime date = DateTime.now();

  Future<dynamic> signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    if (userCredential.additionalUserInfo!.isNewUser) {
      createUser();
    }
    return userCredential;
  }

  void createUser() async {
    Lawyer lawyer = Lawyer(
        lawyerName: 'Court Diary',
        phone: '01xxxxxxxxx',
        district: 'Dhaka, Bangladesh',
        subFor: 25,
        subStart: Timestamp.now(),
        costs: [],
        courts: [],
        smsBalance: 0);
    await setDocument(
        collectionName: AppCollections.LAWYERS,
        data: lawyer.toMap(),
        documentId: FirebaseAuth.instance.currentUser!.uid);
  }

  void login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
    } catch (e) {
      Get.snackbar('দুঃখিত!', 'আপনার ইমেল অথবা পাসওয়ার্ড টি সঠিক নয়।',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void resetPassword() async {
    try {
      if (GetUtils.isEmail(email.text)) {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(
              email: email.text,
            )
            .whenComplete(() => Get.snackbar(
                  'আপনার ইমেল চেক করুন',
                  'আপনার ইমেইলে নতুন পাসওয়ার্ড সেট করার জন্য লিঙ্ক পাঠানো হয়েছে। লিঙ্কে ক্লিক করে একটি নতুন পাসওয়ার্ড সেট করুন।',
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(12),
                  duration: const Duration(seconds: 25),
                ));
      } else {
        Get.snackbar(
          'ইমেইল টি সঠিক নয়।',
          'উপরের ইমেইল বক্সে আপনার একাউন্টের ইমেল এড্রেস লিখুন এর পর Forgot Password এ ক্লিক করুন।',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 25),
        );
      }
    } catch (e) {
      Get.snackbar('দুঃখিত!', 'কিছু একটা সমস্যা হয়েছে',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
