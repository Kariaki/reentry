import 'package:flutter/material.dart';

class DashboardPage  extends StatelessWidget {
  const DashboardPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Dashboard Page',
        style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 194, 31, 31)),
      ),
    );
  }
}
