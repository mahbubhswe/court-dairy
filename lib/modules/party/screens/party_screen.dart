import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/party_controller.dart';

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
        return const Center(child: Text('কোন পক্ষ পাওয়া যায়নি'));
      }
      return ListView.builder(
        itemCount: controller.parties.length,
        itemBuilder: (context, index) {
          final party = controller.parties[index];
          return ListTile(
            leading: party.photoUrl != null
                ? CircleAvatar(backgroundImage: NetworkImage(party.photoUrl!))
                : const CircleAvatar(child: Icon(Icons.person)),
            title: Text(party.name),
            subtitle: Text(party.phone),
          );
        },
      );
    });
  }
}
