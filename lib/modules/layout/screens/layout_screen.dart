import 'package:courtdiary/modules/accounts/screens/accounts_screen.dart';
import 'package:courtdiary/modules/case/controllers/case_controller.dart';
import 'package:courtdiary/modules/case/screens/add_case_screen.dart';
import 'package:courtdiary/modules/case/screens/case_screen.dart';
import 'package:courtdiary/modules/case/screens/case_search_screen.dart';
import 'package:courtdiary/modules/case/screens/overdue_cases_screen.dart';
import 'package:courtdiary/themes/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
// import '../../../screens/calculator_screen.dart';
import '../../../screens/customer_service_screen.dart';
import '../../../constants/app_texts.dart';
import '../../accounts/screens/add_transaction_screen.dart';
import '../../case/screens/case_fullscreen_screen.dart';
import '../../case/screens/case_calendar_screen.dart';
import '../../party/screens/add_party_screen.dart';
import '../../party/screens/party_screen.dart';
import '../widgets/app_drawer.dart';
import '../controllers/layout_controller.dart';
import '../widgets/dashboard.dart';
import '../../../utils/activation_guard.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen>
    with WidgetsBindingObserver {
  final themeController = Get.find<ThemeController>();
  final layoutController = Get.put(LayoutController());
  final _caseController = Get.put(CaseController());

  bool _isShowingOverdueSheet = false;
  Worker? _casesWorker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initial check after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeShowOverdueSheet();
    });
    // Re-check once cases list updates (e.g., after initial fetch)
    _casesWorker = ever(_caseController.cases, (_) {
      _maybeShowOverdueSheet();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _casesWorker?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Slight delay to allow data to refresh
      Future.delayed(const Duration(milliseconds: 150), _maybeShowOverdueSheet);
    }
  }

  bool _isEveningToMorningWindow(DateTime now) {
    // Show between 16:00 (4 PM) and 08:59 next day
    return now.hour >= 16 || now.hour < 9;
  }

  Future<void> _maybeShowOverdueSheet() async {
    if (!mounted || _isShowingOverdueSheet) return;
    final now = DateTime.now();
    if (!_isEveningToMorningWindow(now)) return;

    // If still loading, skip this attempt.
    if (_caseController.isLoading.value) return;

    final overdue = _caseController.overdueCases;
    if (overdue.isEmpty) return;

    _isShowingOverdueSheet = true;
    await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _OverdueSheetContent(
        count: overdue.length,
        onViewAll: () {
          Navigator.of(ctx).pop();
          Get.to(() => const OverdueCasesScreen());
        },
      ),
    );
    _isShowingOverdueSheet = false;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            leadingWidth: 40,
            titleSpacing: 0,
            title: const Text('Court Dairy'),
            actions: [
              IconButton(
                onPressed: () {
                  Get.to(() => CaseSearchScreen());
                },
                icon: const Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {
                  Get.to(() => const CaseFullscreenScreen(),
                      fullscreenDialog: true);
                },
                icon: const Icon(HugeIcons.strokeRoundedArrowAllDirection),
                tooltip: 'ফুলস্ক্রিন কেস',
              ),
              IconButton(
                onPressed: () {
                  Get.to(() => CaseCalendarScreen(), fullscreenDialog: true);
                },
                icon: const Icon(HugeIcons.strokeRoundedCalendar01),
                tooltip: 'কেস ক্যালেন্ডার',
              ),
              IconButton(
                onPressed: () {
                  Get.to(() => const CustomerServiceScreen());
                },
                icon: const Icon(HugeIcons.strokeRoundedCustomerService01),
                tooltip: AppTexts.customerService,
              ),
            ],
          ),
          drawer: AppDrawer(),
          floatingActionButton: Obx(() {
            final visible = layoutController.isDashboardVisible.value;
            return AnimatedScale(
              scale: visible ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                opacity: visible ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                child: FloatingActionButton(
                  onPressed: () {
                    if (!ActivationGuard.check()) return;
                    final index = DefaultTabController.of(context).index;
                    if (index == 0) {
                      Get.to(() => const AddCaseScreen(),
                          fullscreenDialog: true);
                    } else if (index == 1) {
                      Get.to(() => const AddPartyScreen(),
                          fullscreenDialog: true);
                    } else {
                      Get.to(() => const AddTransactionScreen(),
                          fullscreenDialog: true);
                    }
                  },
                  child: const Icon(Icons.add_circle),
                ),
              ),
            );
          }),
          body: Column(
            children: [
              Obx(() {
                return AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: layoutController.isDashboardVisible.value
                      ? Dashboard()
                      : const SizedBox.shrink(),
                );
              }),
              Expanded(
                child: Column(
                  children: [
                    TabBar(
                      dividerColor: Theme.of(context).colorScheme.outline,
                      tabs: const [
                        Tab(text: AppTexts.tabParty),
                        Tab(text: AppTexts.tabCase),
                        Tab(text: AppTexts.tabAccounts),
                      ],
                    ),
                    const Expanded(
                      child: TabBarView(
                        children: [
                          CaseScreen(),
                          PartyScreen(),
                          AccountsScreen(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _OverdueSheetContent extends StatelessWidget {
  const _OverdueSheetContent({required this.count, required this.onViewAll});
  final int count;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade600),
                  ),
                  child: const Icon(
                    HugeIcons.strokeRoundedCalendar01,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('বকেয়া হিয়ারিং আপডেট',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 2),
                      Text(
                        count == 1
                            ? '১টি কেসের তারিখ পার হয়ে গেছে, আপডেট করা প্রয়োজন।'
                            : '$count টি কেসের তারিখ পার হয়ে গেছে, আপডেট করা প্রয়োজন।',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Icon(
                    HugeIcons.strokeRoundedClock01,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'লিস্ট খুলে নেক্সট হিয়ারিং ডেট দেখে আপডেট করুন।',
                      style: textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('পরে'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.teal,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onViewAll,
                    icon: const Icon(HugeIcons.strokeRoundedArrowRight02),
                    label: const Text('সব কেস দেখুন'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
