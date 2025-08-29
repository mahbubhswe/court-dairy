import 'package:flutter/material.dart';

class DashboardItem extends StatelessWidget {
  final String title;
  final int count;

  const DashboardItem({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 2,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .color, // Dynamic text color
                ),
              ),
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: count), // Count up to endValue
                duration: const Duration(seconds: 1),
                builder: (context, value, child) {
                  return Text(
                    value.toString(),
                    style: TextStyle(
                        fontSize: 16, color: Colors.teal // Use primary color
                        ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
