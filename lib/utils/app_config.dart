import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courtdiary/constants/app_collections.dart';
import 'package:courtdiary/models/app_config.dart';
import 'package:flutter/foundation.dart';


class AppConfigService {
  static AppConfig? _config;

  static AppConfig? get config => _config;

  static Future<void> load({required String docId}) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection(AppCollections.appConfig)
          .doc(docId)
          .get();

      if (doc.exists) {
        _config = AppConfig.fromJson(doc.data()!);
        if (kDebugMode) {
          print('AppConfig loaded: ${_config!.toJson()}');
        }
      } else {
        if (kDebugMode) {
          print('AppConfig not found.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading AppConfig: $e');
      }
    }
  }
}
