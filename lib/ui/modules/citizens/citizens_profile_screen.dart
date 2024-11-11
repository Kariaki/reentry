import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/citizens/component/profile_card.dart';

class CitizenProfileScreen extends StatefulWidget {
  const CitizenProfileScreen({super.key});

  @override
  _CitizenProfileScreenState createState() => _CitizenProfileScreenState();
}

class _CitizenProfileScreenState extends State<CitizenProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyDark,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          backgroundColor: AppColors.greyDark,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Search",
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.greyWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  hint: 'Enter name, email or code to search',
                  radius: 10.0,
                  preffixIcon: SvgPicture.asset(Assets.search),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 171,
                  child: CitizensProfileCard(
                    name: "Eduard Marco",
                    email: "Email@example.com",
                    phone: "2345786",
                    verified: true,
                    imageUrl: "assets/images/citiImg.png",
                    showActions: false,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 50),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Citizen",
                                        style: context.textTheme.bodyLarge
                                            ?.copyWith(
                                          color: AppColors.greyWhite,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 36,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Unverified",
                                        style: context.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppColors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                          decorationColor: AppColors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomIconButton(
                                        icon: Assets.delete,
                                        label: "Delete",
                                        onPressed: () {},
                                        backgroundColor: AppColors.greyDark,
                                        textColor: AppColors.white,
                                      ),
                                      const SizedBox(width: 10),
                                      CustomIconButton(
                                        icon: Assets.edit,
                                        label: "Edit",
                                        backgroundColor: AppColors.white,
                                        textColor: AppColors.black,
                                        onPressed: () {},
                                      ),
                                      const SizedBox(width: 10),
                                      CustomIconButton(
                                        icon: Assets.match,
                                        label: "Match",
                                        backgroundColor: AppColors.primary,
                                        textColor: AppColors.white,
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // Additional Info
                              Row(
                                children: [
                                  Text(
                                    "Active since ",
                                    style:
                                        context.textTheme.bodySmall?.copyWith(
                                      color: AppColors.green,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "21/10/2024",
                                    style:
                                        context.textTheme.bodySmall?.copyWith(
                                      color: AppColors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                               const SizedBox(height: 60),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Appointments: ",
                                    style:
                                        context.textTheme.bodySmall?.copyWith(
                                      color: AppColors.greyWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "465",
                                    style:
                                        context.textTheme.bodySmall?.copyWith(
                                      color: AppColors.greyWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(width: 30),
                                  Text(
                                    "Care team: ",
                                    style:
                                        context.textTheme.bodySmall?.copyWith(
                                      color: AppColors.greyWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "7",
                                    style:
                                        context.textTheme.bodySmall?.copyWith(
                                      color: AppColors.greyWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          color: AppColors.gray2,
                          thickness: 1,
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
