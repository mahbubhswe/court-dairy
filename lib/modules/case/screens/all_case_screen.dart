import 'package:courtdiary/widgets/data_not_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/app_firebase.dart';
import '../controllers/case_controller.dart';
import '../services/case_service.dart';
import '../screens/edit_case_screen.dart';
import '../../../utils/activation_guard.dart';
import '../../../models/court_case.dart';
import '../../../widgets/case_tile.dart' as app_case_tile;
import 'case_detail_screen.dart';

class AllCaseScreen extends StatelessWidget {
  AllCaseScreen({super.key});

  final controller = Get.find<CaseController>();
  final RxString typeFilter = 'All'.obs;
  final RxString dateFilter = 'All'.obs;

  DateTime? _nextDate(CourtCase c) {
    if (c.hearingDates.isEmpty) return null;
    return c.hearingDates.first.toDate();
  }

  @override
  Widget build(BuildContext context) {
    final dates = ['All', 'Today', 'Tomorrow', 'This Week', 'This Month'];
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
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(t),
                            selected: selected,
                            onSelected: (_) => typeFilter.value = t,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Date',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: dateFilter.value,
                    isExpanded: true,
                    borderRadius: BorderRadius.circular(12),
                    menuMaxHeight: 320,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    decoration: InputDecoration(
                      labelText: 'Date',
                      prefixIcon: const Icon(Icons.date_range_outlined),
                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.7),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.4,
                        ),
                      ),
                    ),
                    items: dates
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => dateFilter.value = v ?? 'All',
                  ),
                ],
              );
            }),
          ),
          Expanded(
            child: Obx(() {
              final now = DateTime.now();
              final filtered = controller.cases.where((c) {
                final tMatch =
                    typeFilter.value == 'All' || c.caseType == typeFilter.value;
                bool dMatch = true;
                final d = _nextDate(c) ?? c.filedDate.toDate();
                switch (dateFilter.value) {
                  case 'Today':
                    dMatch = d.year == now.year &&
                        d.month == now.month &&
                        d.day == now.day;
                    break;
                  case 'Tomorrow':
                    final tmr = now.add(const Duration(days: 1));
                    dMatch = d.year == tmr.year &&
                        d.month == tmr.month &&
                        d.day == tmr.day;
                    break;
                  case 'This Week':
                    final start = now.subtract(Duration(days: now.weekday - 1));
                    final end = start.add(const Duration(days: 7));
                    dMatch = d.isAfter(start) && d.isBefore(end);
                    break;
                  case 'This Month':
                    dMatch = d.year == now.year && d.month == now.month;
                    break;
                  default:
                    dMatch = true;
                }
                return tMatch && dMatch;
              }).toList();

              if (filtered.isEmpty) {
                return const DataNotFound(
                    title: 'Sorry', subtitle: 'No cases found');
              }

              return ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  return app_case_tile.CaseTile(
                    data: item,
                    onTap: () => Get.to(() => CaseDetailScreen(item)),
                    onEdit: () {
                      if (ActivationGuard.check()) {
                        Get.to(() => EditCaseScreen(item));
                      }
                    },
                    onDelete: () async {
                      if (!ActivationGuard.check()) return;
                      final user = AppFirebase().currentUser;
                      if (user != null && item.docId != null) {
                        await CaseService.deleteCase(item.docId!, user.uid);
                      }
                    },
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }
}
