// layout_view.dart
import 'package:courtdiary/modules/costs/views/cost_view.dart';
import 'package:courtdiary/services/firebase_services.dart';
import 'package:courtdiary/services/theme_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/app_collections.dart';
import '../../add_party_case.dart';
import '../../cases/views/cases_view.dart';
import '../../cases/views/search_view.dart';
import '../../parties/views/parties_view.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_hero.dart';
import '../controllers/layout_controller.dart';

class LayoutView extends StatelessWidget {
  const LayoutView({super.key});

  Future<void> callToWhatsApp({required String phoneNumber}) async {
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'api.whatsapp.com',
      path: 'send',
      queryParameters: {
        'phone': '+88$phoneNumber',
        'text': 'আপনার পরামর্শ ও মতামত লিখুন।'
      },
    );
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final LayoutController controller = Get.put(LayoutController());
    return StreamBuilder(
        stream: getDocumentStreemById(
            collectionName: AppCollections.LAWYERS,
            id: FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            controller.costCalculation(snapshot: snapshot);
            return Scaffold(
              appBar: AppBar(
                title: const Text('Court Diary'),
                actions: [
                  IconButton(
                    onPressed: () {
                      Get.to(() => SearchView());
                    },
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedSearch01,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 24.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ThemeService.switchTheme();
                    },
                    icon: HugeIcon(
                      icon: Theme.of(context).brightness == Brightness.dark
                          ? HugeIcons.strokeRoundedSun02
                          : HugeIcons.strokeRoundedMoon02,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 24.0,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      callToWhatsApp(phoneNumber: '01623218618');
                    },
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedCustomerService01,
                      color: Theme.of(context).colorScheme.onSurface,
                      size: 24.0,
                    ),
                  ),
                ],
              ),
              drawer: AppDrawer(
                documentSnapshot: snapshot,
              ),
              body: Column(
                children: [
                  Obx(() {
                    return AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: controller.isDashboardVisible.value
                          ? const AppHero()
                          : const SizedBox.shrink(),
                    );
                  }),
                  Expanded(
                    child: DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          const TabBar(
                            tabs: [
                              Tab(text: 'Cases'),
                              Tab(text: 'Party'),
                              Tab(text: 'Cost'),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: TabBarView(
                                children: [
                                  CasesView(),
                                  PartiesView(),
                                  CostView()
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: Obx(() => SizedBox(
                    width: controller.fabSize.value,
                    height: 50,
                    child: FloatingActionButton(
                      onPressed: () {
                        Get.to(() => AddPartyCase());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize
                              .min, // Makes sure the text and icon fit together
                          children: [
                            Icon(Icons.add_circle),
                            Visibility(
                                visible: !(controller.fabSize.value == 50),
                                child: Text('Add Case/Party')),
                          ],
                        ),
                      ),
                    ),
                  )),
            );
          } else {
            return Center(child: CupertinoActivityIndicator());
          }
        });
  }
}
