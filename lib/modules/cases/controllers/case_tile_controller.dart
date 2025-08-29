import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courtdiary/constants/app_collections.dart';
import 'package:courtdiary/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/notification_service.dart';

class CaseTileController extends GetxController {
  Future<void> upateNextHearingDate(
      {required BuildContext context,
      required Timestamp timestamp,
      required String id}) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: timestamp.toDate(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    Map<String, dynamic> date = {
      'nextDate': Timestamp.fromDate(pickedDate!),
      'lastUpdated': Timestamp.fromDate(pickedDate)
    };
    await updateDocument(
        collectionName: AppCollections.CASES, id: id, data: date);
  }

  Future<void> upateIsSendSms(
      {required BuildContext context,
      required bool isSendSms,
      required String id}) async {
    Get.snackbar('Sorry', 'Under Development', colorText: Colors.teal);

    // Map<String, dynamic> date = {
    //   'isSendSms': !isSendSms,
    //   'lastUpdated': Timestamp.now()
    // };
    // await updateDocument(
    //     collectionName: AppCollections.CASES, id: id, data: date);
  }

  Future<void> upateIsNotify(
      {required BuildContext context,
      required Timestamp timestamp,
      required String plaintiffName,
      required int notificationId,
      required String caseName,
      required bool isNotify,
      required String id}) async {
    Map<String, dynamic> date = {
      'isNotify': !isNotify,
      'lastUpdated': Timestamp.now()
    };
    await updateDocument(
        collectionName: AppCollections.CASES, id: id, data: date);

    if (isNotify) {
      NotificationService.cancelNotification(notificationId);
    } else {
      DateTime dateTime = timestamp.toDate().subtract(Duration(days: 1))
        ..copyWith(hour: 22, minute: 0);
      NotificationService.scheduleNotification(
          id: notificationId,
          title: 'Case for Tomorrow',
          body: '$plaintiffName - $caseName',
          scheduleDateTime: dateTime);
    }
    Get.snackbar('Success', 'Updated Successfully', colorText: Colors.teal);
  }
}
