import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/routes/router.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/modules/appointment/web/appointment_screen.dart';

class ReportCard extends StatelessWidget {
  final String title;
  final String complainant;
  final String complaintDate;
  final String complaintAgainst;
  final String complaintAgainstRole;
  final String description;
  final VoidCallback? onClick;
  final bool preview;
  final int responses;

  const ReportCard({
    Key? key,
    required this.title,
    required this.complainant,
    required this.complaintDate,
     this.onClick,
    this.preview=true,
    required this.complaintAgainst,
    required this.complaintAgainstRole,
    required this.description,
    required this.responses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.greyDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  complainant,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                1.width,
                Text(
                  "• $complaintDate",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "Complaint against: ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  complaintAgainst,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  "• $complaintAgainstRole",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              maxLines: preview?4:null,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.hintColor,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {},
              child: Text(
                "$responses Responses",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.white,
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
