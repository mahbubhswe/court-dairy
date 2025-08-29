import 'package:courtdiary/widgets/no_record_found.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../models/case.dart'; // Import your Case model
import '../controllers/cases_view_controller.dart';
import 'package:courtdiary/modules/cases/widgets/case_tile.dart'; // Assuming you have this widget

class SearchView extends StatelessWidget {
  SearchView({super.key});

  final CaseViewController caseViewController = Get.put(CaseViewController());
  final box = GetStorage(); // Instance of GetStorage
  final String recentSearchesKey = 'recentSearches';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Go back to the previous screen
          },
        ),
        title: TextField(
          onChanged: (value) {
            caseViewController.searchQuery.value = value.trim();
          },
          decoration: InputDecoration(
            hintText: 'Search cases...',
            hintStyle: TextStyle(color: Colors.grey), // Hint text color
            prefixIcon: const Icon(Icons.search),
            suffixIcon: Obx(() {
              if (caseViewController.searchQuery.value.isEmpty) {
                return const SizedBox.shrink();
              } else {
                return IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    caseViewController.searchQuery.value = '';
                  },
                );
              }
            }),
            border: InputBorder.none,
            filled: true, // This makes the background color visible
            fillColor:
                Colors.white, // Set the background color here (e.g., white)
          ),
          style: TextStyle(color: Colors.black), // Text color set to black
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              _saveSearchQuery(query);
            }
          },
        ),
      ),
      body: Obx(() {
        String query = caseViewController.searchQuery.value.toLowerCase();

        if (query.isEmpty) {
          return _buildRecentSearches();
        } else {
          List<Case> filteredCases = caseViewController.caseList.where((c) {
            return c.caseName.toLowerCase().contains(query) ||
                c.partyName.toLowerCase().contains(query);
          }).toList();

          return _buildFilteredResults(filteredCases);
        }
      }),
    );
  }

  // Widget for recent searches
  Widget _buildRecentSearches() {
    // Safely read recent searches
    List<String> recentSearches =
        (box.read<List<dynamic>>(recentSearchesKey) ?? [])
            .map((e) => e.toString())
            .toList();

    return ListView(
      children: recentSearches
          .map((search) => ListTile(
                leading: const Icon(Icons.history),
                title: Text(search),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _removeRecentSearch(search);
                  },
                ),
                onTap: () {
                  caseViewController.searchQuery.value = search;
                },
              ))
          .toList(),
    );
  }

  // Widget for filtered results
  Widget _buildFilteredResults(List<Case> filteredCases) {
    if (caseViewController.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    } else if (caseViewController.isError.value) {
      return const Center(child: Text('An error occurred!'));
    } else if (filteredCases.isEmpty) {
      return Center(child: const NoRecordFound());
    } else {
      return ListView.builder(
        itemCount: filteredCases.length,
        itemBuilder: (context, index) {
          final caseData = filteredCases[index];
          return CaseTile(singleCase: caseData);
        },
      );
    }
  }

  // Save search query to recent searches
  void _saveSearchQuery(String query) {
    List<String> recentSearches =
        (box.read<List<dynamic>>(recentSearchesKey) ?? [])
            .map((e) => e.toString())
            .toList();

    if (!recentSearches.contains(query)) {
      recentSearches.insert(0, query); // Add at the top
      if (recentSearches.length > 10) {
        recentSearches =
            recentSearches.sublist(0, 10); // Limit to last 10 searches
      }
      box.write(recentSearchesKey, recentSearches);
    }
  }

  // Remove a search query from recent searches
  void _removeRecentSearch(String query) {
    List<String> recentSearches =
        (box.read<List<dynamic>>(recentSearchesKey) ?? [])
            .map((e) => e.toString())
            .toList();

    recentSearches.remove(query);
    box.write(recentSearchesKey, recentSearches);
  }
}
