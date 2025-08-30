import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/court_case.dart';
import '../controllers/case_controller.dart';
import 'edit_case_screen.dart';
import '../../../utils/activation_guard.dart';

class CaseProfileScreen extends StatelessWidget {
  final Case caseData;
  const CaseProfileScreen({super.key, required this.caseData});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CaseController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(caseData.caseName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (ActivationGuard.check()) {
                Get.to(() => EditCaseScreen(caseData: caseData));
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              if (ActivationGuard.check()) {
                controller.deleteCase(caseData);
                Get.back();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _row('Case Number', caseData.caseNumber),
            _row('Court', caseData.courtName),
            _row('Party', caseData.partyName),
            _row('Plaintiff', caseData.plaintiffName),
            _row('Defendant', caseData.defendantName),
            _row('Next Date', caseData.nextDate.toDate().toString()),
            _row('Previous Date', caseData.previousDate.toDate().toString()),
            _row('Next Action', caseData.nextAction),
            _row('Previous Action', caseData.previousAction),
            _row('Status', caseData.caseStatus),
          ],
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
