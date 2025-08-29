import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

import '../../../constants/app_collections.dart';
import '../../../models/cost.dart';
import '../../../services/firebase_services.dart';

class CostTile extends StatelessWidget {
  final Cost cost;
  const CostTile({super.key, required this.cost});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onLongPress: () {
          PanaraConfirmDialog.show(
            context,
            title: "Are You Sure?",
            message: "Do you want to delete this record?",
            confirmButtonText: "Confirm",
            cancelButtonText: "Cancel",
            onTapCancel: () {
              Navigator.pop(context);
            },
            onTapConfirm: () async {
              Get.back();
              await updateArrayField(
                  collectionName: AppCollections.LAWYERS,
                  id: FirebaseAuth.instance.currentUser!.uid,
                  field: 'costs',
                  value: cost.toMap(),
                  isAdd: false);
            },
            panaraDialogType: PanaraDialogType.normal,
            barrierDismissible: false, // optional parameter (default is true)
          );
        },
        leading: HugeIcon(
            icon: HugeIcons.strokeRoundedMoney04,
            color: Theme.of(context).colorScheme.onSurface),
        title: Text(cost.amount.toString()),
        subtitle: Text(cost.comment),
        trailing: Text(
          DateFormat('d, MMM yyyy').format(cost.timestamp.toDate()),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
