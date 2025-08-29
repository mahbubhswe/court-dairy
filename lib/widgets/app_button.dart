import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

class AppButton extends StatelessWidget {
  final String label;
  final Function()? onPressed;

  const AppButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;

    return SimpleShadow(
      opacity: isEnabled ? 0.3 : 0, // shadow only if enabled
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: isEnabled ? const Color(0xFFCB2D3C) : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isEnabled ? Colors.white : Colors.white70,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
