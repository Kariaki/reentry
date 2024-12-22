import 'package:flutter/material.dart';
import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';

class UserCard extends StatelessWidget {
  final String? name;
  final String? email;
  final String? phone;
  final bool? verified;
  final String? imageUrl;
  final bool? showActions;
  final VoidCallback? onViewProfile;
  final VoidCallback? onUnmatch;
  final bool isSelected;

  const UserCard({
    super.key,
    this.name,
    this.email,
    this.phone,
    this.verified,
    this.imageUrl,
    this.showActions = true,
    this.onViewProfile,
    this.onUnmatch,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(

      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppColors.gray2 : AppColors.gray2,
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
            Expanded(child:  ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(10.0)),
                child: Image.network(
                  imageUrl ?? AppConstants.avatar,
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _defaultImage(),
                ))),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name ?? "Unknown",
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.hintColor,
                          fontSize: screenWidth > 600 ? 14 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // Text(
                      //   verified == true ? "Verified" : "Unverified",
                      //   style: context.textTheme.bodySmall?.copyWith(
                      //     color: verified == true
                      //         ? AppColors.primary
                      //         : AppColors.red,
                      //     fontWeight: FontWeight.w600,
                      //     fontSize: screenWidth > 600 ? 10 : 8,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email ?? "No email provided",
                    style: context.textTheme.bodySmall?.copyWith(
                      color: AppColors.gray3,
                      fontSize: screenWidth > 600 ? 10 : 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (showActions!)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onViewProfile,
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
                                fontSize: 8,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: TextButton(
                            onPressed: onUnmatch,
                            child: Text(
                              "Unmatch",
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColors.greyWhite,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _defaultImage() {
    return Container(
      width: double.infinity,
      height: 150,
      color: AppColors.gray2,
      child: const Icon(
        Icons.person,
        size: 50,
        color: AppColors.white,
      ),
    );
  }
}
