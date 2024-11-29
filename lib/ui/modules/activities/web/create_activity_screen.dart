import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';

class CreateAcitivityPage extends StatefulWidget {
  const CreateAcitivityPage({super.key});

  @override
  _CreateAcitivityPageState createState() => _CreateAcitivityPageState();
}

class _CreateAcitivityPageState extends State<CreateAcitivityPage> {
  String selectedOption = '';

  void _onOptionSelected(String option) {
    setState(() {
      selectedOption = option;
    });
  }

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Activities",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.greyWhite,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                CustomIconButton(
                    backgroundColor: AppColors.greyDark,
                    textColor: AppColors.greyWhite,
                    label: "Daily affirmations",
                    borderColor: AppColors.greyWhite,
                    onPressed: () {})
              ],
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
                "Activity",
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.greyWhite,
                  fontWeight: FontWeight.w700,
                ),
              ),
              10.height,
              const InputField(
                hint: "Describe your activity...",
                radius: 5.0,
                lines: 6,
                maxLines: 10,
              ),
              40.height,
              Text(
                "Set start date ",
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
              Text(
                "Set tracking ",
                style: context.textTheme.bodyMedium?.copyWith(
                  color: AppColors.greyWhite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              10.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: selectedOption == 'Daily',
                        onChanged: (bool? value) {
                          _onOptionSelected('Daily');
                        },
                        activeColor: Colors.white,
                      ),
                      Text(
                        'Daily',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.greyWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: selectedOption == 'Weekly',
                        onChanged: (bool? value) {
                          _onOptionSelected('Weekly');
                        },
                        activeColor: Colors.white,
                      ),
                      Text(
                        'Weekly',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppColors.greyWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              30.height,
              SizedBox(
                width: double.infinity,
                child: CustomIconButton(
                    backgroundColor: AppColors.white,
                    textColor: AppColors.black,
                    label: "Create a new activity",
                    onPressed: () {}),
              )
            ],
          ),
        ),
      ),
    );
  }
}
