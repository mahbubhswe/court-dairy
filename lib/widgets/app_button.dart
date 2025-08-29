// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

class AppButton extends StatelessWidget {
  final String title;
  final Function()? onTap;
  const AppButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SimpleShadow(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 70,
          decoration: BoxDecoration(
              color: const Color(0xFFCB2D3C),
              borderRadius: BorderRadius.circular(12)),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
