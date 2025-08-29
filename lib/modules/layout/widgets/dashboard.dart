import 'package:flutter/material.dart';
import 'accounts_first_card.dart';
import 'app_text.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 116,
          child: AccountsFirstCard(),
        ),
        AppText(),
      ],
    );
  }
}
