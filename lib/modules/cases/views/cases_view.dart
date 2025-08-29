import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auto_animated/auto_animated.dart'; // Import the auto_animated package
import 'package:courtdiary/modules/cases/widgets/case_tile.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../layout/controllers/layout_controller.dart';
import '../controllers/cases_view_controller.dart';

class CasesView extends StatelessWidget {
  const CasesView({super.key});

  openYouTubeVideo() async {
    var url = Uri.parse('https://www.youtube.com/watch?v=S_RnowYQtKo');
    if (await launchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final CaseViewController caseViewController = Get.put(CaseViewController());
    final LayoutController controller = Get.put(LayoutController());

    return Obx(() {
      // Show a message if no parties are found
      if (caseViewController.caseList.isEmpty) {
        return TextButton.icon(
            onPressed: () {
              openYouTubeVideo();
            },
            label: Text(
              'ব্যবহারবিধি দেখুন',
              textScaler: TextScaler.linear(1.1),
            ),
            icon: Icon(
              HugeIcons.strokeRoundedYoutube,
              size: 30,
            ));
      }

      // Display the list of cases with animation
      else {
        return LiveList(
          controller: controller.scrollController,
          showItemInterval:
              Duration(milliseconds: 100), // Delay between items appearing
          showItemDuration: Duration(
              milliseconds: 500), // Duration of animation for each item
          itemCount: caseViewController.caseList.length,
          itemBuilder: (context, index, animation) {
            return FadeTransition(
              opacity: animation, // Apply fade-in effect with animation
              child: CaseTile(
                singleCase: caseViewController.caseList[index],
              ),
            );
          },
        );
      }
    });
  }
}
