import 'package:courtdiary/models/lawyer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../services/layout_service.dart';

class LayoutController extends GetxController {
  final layoutService = LayoutService();
  final ScrollController scrollController = ScrollController();
  final isDashboardVisible = true.obs;


  Rxn<Lawyer> lawyer = Rxn<Lawyer>(); // nullable observable shop object

  @override
  void onInit() {
    scrollController.addListener(_onScroll);
    fetchShopInfo(); // fetch shop data on init
    super.onInit();
  }

  void _onScroll() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (isDashboardVisible.value) isDashboardVisible.value = false;
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (!isDashboardVisible.value) isDashboardVisible.value = true;
    }
  }

  void fetchShopInfo() {
    layoutService.getShopInfo().listen((shopData) {
      lawyer.value = shopData as Lawyer?;
    });
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }
}
