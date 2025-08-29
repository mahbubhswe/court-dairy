import 'package:courtdiary/modules/cases/views/add_case_view.dart';
import 'package:courtdiary/modules/parties/views/add_party_view.dart';
import 'package:flutter/material.dart';

class AddPartyCase extends StatelessWidget {
  const AddPartyCase({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Case/Party'),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Add Case"),
              Tab(text: "Add Party"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AddCaseView(), // First tab content
            AddPartyView(), // Second tab content
          ],
        ),
      ),
    );
  }
}
