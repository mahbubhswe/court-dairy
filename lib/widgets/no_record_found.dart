import 'package:flutter/material.dart';

class NoRecordFound extends StatelessWidget {
  const NoRecordFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/folder.png',
          height: 100,
        ),
        Text(
          'Sorry, No Record Found!',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface),
        )
      ],
    );
  }
}
