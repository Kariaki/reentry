import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/core/util/input_validators.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/citizens/bloc/citizen_profile_cubit.dart';
import 'package:reentry/ui/modules/citizens/component/selectable_pills.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import '../../components/input/input_field.dart';
import '../profile/bloc/profile_state.dart';

class MultiStepForm extends StatefulWidget {
  final String userId;
  final IntakeForm? form;

  const MultiStepForm({super.key, required this.userId, this.form});

  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController whoAmIController;

  late TextEditingController contributionController;

  late TextEditingController growthController;

  late TextEditingController remembranceController;

  late TextEditingController experienceController;
  late TextEditingController lifeGoalsController;
  late TextEditingController passionController;

  late TextEditingController missionController;

  late TextEditingController visionController;

  late TextEditingController whereNowController;
  late TextEditingController whereGoingController;

  late TextEditingController howToGetThereController;

  final GlobalKey<FormState> step1Form = GlobalKey<FormState>();
  final GlobalKey<FormState> step2Form = GlobalKey<FormState>();
  final GlobalKey<FormState> step3Form = GlobalKey<FormState>();
  IntakeForm form = IntakeForm();
  int _currentStep = 0;
  final Map<String, String> _formData = {};

  @override
  void initState() {
    super.initState();

    final intake = widget.form;
    whoAmIController = TextEditingController(text: intake?.whyAmIWhere);
    contributionController =
        TextEditingController(text: intake?.whatDoIWantToContribute);
    growthController = TextEditingController(text: intake?.howDoIWantToGrow);
    remembranceController = TextEditingController(text: intake?.whereAmIGoing);
    experienceController =
        TextEditingController(text: intake?.whatWouldIWantToExperienceInLife);
    lifeGoalsController =
        TextEditingController(text: intake?.ifIAchievedAllMyLifeGoals);
    passionController =
        TextEditingController(text: intake?.whatIsMostImportantInMyLife);
    missionController =
        TextEditingController(text: intake?.myLifesMissionStatement);
    visionController = TextEditingController(text: intake?.myVisionStatement);
    whereNowController = TextEditingController(text: intake?.whereAmINow);
    whereGoingController = TextEditingController(text: intake?.whereAmIGoing);
    howToGetThereController =
        TextEditingController(text: intake?.howDoIGetThere);
  }

