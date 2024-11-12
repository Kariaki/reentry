import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/citizens/component/profile_card.dart';

class OfficersProfileScreen extends StatefulWidget {
  final UserDto user;

  const OfficersProfileScreen({
    super.key,
    required this.user,
    // required this.profiles,
  });

  @override
  State<OfficersProfileScreen> createState() => _OfficersProfileScreenState();
}

class _OfficersProfileScreenState extends State<OfficersProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final mentors = widget.user.mentors;
    final officers = widget.user.officers;
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
                SizedBox(
                  width: 171,
                  child: ProfileCard(
                    name: widget.user.name,
                    email: widget.user.email,
                    // phone: "2345786",
                    // verified: true,
                    imageUrl: widget.user.avatar,
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
            Text("Peer mentors",
                style: context.textTheme.bodySmall!.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white)),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.8,
              ),
              itemCount: mentors.length,
              itemBuilder: (context, index) {
                final profile = mentors[index];
                return ProfileCard(
                  name: profile['name'],
                  email: profile['email'],
                  phone: profile['phone'],
                  verified: profile['verified'],
                  imageUrl: profile['imageUrl'],
                  showActions: true,
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text("Parole officer",
                style: context.textTheme.bodySmall!.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white)),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.8,
              ),
              itemCount: mentors.length,
              itemBuilder: (context, index) {
                final parole = officers[index];
                return ProfileCard(
                  name: parole['name'],
                  email: parole['email'],
                  phone: parole['phone'],
                  verified: parole['verified'],
                  imageUrl: parole['imageUrl'],
                  showActions: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
