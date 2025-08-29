import 'package:courtdiary/widgets/data_not_found.dart';
import 'package:courtdiary/widgets/party_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/party_controller.dart';
import 'party_profile_screen.dart';

class PartyScreen extends StatelessWidget {
  const PartyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PartyController());
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.parties.isEmpty) {
        return const DataNotFound(title: "Sorry", subtitle: 'No Party Found');
      }
      return ListView.builder(
        itemCount: controller.parties.length,
        itemBuilder: (context, index) {
          final party = controller.parties[index];
          return PartyTile(
            party: party,
            onTap: () {
              Get.to(() => PartyProfileScreen(party: party));
            },
          );
        },
      );
    });
  }
}