  void _nextStep() {
    if (_currentStep == 0 && !step1Form.currentState!.validate()) {
      return;
    }
    if (_currentStep == 1 && !step2Form.currentState!.validate()) {
      return;
    }
    if (_currentStep == 2 && !step3Form.currentState!.validate()) {
      return;
    }

    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      _submitForm();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _submitForm() {
    context.read<ProfileCubit>().submitIntakeForm(widget.userId, form);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(builder: (context, state) {
      return BaseScaffold(
          isLoading: state is ProfileLoading,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Step ${_currentStep + 1} of 3',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyWhite,
                    ),
                  ),
                ),
                20.height,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: _formKey,
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildStep1(),
                          _buildStep2(),
                          _buildStep3(),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    if (_currentStep > 0)
                      ElevatedButton(
                        onPressed: _previousStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.greyWhite,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12), // Small button
                        ),
                        child: Text("Back"),
                      ),
                    20.width, // Space between buttons
                    if (_currentStep == 2 && widget.form != null)
                      SizedBox()
                    else
                      Expanded(
                        child: PrimaryButton(
                          text: _currentStep == 2 ? "Verify" : "Next",
                          onPress: _nextStep,
                        ),
                      ),
                  ],
                ),
                20.height
              ],
            ),
          ));
    }, listener: (_, state) {
      if (state is IntakeFormSuccess) {
        context.showSnackbarSuccess('User verified');
        context.read<CitizenProfileCubit>().setCurrentUser(state.user);
        context.pop(state.user);
      }
      if (state is ProfileError) {
        context.showSnackbarError(state.message);
      }
    });
  }

  Widget _buildStep1() {
    return Form(
        key: step1Form,
        child: Scrollbar(child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Awareness and self discovery",
              textAlign: TextAlign.start,
              style: context.textTheme.bodySmall
                  ?.copyWith(color: const Color(0xFFF5F5F5), fontSize: 28),
            ),
            15.height,
            Text(
              "These questions help you stir the citizen to the right path for proper reintegration into society. You help build the future we all desire.",
              textAlign: TextAlign.start,
              style: context.textTheme.bodySmall
                  ?.copyWith(color: const Color(0xFF828282), fontSize: 14),
            ),
            40.height,
            InputField(
                radius: 8,
                label: "Who am I and why am I here?",
                enable: widget.form == null,
                lines: 4,
                validator: InputValidators.stringValidation,
                onChange: (value) {
                  setState(() {
                    form = form.copyWith(whyAmIWhere: value);
                  });
                },
                hint: "Enter your answer here...",
                controller: whoAmIController),
            20.height,
            InputField(
                radius: 8,
                enable: widget.form == null,
                validator: InputValidators.stringValidation,
                onChange: (value) {
                  setState(() {
                    form = form.copyWith(whatDoIWantToContribute: value);
                  });
                },
                lines: 4,
                label: "What do I want to contribute to this world?",
                hint: "Enter your answer here...",
                controller: contributionController),
            20.height,
            InputField(
                radius: 8,
                lines: 4,
                enable: widget.form == null,
                validator: InputValidators.stringValidation,
                onChange: (value) {
                  setState(() {
                    form = form.copyWith(howDoIWantToGrow: value);
                  });
                },
                hint: "Enter your answer here...",
                label: "How do I want to grow?",
                controller: growthController),
            20.height,
            InputField(
                radius: 8,
                lines: 4,
                enable: widget.form == null,
                validator: InputValidators.stringValidation,
                hint: "Enter your answer here...",
                onChange: (value) {
                  setState(() {
                    form = form.copyWith(whereAmIGoing: value);
                  });
                },
                label:
                "Where am I going? How do I want to be remembered when I am gone?",
                controller: remembranceController),
            20.height,
            InputField(
                radius: 8,
                enable: widget.form == null,
                lines: 4,
                validator: InputValidators.stringValidation,
                hint: "Enter your answer here...",
                onChange: (value) {
                  setState(() {
                    form = form.copyWith(
                        whatWouldIWantToExperienceInLife: value);
                  });
                },
                label:
                "What would I want to experience in life if time and money were not an issue?",
                controller: experienceController),
            20.height,
            InputField(
                radius: 8,
                enable: widget.form == null,
                lines: 4,
                validator: InputValidators.stringValidation,
                onChange: (value) {
                  setState(() {
                    form = form.copyWith(ifIAchievedAllMyLifeGoals: value);
                  });
                },
                hint: "Enter your answer here...",
                label:
                "If I achieved all of my life goals how would I feel? How can I feel that along the way ",
                controller: lifeGoalsController),
            20.height,
            InputField(
                validator: InputValidators.stringValidation,
                radius: 8,
                enable: widget.form == null,
                onChange: (value) {
                  setState(() {
                    form = form.copyWith(whatIsMostImportantInMyLife: value);
                  });
                },
                lines: 4,
                hint: "Enter your answer here...",
                label:
                "What is most important in my life? What do I value the most? What am I most passionate about?",
                controller: passionController),
          ],
        )));
  }

  Widget _buildStep2() {
    return Scrollbar(child: Form(
      key: step2Form,
      child: ListView(
        shrinkWrap: true,

        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          Text(
            "Mission and Vision Statement",
            textAlign: TextAlign.start,
            style: context.textTheme.bodySmall
                ?.copyWith(color: const Color(0xFFF5F5F5), fontSize: 28),
          ),
          15.height,
          Text(
            "Write down your vision for your life, how you want your life to look like? How do you want to contribute to this world? ",
            textAlign: TextAlign.start,
            style: context.textTheme.bodySmall
                ?.copyWith(color: const Color(0xFF828282), fontSize: 14),
          ),
          40.height,
          InputField(
              radius: 8,
              lines: 4,
              validator: InputValidators.stringValidation,
              enable: widget.form == null,
              hint: "Enter your answer here...",
              label: "My life's mission statement",
              onChange: (value) {
                setState(() {
                  form = form.copyWith(myLifesMissionStatement: value);
                });
              },
              controller: missionController),
          15.height,

          InputField(
              radius: 8,
              lines: 4,
              enable: widget.form == null,
              validator: InputValidators.stringValidation,
              onChange: (value) {
                setState(() {
                  form = form.copyWith(myVisionStatement: value);
                });
              },
              hint: "Enter your answer here...",
              label: "My vision statement",
              controller: visionController),
        ],
      ),
    ));
  }

  Widget answeredText(String value) {
    return Text(value,
        style: const TextStyle(fontSize: 14, color: AppColors.hintColor));
  }

  Widget _buildStep3() {
    return Scrollbar(child: Form(
      key: step3Form,
      child: ListView(
        shrinkWrap: true,

        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          Text(
            "Goal setting",
            textAlign: TextAlign.start,
            style: context.textTheme.bodySmall
                ?.copyWith(color: const Color(0xFFF5F5F5), fontSize: 28),
          ),
          15.height,
          Text(
            "If there was no limit to what you could do/be/buy or become, what would you do in the next 20 to 50 years?. If you could not fail, what would you do?",
            textAlign: TextAlign.start,
            style: context.textTheme.bodySmall
                ?.copyWith(color: const Color(0xFF828282), fontSize: 14),
          ),
          15.height,
          Text(
            "Do not try to be realistic and do not set SMART (specific, measurable, achievable, realistic, time- based) goals. Instead set big goals and big visions for your life! List 50 top goals that you want to achieve in all areas of your life.",
            textAlign: TextAlign.start,
            style: context.textTheme.bodySmall
                ?.copyWith(color: const Color(0xFF828282), fontSize: 14),
          ),
          40.height,
          const SelectablePills(),
          40.height,
          InputField(
              radius: 8,
              lines: 4,
              enable: widget.form == null,
              validator: InputValidators.stringValidation,
              hint: "Enter your answer here...",
              onChange: (value) {
                setState(() {
                  form = form.copyWith(whereAmINow: value);
                });
              },
              label: "Where I am now",
              controller: whereNowController),
          15.height,

          InputField(
              validator: InputValidators.stringValidation,
              radius: 8,
              enable: widget.form == null,
              lines: 4,
              onChange: (value) {
                setState(() {
                  form = form.copyWith(whereAmIGoing: value);
                });
              },
              hint: "Enter your answer here...",
              label: "Where I am going",
              controller: whereGoingController),
          15.height,
          InputField(
              radius: 8,
              enable: widget.form == null,
              lines: 4,
              validator: InputValidators.stringValidation,
              hint: "Enter your answer here...",
              onChange: (value) {
                setState(() {
                  form = form.copyWith(howDoIGetThere: value);
                });
              },
              label: "How I want to get there",
              controller: howToGetThereController),
        ],
      ),
    ));
  }
}
