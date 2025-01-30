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
      children: [
        Text(
          'Step ${_currentStep + 1} of 3',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: AppColors.greyWhite,
          ),
        ),
        SizedBox(height: 20),
        Expanded(
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
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        InputField(
            hint: "Who am I and why am I here?", controller: whoAmIController),
        InputField(
            hint: "What do I want to contribute to this world?",
            controller: contributionController),
        InputField(
            hint: "How do I want to grow?", controller: growthController),
        InputField(
            hint: "Where am I going? How do I want to be remembered?",
            controller: remembranceController),
        InputField(
            hint: "What would I want to experience in life?",
            controller: experienceController),
        InputField(
            hint: "If I achieved all of my life goals, how would I feel?",
            controller: lifeGoalsController),
        InputField(
            hint: "What is most important in my life?",
            controller: passionController),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        InputField(
            hint: "My life's mission statement", controller: missionController),
        InputField(hint: "My vision statement", controller: visionController),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      children: [
        InputField(hint: "Where I am now", controller: whereNowController),
        InputField(hint: "Where I am going", controller: whereGoingController),
        InputField(
            hint: "How I want to get there",
            controller: howToGetThereController),
      ],
    );
  }
}
