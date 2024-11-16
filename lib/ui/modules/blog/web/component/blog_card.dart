import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';

class BlogCard extends StatelessWidget {
  final String author;
  final String date;
  final String title;
  final String description;
  final String link;
  final String imageUrl;

  const BlogCard({
    super.key,
    required this.author,
    required this.date,
    required this.title,
    required this.description,
    required this.link,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.gray1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              'https://images.unsplash.com/photo-1448227922836-6d05b3f8b663?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Zmx5aW5nJTIwYmlyZHxlbnwwfHwwfHx8MA%3D%3D',
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$author • $date',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const Icon(Icons.arrow_outward_sharp, color: AppColors.white, size: 20,)
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.gray2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
