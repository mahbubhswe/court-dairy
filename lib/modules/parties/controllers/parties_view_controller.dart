import 'package:courtdiary/constants/app_collections.dart';
import 'package:courtdiary/models/party.dart';
import 'package:courtdiary/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:async'; // For stream subscription handling

class PartiesViewController extends GetxController {
  RxList<Party> partyList = <Party>[].obs;
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
    var searchQuery = ''.obs; // Reactive search query

  StreamSubscription?
      caseStreamSubscription; // To handle the stream subscription
  @override
  void onInit() {
    fetchCases();
    super.onInit();
  }

  // Fetch cases from Firestore using queryDocumentsStream
  void fetchCases() {
    try {
      isLoading.value = true;
      isError.value = false;

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        isError.value = true;
        isLoading.value = false;
        return; // User is not logged in, so we return early
      }
      // Stream for fetching documents based on conditions
      caseStreamSubscription = queryDocumentsStream(
        collectionName: AppCollections.PARTIES,
        fieldName: 'lawyerId',
        fieldValue: currentUser.uid,
      ).listen((documentData) {
        // Check for errors in the stream
        if (documentData.containsKey('error')) {
          isError.value = true;
          return;
        }

        // Extract cases list from the fetched documents
        if (documentData.containsKey('documents')) {
          final documents = documentData['documents'] as List;
          partyList.value = documents.map((doc) {
            return Party.fromMap(doc as Map<String, dynamic>);
          }).toList();
        } else {
          partyList.value = [];
        }
      });
    } catch (e) {
      isError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  // Clean up the stream subscription when the controller is disposed
  @override
  void onClose() {
    caseStreamSubscription?.cancel();
    super.onClose();
  }
}
