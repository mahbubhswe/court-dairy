import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bkash/flutter_bkash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:uuid/uuid.dart';

import 'app_button.dart';

class BuySms extends StatefulWidget {
  const BuySms({super.key});

  @override
  State<BuySms> createState() => _BuySmsState();
}

class _BuySmsState extends State<BuySms> {
  int smsCount = 32;
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
//make a payment
  payAndAddSms() async {
    String merchantInvoiceNumber = uuid.v1();
    try {
      var result = await _flutterBkash.pay(
        context: context,
        amount: (smsCount * getStorage.read('smsPrice')).toDouble(),
        merchantInvoiceNumber: merchantInvoiceNumber,
      );
      if (result.merchantInvoiceNumber == merchantInvoiceNumber) {
        Get.back();
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'smsBalance': FieldValue.increment(smsCount)
        }).whenComplete(() => Get.snackbar('Success', 'SMS added successfully',
                backgroundColor: Colors.white,
                colorText: Colors.green,
                duration: const Duration(seconds: 3)));
      }
    } on BkashFailure catch (e) {
      Get.snackbar('Error', e.message,
          backgroundColor: Colors.white, duration: const Duration(seconds: 3));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS - কিনুন'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              color: Colors.white,
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'SMS সিলেক্ট করতে ডানে বামে টানুন',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFCC2D3C),
                      ),
                    ),
                    const Divider(),
                    NumberPicker(
                      value: smsCount,
                      haptics: true,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: const Color(0xFFCC2D3C), width: 2),
                      ),
                      minValue: 32,
                      maxValue: 320,
                      step: 8,
                      axis: Axis.horizontal,
                      onChanged: (value) => setState(() {
                        smsCount = value;
                      }),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        'আপনি ${NumberFormat("##,##,##,###", "bn").format(smsCount)} টি SMS সিলেক্ট করেছেন।'),
                    Text(
                        'মোট চার্জঃ ${NumberFormat("##,##,##,###", "bn").format(smsCount * getStorage.read('smsPrice'))}৳'),
                    const SizedBox(
                      height: 10,
                    ),
                    AppButton(
                        title: 'পেমেন্ট করুন', onTap: () => payAndAddSms()),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text('Powered by App Seba - Your Trusted Friend.'),
            const Text(
              'Software Company',
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
