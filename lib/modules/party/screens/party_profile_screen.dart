import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/party.dart';
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
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                if (ActivationGuard.check()) {
                  Get.to(() => EditPartyScreen(party: party));
                }
              } else if (value == 'delete') {
                if (ActivationGuard.check()) {
                  controller.deleteParty();
                }
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('এডিট')),
              PopupMenuItem(value: 'delete', child: Text('ডিলিট')),
            ],
          ),
        ],
      ),
      body: Obx(() {
        final theme = Theme.of(context);
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header card with avatar and name
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.15),
                          theme.colorScheme.primary.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundImage: (party.photoUrl != null &&
                                  party.photoUrl!.isNotEmpty)
                              ? NetworkImage(party.photoUrl!)
                              : null,
                          child: (party.photoUrl == null ||
                                  party.photoUrl!.isEmpty)
                              ? const Icon(Icons.person, size: 48)
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          party.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.phone_iphone, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              party.phone,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Details card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person_outline, size: 20),
                              const SizedBox(width: 8),
                              Expanded(child: appInfoRow('নাম', party.name)),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            children: [
                              const Icon(Icons.call_outlined, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: appInfoRow('মোবাইল', party.phone)),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on_outlined, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                  child: appInfoRow('ঠিকানা', party.address)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0.5,
                    child: Obx(() => SwitchListTile(
                          title: const Text('এসএমএস নোটিফায়ার'),
                          value: controller.isSendSms.value,
                          onChanged: controller.updateSms,
                        )),
                  ),
                ],
              ),
            ),
            if (controller.isDeleting.value || controller.isUpdatingSms.value)
              const Center(child: CircularProgressIndicator()),
          ],
        );
      }),
    );
  }
}
