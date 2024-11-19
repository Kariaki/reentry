import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';

class BlogDetailsPage extends StatelessWidget {
 final Map<String, dynamic> blog;

  const BlogDetailsPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    print(blog);
    return Scaffold(
      backgroundColor: AppColors.greyDark,
      body: Column(
        children: [
          //  Image.network(blog['imageUrl'] ?? '', fit: BoxFit.cover),
          const SizedBox(height: 20),
          Text(
             blog['title'] ?? 'No Title',
            style: context.textTheme.bodyLarge?.copyWith(
                color: AppColors.greyWhite,
                fontWeight: FontWeight.w600,
                fontSize: 24),
          ),
          const SizedBox(height: 20),
          Text(
              blog['content'] ?? 'No Content',
            style: context.textTheme.bodyLarge?.copyWith(
                color: AppColors.greyWhite,
                fontWeight: FontWeight.w400,
                fontSize: 18),
          ),
        ],
      ),
    );
  }
}
