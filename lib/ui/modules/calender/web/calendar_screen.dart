import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Calendar Page',
        style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 194, 31, 31)),
      ),
    );
  }
}
