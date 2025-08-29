import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:auto_animated/auto_animated.dart'; // Import the auto_animated package
import '../../layout/controllers/layout_controller.dart';
import '../widgets/cost_dailog.dart';
import '../widgets/cost_tile.dart';

class CostView extends StatelessWidget {
  const CostView({super.key});

  @override
  Widget build(BuildContext context) {
    final LayoutController layoutController = Get.put(LayoutController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            showCostInputDialog(
              context: context,
            );
          },
          label: Text('Add Cost'),
          icon: HugeIcon(
              icon: HugeIcons.strokeRoundedPayment02,
              color: Theme.of(context).colorScheme.onSurface),
        ),
        Expanded(
          child: LiveList(
            // LiveList is a widget provided by the auto_animated package
            showItemInterval:
                Duration(milliseconds: 100), // Delay between items appearing
            showItemDuration: Duration(
                milliseconds: 500), // Duration of animation for each item
            itemCount: layoutController.costList.length,
            itemBuilder: (context, index, animation) {
              // Use the animation to animate the CostTile
              return FadeTransition(
                opacity: animation, // Apply fade-in effect with animation
                child: CostTile(
                  cost: layoutController.costList[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
