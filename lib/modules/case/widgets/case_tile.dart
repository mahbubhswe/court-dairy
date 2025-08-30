import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/court_case.dart';
import '../controllers/case_controller.dart';
import '../screens/edit_case_screen.dart';

class CaseTile extends StatelessWidget {
  const CaseTile({super.key, required this.caseItem});

  final CourtCase caseItem;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CaseController>();
    return ListTile(
      title: Text(caseItem.caseTitle),
      subtitle: Text(caseItem.caseNumber),
      onTap: () {
        Get.to(() => EditCaseScreen(caseItem));
      },
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        onPressed: () {
          final id = caseItem.docId;
          if (id != null) {
            controller.deleteCase(id);
          }
        },
      ),
    );
  }
}
