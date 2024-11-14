import 'package:flutter/material.dart';

class BlogPage  extends StatelessWidget {
  const BlogPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Blog Page',
        style: TextStyle(fontSize: 24, color: Color.fromARGB(255, 194, 31, 31)),
      ),
    );
  }
}
