import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/court_case.dart';
import '../screens/case_detail_screen.dart';

class CaseTile extends StatelessWidget {
  const CaseTile({super.key, required this.caseItem});

  final CourtCase caseItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(caseItem.caseTitle),
      subtitle: Text(caseItem.caseNumber),
      onTap: () {
        Get.to(() => CaseDetailScreen(caseItem));
      },
    );
  }
}
