import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:courtdiary/constants/app_collections.dart';
import 'package:courtdiary/models/case.dart';
import 'package:courtdiary/modules/cases/widgets/payment_tile.dart';
import 'package:courtdiary/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import '../../../models/payment.dart';

class CaseDetailsView extends StatelessWidget {
  final Case singleCase;

  const CaseDetailsView({super.key, required this.singleCase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          singleCase.caseName,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        actions: [
          Tooltip(
            message: 'Delete this Case',
            child: IconButton(
                onPressed: () {
                  PanaraConfirmDialog.show(
                    context,
                    title: "Are You Sure?",
                    message: "Do you want to delete this case?",
                    confirmButtonText: "Confirm",
                    cancelButtonText: "Cancel",
                    onTapCancel: () {
                      Navigator.pop(context);
                    },
                    onTapConfirm: () async {
                      Get.back();
                      Get.back();
                      await deleteDocument(
                          collectionName: AppCollections.CASES,
                          id: singleCase.getDynamicField(key: 'id'));
                    },
                    panaraDialogType: PanaraDialogType.normal,
                    barrierDismissible:
                        false, // optional parameter (default is true)
                  );
                },
                icon: Icon(HugeIcons.strokeRoundedDelete03)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              Image.asset(
                'assets/images/logo.png',
                height: 110,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                singleCase.partyName,
                textScaler: TextScaler.linear(1.5),
              ),
              Text(
                singleCase.caseName,
                textScaler: TextScaler.linear(1.2),
              ),
              const SizedBox(
                height: 15,
              ),
              _sectionTitle('Party Information'),
              Card(
                  child: Column(
                children: [
                  _buildListTile(
                    HugeIcons.strokeRoundedUserAccount,
                    'Party Name',
                    singleCase.partyName,
                  ),
                  Divider(),
                  _buildListTile(
                    HugeIcons.strokeRoundedCall02,
                    'Party Contact Number',
                    '+88${singleCase.partyNumber}',
                  ),
                  Divider(),
                  _buildListTile(
                    HugeIcons.strokeRoundedUserAccount,
                    'Party Type',
                    singleCase.partyType,
                  ),
                  Divider(),
                  _buildListTile(
                    HugeIcons.strokeRoundedUserAccount,
                    'Plaintiff Name',
                    singleCase.plaintiffName,
                  ),
                  Divider(),
                  _buildListTile(
                    HugeIcons.strokeRoundedUserAccount,
                    'Defendant Name',
                    singleCase.defendantName,
                  ),
                ],
              )),
              const SizedBox(
                height: 15,
              ),
              _sectionTitle('Case Information'),
              Card(
                child: Column(
                  children: [
                    _buildListTile(
                      HugeIcons.strokeRoundedLayersLogo,
                      'Case Title',
                      singleCase.caseName,
                    ),
                    Divider(),
                    _buildListTile(
                      HugeIcons.strokeRoundedTextNumberSign,
                      'Case Number',
                      singleCase.caseNumber,
                    ),
                    Divider(),
                    _buildListTile(
                      HugeIcons.strokeRoundedCourtLaw,
                      'Case Under Section',
                      singleCase.underSection,
                    ),
                    Divider(),
                    _buildListTile(
                      HugeIcons.strokeRoundedCourtHouse,
                      'Court Name',
                      singleCase.courtName,
                    ),
                    Divider(),
                    _buildListTile(
                      HugeIcons.strokeRoundedUserStatus,
                      'Case Status',
                      singleCase.caseStatus,
                    ),
                    Divider(),
                    _buildListTile(
                      HugeIcons.strokeRoundedInformationCircle,
                      'Case Outcome',
                      singleCase.caseOutcome,
                    ),
                    Divider(),
                    _buildListTile(
                      HugeIcons.strokeRoundedImportantBook,
                      'Case Priority',
                      singleCase.casePriority,
                    ),
                    Divider(),
                    _buildListTile(
                      HugeIcons.strokeRoundedCalendar03,
                      'Next Hearing Date',
                      _formatDate(singleCase.nextDate),
                    ),
                    Divider(),
                    _buildListTile(
                      HugeIcons.strokeRoundedAuction,
                      'Next Hearing Action',
                      singleCase.nextAction,
                    ),
                    Divider(),
                    _buildListTile(
                      HugeIcons.strokeRoundedCalendar03,
                      'Previous Hearing Date',
                      _formatDate(singleCase.previousDate),
                    ),
                    Divider(),
                    _buildListTile(
                      HugeIcons.strokeRoundedAuction,
                      'Previous Hearing Action',
                      singleCase.previousAction,
                    ),
                    Divider(),
                    _buildListTile(
                      HugeIcons.strokeRoundedCalendar03,
                      'Case Registred',
                      _formatDate(singleCase.createdAt),
                    ),
                  ],
                ),
              ),
              _buildPayments(singleCase.payments),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          title,
          textScaler: const TextScaler.linear(1.5),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildListTile(IconData iconData, String title, String subtitle) {
    return ListTile(
      leading: _roundedIcon(iconData),
      title: Text(
        title,
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
            color: subtitle == 'Active'
                ? Colors.green
                : subtitle == 'Pending'
                    ? Colors.amber
                    : null),
      ),
    );
  }

  Widget _roundedIcon(IconData iconData) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
      ),
    );
  }

  Widget _buildPayments(List<Payment> payments) {
    if (payments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Records:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          ...payments.map((payment) => _buildPaymentRow(payment)),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(Payment payment) {
    return PaymentTile(payment: payment);
  }

  String _formatDate(Timestamp timestamp) {
    return DateFormat('dd, MMMM yyyy').format(timestamp.toDate().toLocal());
  }
}
