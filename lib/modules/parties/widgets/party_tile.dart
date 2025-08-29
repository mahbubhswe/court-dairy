import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import '../../../constants/app_collections.dart';
import '../../../models/party.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/firebase_services.dart';

class PartyTile extends StatelessWidget {
  final Party party;
  const PartyTile({super.key, required this.party});
  Future<void> callToParty({required String phoneNumber}) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<void> callToWhatsApp({required String phoneNumber}) async {
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'api.whatsapp.com',
      path: 'send',
      queryParameters: {'phone': '+88$phoneNumber'},
    );
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  }

  Future<void> openSmsApp(
      {required String phoneNumber, String? message}) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: message != null ? {'body': message} : null,
    );

    try {
      await launchUrl(smsUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Could not launch SMS app: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onLongPress: () {
          PanaraConfirmDialog.show(
            context,
            title: "Are You Sure?",
            message: "Do you want to delete this party?",
            confirmButtonText: "Confirm",
            cancelButtonText: "Cancel",
            onTapCancel: () {
              Navigator.pop(context);
            },
            onTapConfirm: () async {
              Get.back();
              await deleteDocument(
                  collectionName: AppCollections.PARTIES,
                  id: party.getDynamicField(key: 'id'));
            },
            panaraDialogType: PanaraDialogType.normal,
            barrierDismissible: false, // optional parameter (default is true)
          );
        },
        contentPadding: EdgeInsets.only(left: 14),
        leading: Icon(
          HugeIcons.strokeRoundedUser,
          size: 35,
        ),
        title: Text(party.name),
        subtitle: Text(party.address),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  openSmsApp(phoneNumber: party.phone);
                },
                icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedMessenger,
                    color: Theme.of(context).colorScheme.onSurface)),
            IconButton(
                onPressed: () {
                  callToWhatsApp(phoneNumber: party.phone);
                },
                icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedWhatsapp,
                    color: Theme.of(context).colorScheme.onSurface)),
            IconButton(
                onPressed: () {
                  callToParty(phoneNumber: party.phone);
                },
                icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedCall02,
                    color: Theme.of(context).colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }
}
