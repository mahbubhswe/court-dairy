import 'package:courtdiary/constants/app_collections.dart';
import 'package:courtdiary/services/firebase_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../models/case.dart';
import 'dart:async'; // For stream subscription handling

class CaseViewController extends GetxController {
  RxList<Case> caseList = <Case>[].obs;
  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxString searchQuery = ''.obs;
  StreamSubscription? caseStreamSubscription;

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
        collectionName: AppCollections.CASES,
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

          // Separate today's cases and future cases
          final todayCases = <Case>[];
          final futureCases = <Case>[];

          caseList.value = documents.map((doc) {
            Case singleCase = Case.fromMap(
                doc); // doc is already of type Map<String, dynamic>
            singleCase.setDynamicField(key: 'id', value: doc['id']);

            // Convert Timestamp to DateTime
            DateTime today = DateTime.now();
            DateTime caseNextDate = (singleCase.nextDate)
                .toDate(); // Convert Timestamp to DateTime

            // Check if the case's nextDate is today or in the future
            if (caseNextDate.year == today.year &&
                caseNextDate.month == today.month &&
                caseNextDate.day == today.day) {
              // It's today's case
              todayCases.add(singleCase);
            } else if (caseNextDate.isAfter(today)) {
              // It's a case for the future (next date)
              futureCases.add(singleCase);
            }

            return singleCase;
          }).toList();

          // Combine the cases: today cases first, then future cases
          caseList.value = [...todayCases, ...futureCases];
        } else {
          caseList.value = [];
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
