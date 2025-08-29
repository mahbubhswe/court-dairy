import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import '../../../models/case.dart';
import '../controllers/case_tile_controller.dart';
import '../views/case_details_view.dart';
import 'payment_dailog.dart';

class CaseTile extends StatelessWidget {
  final Case singleCase;

  const CaseTile({super.key, required this.singleCase});

  @override
  Widget build(BuildContext context) {
    CaseTileController caseTileController = Get.put(CaseTileController());
    RxBool isShow = true.obs;
    return Column(
      children: [
        Card(
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  isShow.value = !isShow.value;
                },
                contentPadding: EdgeInsets.only(left: 14),
                leading: Icon(
                  HugeIcons.strokeRoundedFile02,
                  size: 35,
                ),
                title: Text(
                    '${singleCase.partyName}(${singleCase.partyType})'), // Display case number
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(singleCase.caseName),
                    Text(singleCase.courtName),
                  ],
                ),
                trailing: Tooltip(
                  message: 'Check Case Details',
                  child: IconButton(
                    onPressed: () {
                      Get.to(
                        () => CaseDetailsView(
                          singleCase: singleCase,
                        ),
                      );
                    },
                    icon: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
              Obx(
                () => Visibility(
                    visible: isShow.value,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          '${DateFormat('d, MMM yyyy').format(singleCase.nextDate.toDate()) == DateFormat('d, MMM yyyy').format(DateTime.now()) ? "Today's" : 'Next Date'}: ${DateFormat('d, MMM yyyy').format(singleCase.nextDate.toDate())}',
                          style: TextStyle(
                            color: DateFormat('d, MMM yyyy')
                                        .format(singleCase.nextDate.toDate()) ==
                                    DateFormat('d, MMM yyyy')
                                        .format(DateTime.now())
                                ? Colors.teal
                                : null,
                          ),
                        ),
                        Tooltip(
                          message: 'Update the Next Hearing Date',
                          child: IconButton(
                            onPressed: () {
                              PanaraConfirmDialog.show(
                                context,
                                title: "Are You Sure?",
                                message: "Want to update next hearing date",
                                confirmButtonText: "Yes",
                                cancelButtonText: "Cancel",
                                onTapCancel: () {
                                  Navigator.pop(context);
                                },
                                onTapConfirm: () {
                                  Navigator.pop(context);
                                  caseTileController.upateNextHearingDate(
                                      context: context,
                                      timestamp: singleCase.nextDate,
                                      id: singleCase.getDynamicField(
                                          key: 'id'));
                                },
                                panaraDialogType: PanaraDialogType.normal,
                                barrierDismissible:
                                    false, // optional parameter (default is true)
                              );
                            },
                            icon: Icon(
                              HugeIcons.strokeRoundedCalendar03,
                            ),
                          ),
                        ),
                        Tooltip(
                          message: 'Update the Notification Status',
                          child: IconButton(
                            onPressed: () {
                              PanaraConfirmDialog.show(
                                context,
                                title:
                                    'নটিফিকেশন ${singleCase.isNotify ? "বন্ধ" : "চালু"} করতে চান?',
                                message:
                                    "${singleCase.isNotify ? "বন্ধ" : "চালু"} করে রাখলে তারিখের আগের রাতে আপনি নটিফিকেশন ${singleCase.isNotify ? "পাবেন না" : "পাবেন"}।",
                                confirmButtonText: "Yes",
                                cancelButtonText: "Cancel",
                                onTapCancel: () {
                                  Navigator.pop(context);
                                },
                                onTapConfirm: () {
                                  caseTileController.upateIsNotify(
                                      context: context,
                                      isNotify: singleCase.isNotify,
                                      id: singleCase.getDynamicField(key: 'id'),
                                      plaintiffName: singleCase.plaintiffName,
                                      caseName: singleCase.caseName,
                                      timestamp: singleCase.nextDate,
                                      notificationId:
                                          singleCase.notificationId);
                                  Navigator.pop(context);
                                },
                                panaraDialogType: PanaraDialogType.normal,
                                barrierDismissible:
                                    false, // optional parameter (default is true)
                              );
                            },
                            icon: Icon(HugeIcons.strokeRoundedNotification02,
                                color: singleCase.isNotify
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ),
                        Tooltip(
                          message: 'Update the SMS Status',
                          child: IconButton(
                            onPressed: () {
                              PanaraConfirmDialog.show(
                                context,
                                title:
                                    "SMS ${singleCase.isSendSms ? "বন্ধ" : "চালু"} করতে চান?",
                                message:
                                    "${singleCase.isSendSms ? "বন্ধ" : "চালু"} করে রাখলে তারিখের আগের রাতে আপনার পার্টির ফোনে অটোমেটিক SMS ${singleCase.isSendSms ? "যাবেনা" : "যাবে"}।",
                                confirmButtonText: "Yes",
                                cancelButtonText: "Cancel",
                                onTapCancel: () {
                                  Navigator.pop(context);
                                },
                                onTapConfirm: () {
                                  caseTileController.upateIsSendSms(
                                      context: context,
                                      isSendSms: singleCase.isSendSms,
                                      id: singleCase.getDynamicField(
                                          key: 'id'));
                                  Navigator.pop(context);
                                },
                                panaraDialogType: PanaraDialogType.normal,
                                barrierDismissible:
                                    false, // optional parameter (default is true)
                              );
                            },
                            icon: Icon(HugeIcons.strokeRoundedMailSend02,
                                color: singleCase.isSendSms
                                    ? Colors.green
                                    : Colors.red),
                          ),
                        ),
                        Tooltip(
                          message: 'Collect Payment From this Party',
                          child: IconButton(
                            onPressed: () {
                              showAmountInputDialog(
                                  context: context,
                                  id: singleCase.getDynamicField(key: 'id'),
                                  name: singleCase.partyName);
                            },
                            icon: Icon(Icons.payment),
                          ),
                        ),
                      ],
                    )),
              ), // Optional icon for navigation or actions
            ],
          ),
        ),
      ],
    );
  }
}
