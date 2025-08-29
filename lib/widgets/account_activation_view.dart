// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bkash/flutter_bkash.dart';
import '../constants/app_colors.dart';
import 'app_button.dart';

class AccountActivation extends StatefulWidget {
  const AccountActivation({super.key});

  @override
  State<AccountActivation> createState() => _AccountActivationState();
}

class _AccountActivationState extends State<AccountActivation> {
  final getStorage = GetStorage();

  final _flutterBkash = FlutterBkash(
      bkashCredentials: const BkashCredentials(
    username: '01607415159',
    password: 'pJez!)58xD>',
    appKey: 'ms9YsMA6JHUH3D9V1BWuQm9ltc',
    appSecret: 'RJJZCZ75XxkGZGA5eFmLVju63y1KkLwZrrEJaKjX13Y07qiXARVS',
    isSandbox: false,
  ));

  var uuid = const Uuid();

  payAndActiveAccount() async {
    String merchantInvoiceNumber = uuid.v1();
    double amount = 199;
    try {
      var result = await _flutterBkash.pay(
        context: context,
        amount: amount,
        merchantInvoiceNumber: merchantInvoiceNumber,
      );

      if (result.merchantInvoiceNumber == merchantInvoiceNumber) {
        FirebaseFirestore.instance
            .collection('shops')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "subFor": 185,
          "subStart": DateTime.now(),
        }).whenComplete(() {
          Get.back();
          // NotificationService.showNotification(
          //     id: 9876543,
          //     title: 'একাউন্ট একটিভেশন',
          //     body: 'আপনার একাউন্টি সফলভাবে একটিভ হয়েছে।');
        });
      }
    } on BkashFailure catch (e) {
      Get.snackbar('Error', e.message,
          backgroundColor: Colors.white, duration: const Duration(seconds: 3));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.red,
            ), // iOS-style back icon
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'আপনার একাউন্টের সাবস্ক্রিপশনের মেয়াদ শেষ হয়ে যাওয়ার কারণে এই পেইজে নিয়ে আশা হয়েছে। সাবস্ক্রাইব করতে পেমেন্ট করুন।',
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 150,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('আপনার হিসাব-নিকাশ আজিবন নিরাপদ!'),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                            'আমাদের একটিভেসন চার্জ প্রতি ৬ মাসে মাত্র ${NumberFormat("##,##,##,###", "bn").format(199)} টাকা। পেমেন্ট করার সাথে সাথে আপনার স্টক খাতা একাউন্টি অটমেটিক ৬ মাসের জন্য একটিভ হয়ে যাবে। একটিভ করার জন্য নিচের পেমেন্ট বাটুনে ক্লিক করুন।',
                            textAlign: TextAlign.justify),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppButton(
                        title: 'পেমেন্ট করুন',
                        onTap: () => payAndActiveAccount()),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Powered by App Seba - Your Trusted Friend',
                    ),
                    const Text(
                      'Software Company',
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
