// ignore_for_file: must_be_immutable, depend_on_referenced_packages
import 'package:flutter/material.dart';

import 'dashboard_widget.dart';

class AppHero extends StatelessWidget {
  const AppHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DashboardWidget(),
        // HeroText(),
      ],
    );
  }
}
