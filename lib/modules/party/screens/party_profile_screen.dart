import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/party.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_info_row.dart';
import '../controllers/party_profile_controller.dart';
import 'edit_party_screen.dart';
import '../../../utils/activation_guard.dart';

class PartyProfileScreen extends StatelessWidget {
  final Party party;
  const PartyProfileScreen({super.key, required this.party});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PartyProfileController(party));
    return Scaffold(
      appBar: AppBar(
        title: const Text('পক্ষ প্রোফাইল'),
      ),
      body: Obx(() {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 16,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: party.photoUrl != null
                        ? NetworkImage(party.photoUrl!)
                        : null,
                    child: party.photoUrl == null
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                  appInfoRow('নাম', party.name),
                  appInfoRow('মোবাইল', party.phone),
                  appInfoRow('ঠিকানা', party.address),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'এডিট',
                          onPressed: () {
                            if (ActivationGuard.check()) {
                              Get.to(() => EditPartyScreen(party: party));
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: AppButton(
                          label: 'ডিলিট',
                          onPressed: controller.isDeleting.value
                              ? null
                              : () {
                                  if (ActivationGuard.check()) {
                                    controller.deleteParty();
                                  }
                                },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (controller.isDeleting.value)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      }),
    );
  }
}
