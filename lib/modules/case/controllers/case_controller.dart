import 'package:get/get.dart';

import '../../../models/court_case.dart';
import '../../../services/app_firebase.dart';
import '../services/case_service.dart';

class CaseController extends GetxController {
  final RxList<Case> cases = <Case>[].obs;
  final RxBool isLoading = true.obs;
  DateTime? filterDate;

  @override
  void onInit() {
    super.onInit();
    loadTodayCases();
  }

  void loadTodayCases() {
    final user = AppFirebase().currentUser;
    if (user == null) {
      isLoading.value = false;
      return;
    }
    CaseService.getCases(user.uid, date: DateTime.now()).listen((data) {
      cases.value = data;
      isLoading.value = false;
    });
  }

  void loadAllCases({DateTime? date}) {
    final user = AppFirebase().currentUser;
    if (user == null) {
      isLoading.value = false;
      return;
    }
    isLoading.value = true;
    CaseService.getCases(user.uid, date: date).listen((data) {
      cases.value = data;
      isLoading.value = false;
    });
  }

  Future<void> deleteCase(Case c) async {
    await CaseService.deleteCase(c);
  }
}
