import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auto_animated/auto_animated.dart'; // Import the auto_animated package
import '../../../widgets/no_record_found.dart';
import '../../layout/controllers/layout_controller.dart';
import '../controllers/parties_view_controller.dart';
import '../widgets/party_tile.dart';

class PartiesView extends StatelessWidget {
  const PartiesView({super.key});

  @override
  Widget build(BuildContext context) {
    final PartiesViewController partiesViewController =
        Get.put(PartiesViewController());
    final LayoutController controller = Get.put(LayoutController());

    return Obx(() {
      // Show a message if no parties are found
      if (partiesViewController.partyList.isEmpty) {
        return const NoRecordFound();
      }

      // Display the list of parties with animation
      return LiveList.options(
        controller: controller.scrollController,
        options: LiveOptions(
          delay: const Duration(milliseconds: 100),
          showItemInterval: const Duration(milliseconds: 100),
          showItemDuration: const Duration(milliseconds: 500),
        ),
        itemCount: partiesViewController.partyList.length,
        itemBuilder: (context, index, animation) {
          return FadeTransition(
            opacity: animation, // Apply fade-in effect
            child: PartyTile(
              party: partiesViewController.partyList[index],
            ),
          );
        },
      );
    });
  }
}
