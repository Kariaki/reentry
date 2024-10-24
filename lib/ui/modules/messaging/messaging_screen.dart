import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';

class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () => context.pop(),
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.white,
            ),
          ),
          title: Row(
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(''),
                ),
              ),
              10.width,
              Text(
                'Ebilate',
                style: context.textTheme.bodyLarge,
              )
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container();
                    })),
            5.height,
            TextField(
              style: context.textTheme.bodyLarge?.copyWith(),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                  hintText: 'Type a message',
                  enabledBorder: buildOutlineInputBorder(),

                  focusedBorder: buildOutlineInputBorder()),
            ),
            10.height
          ],
        ));
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.gray2),
        borderRadius: BorderRadius.circular(50));
  }
  
}
