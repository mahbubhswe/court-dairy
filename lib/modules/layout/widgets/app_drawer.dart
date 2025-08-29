// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:intl/intl.dart'; // For formatting DateTime

class AppDrawer extends StatelessWidget {
  final AsyncSnapshot<Map<String, dynamic>> documentSnapshot;
  const AppDrawer({required this.documentSnapshot, super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    UserMetadata? userMetadata = firebaseAuth.currentUser?.metadata;

    return Drawer(
      width: Get.width,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Accounts & Profile'),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(CupertinoIcons.back), // iOS-style back icon
          ),
          actions: [
            IconButton(
              onPressed: () => PanaraConfirmDialog.show(
                context,
                message: 'অ্যাপ থেকে লগ আউট করবেন',
                title: 'আপনি নিশ্চিত?',
                panaraDialogType: PanaraDialogType.custom,
                onTapCancel: () => Get.back(),
                onTapConfirm: () async {
                  Get.back();
                  await firebaseAuth.signOut();
                },
                confirmButtonText: 'হ্যাঁ',
                cancelButtonText: 'বাতিল',
              ),
              icon: const Icon(Icons.logout_sharp), // Rounded logout icon
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          firebaseAuth.currentUser!.photoURL.toString()),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      firebaseAuth.currentUser!.displayName.toString(),
                      textScaler: const TextScaler.linear(1.5),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      firebaseAuth.currentUser!.email.toString(),
                      textScaler: const TextScaler.linear(1.3),
                    ),
                    const SizedBox(height: 5),
                    OutlinedButton(
                      onPressed: () {
                        Get.snackbar('Sorry', 'Under Development');
                      },
                      child: const Text('Update Profile'),
                    )
                  ],
                ),
              ),
              _sectionTitle('Profile'),
              _profileCard(documentSnapshot),
              _sectionTitle('Account'),
              _accountCard(documentSnapshot, userMetadata!.creationTime!,
                  userMetadata.lastSignInTime!),
              _sectionTitle('Reset and Data Backup'),
              _resetCard(),
              const SizedBox(height: 25),
              const Text('Powered by App Seba - Your Trusted Friend'),
              const Text('Software Company',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 25),
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

  Widget _profileCard(AsyncSnapshot<Map<String, dynamic>> documentSnapshot) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      elevation: 0,
      child: Column(
        children: [
          _buildListTile(
            HugeIcons.strokeRoundedNote05,
            documentSnapshot.data!['lawyerName'] ?? 'N/A',
            'Lawyer Name',
          ),
          _buildListTile(
            HugeIcons.strokeRoundedCall02,
            documentSnapshot.data!['phone'] ?? 'N/A',
            'Contact Number',
          ),
          _buildListTile(
            HugeIcons.strokeRoundedAddressBook,
            documentSnapshot.data!['district'] ?? 'N/A',
            'District',
          ),
        ],
      ),
    );
  }

  Widget _accountCard(AsyncSnapshot<Map<String, dynamic>> documentSnapshot,
      DateTime creationTimeText, DateTime lastSignInTimeText) {
    final subStart = (documentSnapshot.data!['subStart'] as Timestamp).toDate();
    final subEnd = subStart.add(
      Duration(days: documentSnapshot.data!['subFor']),
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      elevation: 0,
      child: Column(
        children: [
          _buildListTile(
            HugeIcons.strokeRoundedCalendar03,
            DateFormat('yyyy-MM-dd').format(subStart),
            'Subcription Start Date',
          ),
          _buildListTile(
            HugeIcons.strokeRoundedCalendar03,
            DateFormat('yyyy-MM-dd').format(subEnd),
            'Subcription End Date',
          ),
          _buildListTile(
            HugeIcons.strokeRoundedTime01,
            DateFormat('yyyy-MM-dd HH:mm').format(creationTimeText),
            'Acount Created',
          ),
          _buildListTile(
            HugeIcons.strokeRoundedTime01,
            DateFormat('yyyy-MM-dd HH:mm').format(lastSignInTimeText),
            'Last Sign In',
          ),
        ],
      ),
    );
  }

  Widget _resetCard() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      elevation: 0,
      child: Column(
        children: [
          ListTile(
            leading: _roundedIcon(HugeIcons.strokeRoundedSetup02),
            title: const Text('Account Reset'),
            subtitle: const Text('Reset Your Account'),
            trailing: IconButton(
              onPressed: () {
                Get.snackbar('Sorry', 'Under Development');
              },
              icon: const Icon(CupertinoIcons.forward),
            ),
          ),
          ListTile(
            leading: _roundedIcon(HugeIcons.strokeRoundedCloud),
            title: const Text('Data Backup'),
            subtitle: const Text('Google Cloud(Auto Backup System)'),
            trailing: const CupertinoActivityIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData iconData, String title, String subtitle) {
    return ListTile(
      leading: _roundedIcon(iconData),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget _roundedIcon(IconData iconData) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Icon(iconData),
    );
  }
}
