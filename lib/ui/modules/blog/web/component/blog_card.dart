import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    return Container(

      decoration: ShapeDecoration(
          color: AppColors.greyDark,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      margin: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(10)),
            child:SizedBox(
              width: 150,
              height: 150,
              child:  Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_outward_sharp,
                          color: AppColors.white,
                          size: 20,
                        )
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
                    const SizedBox(height: 8),
                    Text(
                      '$author • ${formatDate(date)},',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
        ],
      ),
    );
  }
}

String formatDate(String? date) {
  if (date == null) return "N/A";
  final DateTime parsedDate = DateTime.parse(date);
  final DateFormat formatter = DateFormat('dd MMM yyyy');
  return formatter.format(parsedDate);
}
