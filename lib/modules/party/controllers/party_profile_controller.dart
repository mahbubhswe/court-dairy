import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/party.dart';
import '../services/party_service.dart';

class PartyProfileController extends GetxController {
  final Party party;
  PartyProfileController(this.party);

  final RxBool isDeleting = false.obs;

  Future<void> deleteParty() async {
    if (isDeleting.value) return;
    try {
      isDeleting.value = true;
      await PartyService.deleteParty(party);
      Get.back();
      Get.snackbar(
        'সফল হয়েছে',
        'পক্ষ মুছে ফেলা হয়েছে',
        backgroundColor: Colors.white,
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'ত্রুটি',
        'পক্ষ মুছতে ব্যর্থ হয়েছে',
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    } finally {
      isDeleting.value = false;
    }
  }
}
