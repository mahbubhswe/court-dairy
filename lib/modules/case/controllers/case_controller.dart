import 'package:get/get.dart';

import '../../../models/court_case.dart';
import '../../../services/app_firebase.dart';
import '../services/case_service.dart';

class CaseController extends GetxController {
  final cases = <CourtCase>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    final user = AppFirebase().currentUser;
    if (user != null) {
      CaseService.getCases(user.uid).listen((event) {
        cases.value = event;
        isLoading.value = false;
      });
    } else {
      isLoading.value = false;
    }
  }

  Future<void> deleteCase(String docId) async {
    final user = AppFirebase().currentUser;
    if (user == null) return;
    await CaseService.deleteCase(docId, user.uid);
  }
}
