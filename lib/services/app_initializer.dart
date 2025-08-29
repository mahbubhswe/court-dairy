import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courtdiary/services/app_update_service.dart';
import 'package:courtdiary/services/fcm_service.dart';
import 'package:courtdiary/services/local_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import '../utils/app_config.dart';

class AppInitializer {
  static Future<void> initialize() async {
    // 1) Firebase core
    await Firebase.initializeApp();

    // 2) Firestore offline persistence
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // 3) Local storage
    await LocalStorageService.init();

    // 4) App config
    const docId = String.fromEnvironment('APP_CONFIG_ID', defaultValue: 'default');
    await AppConfigService.load(docId: docId);

    // 5) FCM token initialization and refresh listener
    await FcmService().initialize();

    // 6) Check for app updates in background
    await AppUpdateService.checkForAppUpdate();
  }
}
