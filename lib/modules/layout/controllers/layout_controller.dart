// layout_controller.dart
import 'package:courtdiary/models/lawyer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../../../models/cost.dart';

class LayoutController extends GetxController {
  RxList<Cost> costList = <Cost>[].obs;
  RxList<String> courtList = <String>[].obs;

  final ScrollController scrollController = ScrollController();
  final isDashboardVisible = true.obs;
  final fabSize = 150.0.obs; // Default size for FloatingActionButton
  void costCalculation(
      {required AsyncSnapshot<Map<String, dynamic>> snapshot}) {
    Lawyer lawyer = Lawyer.fromMap(snapshot.data!);
    costList.value = lawyer.costs;
    courtList.value = lawyer.courts;
  }

  @override
  void onInit() {
    scrollController.addListener(_onScroll);
    super.onInit();
  }

  void _onScroll() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (isDashboardVisible.value) {
        isDashboardVisible.value = false;
      }
      fabSize.value = 50.0; // Decrease size when scrolling down
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!isDashboardVisible.value) {
        isDashboardVisible.value = true;
      }
      fabSize.value = 150.0; // Increase size when scrolling up
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
