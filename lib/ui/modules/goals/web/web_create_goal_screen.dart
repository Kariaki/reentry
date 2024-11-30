import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/goal_dto.dart';
import 'package:reentry/ui/components/app_radio_button.dart';
import 'package:reentry/ui/components/date_dialog.dart';
import 'package:reentry/ui/components/date_time_picker.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_bloc.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_cubit.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_event.dart';
import 'package:reentry/ui/modules/goals/bloc/goals_state.dart';

class CreateGoalPage extends StatefulWidget {
  const CreateGoalPage({super.key});

  @override
  _CreateGoalPageState createState() => _CreateGoalPageState();
}

class _CreateGoalPageState extends State<CreateGoalPage> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedDuration;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDateSelected(BuildContext context) async {
    context.displayDialog(
      DateTimeDialog(
        onSelect: (result) {
          setState(() {
            _selectedDate = result;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoalsBloc, GoalAndActivityState>(
      listener: (_, state) {
        if (state is GoalError) {
          context.showSnackbarError(state.message);
        }
        if (state is CreateGoalSuccess) {
          context.showSnackbarSuccess("New goal set");
          Beamer.of(context).beamToNamed('/goals');
          context.read<GoalCubit>().fetchGoals();
        }
      },
      builder: (context, state) {
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
                  InputField(
                    hint: "Describe your goal...",
                    radius: 5.0,
                    lines: 6,
                    maxLines: 10,
                    controller: _controller,
                  ),
                  40.height,
                  // 10.height,
                  // Text(
                  //   "Set start date ",
                  //   style: context.textTheme.bodyMedium?.copyWith(
                  //     color: AppColors.greyWhite,
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  // ),
                  // 10.height,
                  // DateTimePicker(
                  //   hint: 'End date',
                  //   onTap: () => _onDateSelected(context),
                  //   title: _selectedDate?.formatDate(),
                  // ),
                  // 40.height,
                  Text(
                    "Set duration",
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.greyWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  10.height,
                  GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, mainAxisExtent: 40),
                    shrinkWrap: true,
                    children: GoalDto.durations.map((e) {
                      return AppRadioButton(
                        selected: _selectedDuration == e,
                        text: e,
                        onClick: () {
                          setState(() {
                            _selectedDuration = e; // Update selected duration
                          });
                        },
                      );
                    }).toList(),
                  ),
                  //  DateTimePicker(
                  //             hint: '6 October 2024',
                  //             onTap: () => _onDateSelected(context),
                  //             title: _selectedDate?.formatDate(),
                  //           ),
                  40.height,
                  SizedBox(
                    width: double.infinity,
                    child: CustomIconButton(
                        loading: state is GoalsLoading,
                      backgroundColor: AppColors.white,
                      textColor: AppColors.black,
                      label: "Create a new goal",
                      onPressed: () {
                        if (_controller.text.isEmpty) {
                          context
                              .showSnackbarError("Please describe your goal.");
                          return;
                        }
                        // if (_selectedDate == null) {
                        //   context
                        //       .showSnackbarError("Please select an end date.");
                        //   return;
                        // }
                        final event = CreateGoalEvent(
                            _controller.text,
                            DateTime.now().millisecondsSinceEpoch,
                            0,
                            _selectedDuration!);
                        context.read<GoalsBloc>().add(event);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
