import 'package:courtdiary/widgets/data_not_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/case_controller.dart';
import '../widgets/case_tile.dart';

class AllCaseScreen extends StatelessWidget {
  AllCaseScreen({super.key});

  final controller = Get.find<CaseController>();
  final RxString typeFilter = 'All'.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Cases')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Obx(() {
              final uniqueTypes =
                  controller.cases.map((c) => c.caseType).toSet().toList();
              final types = ['All', ...uniqueTypes];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Case Type',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: types.map((t) {
                        final selected = typeFilter.value == t;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(t,
                                style: const TextStyle(fontSize: 12)),
                            selected: selected,
                            onSelected: (_) => typeFilter.value = t,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            }),
          ),
          Expanded(
            child: Obx(() {
              final filtered = controller.cases.where((c) {
                return typeFilter.value == 'All' ||
                    c.caseType == typeFilter.value;
              }).toList();

              if (filtered.isEmpty) {
                return const DataNotFound(
                    title: 'Sorry', subtitle: 'No cases found');
              }

              return ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  return CaseTile(caseItem: item);
                },
              );
            }),
          )
        ],
      ),
    );
  }
}
