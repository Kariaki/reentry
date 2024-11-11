import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';

class CitizensProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final bool verified;
  final String imageUrl;
  final bool showActions;

  const CitizensProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.verified,
    required this.imageUrl,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.gray2,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: AppColors.greyDark,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10.0)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.hintColor,
                          fontSize: screenWidth > 600 ? 14 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        verified ? "Verified" : "Unverified",
                        style: context.textTheme.bodySmall?.copyWith(
                          color: verified ? AppColors.primary : AppColors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: screenWidth > 600 ? 10 : 8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.gray3,
                      fontSize: screenWidth > 600 ? 10 : 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    phone,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.gray2,
                      fontSize: screenWidth > 600 ? 8 : 8,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12), 
                  if (showActions)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.greyDark,
                              foregroundColor: AppColors.greyDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                side: const BorderSide(
                                  color: AppColors.gray2,
                                  width: 1.0,
                                ),
                              ),
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                            ),
                            child: Text(
                              "View profile",
                              textAlign: TextAlign.center,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColors.greyWhite,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "unmatch",
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColors.greyWhite,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
