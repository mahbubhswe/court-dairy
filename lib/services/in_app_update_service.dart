import 'package:in_app_update/in_app_update.dart';

class InAppUpdateService {
  // Static method to check for updates
  static Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((updateInfo) {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate();
      }
    }).catchError((e) {});
  }
}
