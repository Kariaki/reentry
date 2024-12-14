import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reentry/core/extensions.dart';

import '../../../../core/theme/colors.dart';
import '../../../dialog/alert_dialog.dart';
import '../../report/report_user_form_screen.dart';
import '../components/chat_list_component.dart';
import '../entity/conversation_user_entity.dart';

class ChatOptionModal extends StatelessWidget {
  final ConversationComponent entity;
  final Function() onBlock;

  const ChatOptionModal(
      {super.key, required this.entity, required this.onBlock});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              context.popRoute();

              context.pushRoute(ReportUserFormScreen(
                  entity: ConversationUserEntity(
                      userId: entity.userId,
                      name: entity.name,
                      avatar: entity.avatar)));
            },
            child:
                _itemBuilder(textTheme, 'Report ${entity.name}', Icons.report),
          ),
          InkWell(
            onTap: () {
              context.popRoute();
              AppAlertDialog.show(context,
                  description:
                      "You are about to block ${entity.name}, do you want to proceed?",
                  title: "Block user?",
                  action: "Block", onClickAction: () {
                onBlock();
                //
                //block proceed
              });
              //show block user dialog
              // context.push(ReportUserFormScreen(
              //     entity: ConversationUserEntity(
              //         userId: entity.userId,
              //         name: entity.name,
              //         avatar: entity.avatar)));
            },
            child: _itemBuilder(textTheme, 'Block ${entity.name}', Icons.block,
                iconColor: Colors.red.shade100),
          ),
        ],
      ),
    );
  }

  Widget _itemBuilder(TextTheme textTheme, String text, IconData icon,
      {Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? AppColors.white,
          ),
          10.width,
          Text(
            text,
            style: textTheme.bodySmall
                ?.copyWith(color: AppColors.white, fontSize: 16),
          )
        ],
      ),
    );
  }
}
