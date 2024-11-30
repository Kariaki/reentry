import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/activity_dto.dart';
import 'package:reentry/ui/components/app_check_box.dart';
import 'package:reentry/ui/components/date_dialog.dart';
import 'package:reentry/ui/components/date_time_picker.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_bloc.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_cubit.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_event.dart';
import 'package:reentry/ui/modules/activities/bloc/activity_state.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';

class CreateAcitivityPage extends StatefulWidget {
  const CreateAcitivityPage({super.key});

  @override
  _CreateAcitivityPageState createState() => _CreateAcitivityPageState();
}

class _CreateAcitivityPageState extends State<CreateAcitivityPage> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _selectedDate;
  bool _isDaily = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCheckboxChanged(bool? value, bool isDaily) {
    setState(() {
      _isDaily = isDaily ? (value ?? false) : !(value ?? false);
    });
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
    return BlocConsumer<ActivityBloc, ActivityState>(
      listener: (_, state) {
        if (state is CreateActivityError) {
          context.showSnackbarError(state.message);
        }
        if (state is CreateActivitySuccess) {
          context.showSnackbarSuccess("New activity set");
          Beamer.of(context).beamToNamed('/activities');
          context.read<ActivityCubit>().fetchActivities();
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
                  InputField(
                    hint: "Describe your activity...",
                    radius: 5.0,
                    lines: 6,
                    maxLines: 10,
                    controller: _controller,
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
                  // BoxContainer(
                  //     radius: 10,
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         DateTimePicker(
                  //           hint: 'End date',
                  //           onTap: () => _onDateSelected(context),
                  //           title: _selectedDate?.formatDate(),
                  //         ),
                  //       ],
                  //     )),
                   DateTimePicker(
                            hint: 'End date',
                            onTap: () => _onDateSelected(context),
                            title: _selectedDate?.formatDate(),
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
                    children: [
                      appCheckBox(
                          !_isDaily, (val) => _onCheckboxChanged(val, false),
                          title: "Daily"),
                      const SizedBox(width: 20),
                      appCheckBox(
                          _isDaily, (val) => _onCheckboxChanged(val, true),
                          title: "Weekly"),
                    ],
                  ),

                  30.height,
                  SizedBox(
                    width: double.infinity,
                    child: CustomIconButton(
                      loading: state is ActivityLoading,
                      loaderColor: AppColors.white,
                      backgroundColor: AppColors.white,
                      textColor: AppColors.black,
                      label: "Create a new activity",
                      onPressed: () {
                        if (_controller.text.isEmpty) {
                          context.showSnackbarError(
                              "Please describe your activity.");
                          return;
                        }
                        if (_selectedDate == null) {
                          context
                              .showSnackbarError("Please select an end date.");
                          return;
                        }

                        final event = CreateActivityEvent(
                          title: _controller.text,
                          startDate: DateTime.now().millisecondsSinceEpoch,
                          endDate: _selectedDate!.millisecondsSinceEpoch,
                          frequency:
                              _isDaily ? Frequency.weekly : Frequency.daily,
                        );

                        context.read<ActivityBloc>().add(event);
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
