import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/party.dart';
import '../../../services/app_firebase.dart';
import '../services/party_service.dart';

class PartyProfileController extends GetxController {
  final Party party;
  PartyProfileController(this.party);

  final name = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();

  final Rx<XFile?> photo = Rx<XFile?>(null);
  final ImagePicker _picker = ImagePicker();

  final RxBool isLoading = false.obs;
  final RxBool enableBtn = false.obs;

  @override
  void onInit() {
    super.onInit();
    name.text = party.name;
    phone.text = party.phone;
    address.text = party.address;

    name.addListener(_validate);
    phone.addListener(_validate);
    address.addListener(_validate);
  }

  void _validate() {
    enableBtn.value = name.text.trim().isNotEmpty &&
        phone.text.trim().isNotEmpty &&
        address.text.trim().isNotEmpty;
  }

  void showImagePicker() {
    Get.bottomSheet(
      SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('গ্যালারি থেকে নির্বাচন করুন'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('ক্যামেরা ব্যবহার করুন'),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      photo.value = picked;
    }
  }

  Future<void> updateParty() async {
    if (!enableBtn.value || isLoading.value) return;
    try {
      isLoading.value = true;
      final user = AppFirebase().currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      String? photoUrl = party.photoUrl;
      if (photo.value != null) {
        photoUrl = await PartyService.uploadPartyPhoto(File(photo.value!.path), user.uid);
      }

      final updated = Party(
        docId: party.docId,
        name: name.text.trim(),
        phone: phone.text.trim(),
        address: address.text.trim(),
        lawyerId: user.uid,
        photoUrl: photoUrl,
      );

      await PartyService.updateParty(updated);

      Get.back();
      Get.snackbar(
        'সফল হয়েছে',
        'পক্ষ আপডেট করা হয়েছে',
        backgroundColor: Colors.white,
        colorText: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'ত্রুটি',
        'পক্ষ আপডেট করতে ব্যর্থ হয়েছে',
        backgroundColor: Colors.white,
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    name.dispose();
    phone.dispose();
    address.dispose();
    photo.value = null;
    super.onClose();
  }
}
