import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';

class CreateGoalPage extends StatefulWidget {
  const CreateGoalPage({super.key});

  @override
  _CreateGoalPageState createState() => _CreateGoalPageState();
}

class _CreateGoalPageState extends State<CreateGoalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyDark,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: AppColors.greyDark,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Create new goal",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.greyWhite,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Goal",
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.greyWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              10.height,
              const InputField(
                hint: "Describe your goal...",
                radius: 5.0,
                lines: 6,
                maxLines: 10,
              ),
              40.height,
              Text(
                "Set duration",
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.greyWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              10.height,
              const InputField(
                hint: "6 October 2024 - 24 December 2024",
                radius: 5.0,
                suffixIcon: Icon(Icons.calendar_today_outlined),
              ),
              40.height,
              SizedBox(
                width: double.infinity,
                child: CustomIconButton(
                    backgroundColor: AppColors.white,
                    textColor: AppColors.black,
                    label: "Create a new goal",
                    onPressed: () {}),
              )
            ],
          ),
        ),
      ),
    );
  }
}
