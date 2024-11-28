// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/client_dto.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/citizens/component/profile_card.dart';
import 'package:reentry/ui/modules/messaging/web/components/chat_card.dart';

class WebChatPage extends StatefulWidget {
  final UserDto currentUser;
  final ClientDto chatPartner;
  const WebChatPage({
    super.key,
    required this.currentUser,
    required this.chatPartner,
  });

  @override
  _WebChatPageState createState() => _WebChatPageState();
}

class _WebChatPageState extends State<WebChatPage> {
  final TextEditingController _searchController = TextEditingController();
  late final UserDto currentUser;
  late final ClientDto chatPartner;

  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    currentUser = UserDto(
      userId: '1',
      accountType: AccountType.mentor,
      name: 'Phoenix Baker',
      avatar: 'https://www.example.com/path/to/phoenix_baker.jpg',
    );
    chatPartner = ClientDto(
        id: '1',
        name: 'Phoenix Baker',
        avatar: 'https://www.example.com/path/to/phoenix_baker.jpg',
        status: ClientStatus.active,
        createdAt:
            DateTime.now().subtract(Duration(days: 30)).millisecondsSinceEpoch,
        updatedAt: DateTime.now().millisecondsSinceEpoch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.greyWhite,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                InputField(
                  controller: _searchController,
                  hint: 'Enter name, email or code to search',
                  radius: 10.0,
                  preffixIcon: SvgPicture.asset(Assets.search),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CustomIconButton(
                  backgroundColor: AppColors.greyDark,
                  textColor: AppColors.white,
                  label: "@ All Citizens",
                  borderColor: AppColors.white,
                  onPressed: () {}),
            ),
            const SizedBox(height: 60),
            _buildProfileCard(appointmentCount: 0, 24),
            const SizedBox(height: 60),
            SizedBox(
              height: 400,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.hintColor,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ChatScreen(
                    currentUser: widget.currentUser,
                    chatPartner: widget.chatPartner,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(int? careTeam, {int? appointmentCount}) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 250,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 168,
            child: ProfileCard(
              name: "client.name",
              email: "client.email",
              imageUrl: Assets.citiImg,
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
                        const SizedBox(height: 53),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Citizen",
                                style: context.textTheme.bodyLarge?.copyWith(
                                  color: AppColors.greyWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 36,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "Active since ",
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            // Text(
                            //   client.createdAt != null
                            //       ? DateFormat('dd MMM yyyy, hh:mm a').format(
                            //           DateTime.fromMillisecondsSinceEpoch(
                            //               client.createdAt),
                            //         )
                            //       : 'Unknown Date',
                            //   style: context.textTheme.bodySmall?.copyWith(
                            //     color: AppColors.white,
                            //     fontSize: 14,
                            //     fontWeight: FontWeight.w400,
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 60),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Appointments: ",
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColors.greyWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            // if (appointmentCount == null)
                            //   const SizedBox(
                            //     height: 16,
                            //     width: 16,
                            //     child: CircularProgressIndicator(
                            //       strokeWidth: 2,
                            //       color: AppColors.primary,
                            //     ),
                            //   )
                            // else
                            Text(
                              appointmentCount.toString(),
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColors.greyWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 30),
                            Text(
                              "Care team: ",
                              style: context.textTheme.bodySmall?.copyWith(
                                color: AppColors.greyWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              careTeam.toString(),
                              style: context.textTheme.bodySmall?.copyWith(
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
    );
  }
}
