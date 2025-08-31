import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/court_case.dart';
import '../controllers/case_controller.dart';
import 'edit_case_screen.dart';

class CaseDetailScreen extends StatelessWidget {
  const CaseDetailScreen(this.caseItem, {super.key});

  final CourtCase caseItem;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CaseController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(caseItem.caseTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Get.to(() => EditCaseScreen(caseItem));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              final id = caseItem.docId;
              if (id != null) {
                controller.deleteCase(id);
                Get.back();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Case Number: ${caseItem.caseNumber}'),
            const SizedBox(height: 8),
            Text('Status: ${caseItem.caseStatus}'),
          ],
        ),
      ),
    );
  }
}
