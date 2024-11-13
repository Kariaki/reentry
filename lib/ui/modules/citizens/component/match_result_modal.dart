import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';

class MatchResultModal extends StatelessWidget {
  final bool isSuccess;
  final String title;
  final String message;
  final String quoteAuthor;
  final IconData icon;

  const MatchResultModal({
    super.key,
    required this.isSuccess,
    required this.title,
    required this.message,
    required this.quoteAuthor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.black,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSuccess ? AppColors.green : AppColors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: context.textTheme.bodyLarge?.copyWith(
                color: isSuccess ? AppColors.green : AppColors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: context.textTheme.bodyLarge?.copyWith(
                color: AppColors.gray2,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSuccess) const SizedBox(height: 5),
            if (isSuccess)
              Text(
                quoteAuthor,
                style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 20),
            Container(
              height: 26,
              decoration: BoxDecoration(
                gradient: isSuccess
                    ? const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF22C55E),
                          Color(0xFF33D69F),
                          Color(0xFF3AE6BD),
                          Color(0xFF92FAE5),
                          Color(0xFFDFFEF8),
                        ],
                      )
                    : const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFFB1E1E),
                          Color(0xFFFF4C61),
                          Color(0xFFFCA08B),
                          Color(0xFFFED9D1),
                          Color(0xFFFFD1D1),
                        ],
                      ),
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
