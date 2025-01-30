import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import '../../components/input/input_field.dart';

class MultiStepForm extends StatefulWidget {
  const MultiStepForm({super.key});

  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController whoAmIController = TextEditingController();
  final TextEditingController contributionController = TextEditingController();
  final TextEditingController growthController = TextEditingController();
  final TextEditingController remembranceController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController lifeGoalsController = TextEditingController();
  final TextEditingController passionController = TextEditingController();
  final TextEditingController missionController = TextEditingController();
  final TextEditingController visionController = TextEditingController();
  final TextEditingController whereNowController = TextEditingController();
  final TextEditingController whereGoingController = TextEditingController();
  final TextEditingController howToGetThereController = TextEditingController();

  int _currentStep = 0;
  final Map<String, String> _formData = {};

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_currentStep < 2) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.ease);
      } else {
        _submitForm();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _submitForm() {
    print("Form Submitted: $_formData");
    context.showSnackbarSuccess("Form submitted successfully!");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                physics: const AlwaysScrollableScrollPhysics(),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentStep > 0)
              ElevatedButton(
                onPressed: _previousStep,
                child: Text("Back"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greyWhite),
              ),
            ElevatedButton(
              onPressed: _nextStep,
              child: Text(_currentStep == 2 ? "Submit" : "Next"),
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            ),
          ],
        ),
        20.height
      ],
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Awareness and self discovery",
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall
                ?.copyWith(color: const Color(0xFFF5F5F5), fontSize: 28),
          ),
          15.height,
          Text(
            "These questions help you stir the citizen to the right path for proper reintegration into society. You help build the future we all desire.",
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall
                ?.copyWith(color: const Color(0xFF828282), fontSize: 14),
          ),
          40.height,
          InputField(
              radius: 8,
              label: "Who am I and why am I here?",
              lines: 4,
              hint: "Enter your answer here...",
              controller: whoAmIController),
          20.height,
          InputField(
              radius: 8,
              lines: 4,
              label: "What do I want to contribute to this world?",
              hint: "Enter your answer here...",
              controller: contributionController),
          20.height,
          InputField(
              radius: 8,
              lines: 4,
              hint: "Enter your answer here...",
              label: "How do I want to grow?",
              controller: growthController),
          20.height,
          InputField(
              radius: 8,
              lines: 4,
              hint: "Enter your answer here...",
              label:
                  "Where am I going? How do I want to be remembered when I am gone?",
              controller: remembranceController),
          20.height,
          InputField(
              radius: 8,
              lines: 4,
              hint: "Enter your answer here...",
              label:
                  "What would I want to experience in life if time and money were not an issue?",
              controller: experienceController),
          20.height,
          InputField(
              radius: 8,
              lines: 4,
              hint: "Enter your answer here...",
              label:
                  "If I achieved all of my life goals how would I feel? How can I feel that along the way ",
              controller: lifeGoalsController),
          20.height,
          InputField(
              radius: 8,
              lines: 4,
              hint: "Enter your answer here...",
              label:
                  "What is most important in my life? What do I value the most? What am I most passionate about?",
              controller: passionController),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Mission and Vision Statement",
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall
              ?.copyWith(color: const Color(0xFFF5F5F5), fontSize: 28),
        ),
        15.height,
        Text(
          "Write down your vision for your life, how you want your life to look like? How do you want to contribute to this world? ",
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall
              ?.copyWith(color: const Color(0xFF828282), fontSize: 14),
        ),
        40.height,
        InputField(
            radius: 8,
            lines: 4,
            hint: "Enter your answer here...",
            label: "My life's mission statement",
            controller: missionController),
        InputField(
            radius: 8,
            lines: 4,
            hint: "Enter your answer here...",
            label: "My vision statement",
            controller: visionController),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Goal setting",
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall
              ?.copyWith(color: const Color(0xFFF5F5F5), fontSize: 28),
        ),
        15.height,
        Text(
          "If there was no limit to what you could do/be/buy or become, what would you do in the next 20 to 50 years?. If you could not fail, what would you do?",
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall
              ?.copyWith(color: const Color(0xFF828282), fontSize: 14),
        ),
        15.height,
        Text(
          "Do not try to be realistic and do not set SMART (specific, measurable, achievable, realistic, time- based) goals. Instead set big goals and big visions for your life! List 50 top goals that you want to achieve in all areas of your life.",
          textAlign: TextAlign.center,
          style: context.textTheme.bodySmall
              ?.copyWith(color: const Color(0xFF828282), fontSize: 14),
        ),
        40.height,
        InputField(
            radius: 8,
            lines: 4,
            hint: "Enter your answer here...",
            label: "Where I am now",
            controller: whereNowController),
        InputField(
            radius: 8,
            lines: 4,
            hint: "Enter your answer here...",
            label: "Where I am going",
            controller: whereGoingController),
        InputField(
            radius: 8,
            lines: 4,
            hint: "Enter your answer here...",
            label: "How I want to get there",
            controller: howToGetThereController),
      ],
    );
  }
}
