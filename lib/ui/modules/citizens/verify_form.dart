import 'package:flutter/material.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:flutter/services.dart';

class MultiStepForm extends StatefulWidget {
  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  PageController _pageController = PageController();
  int _currentStep = 1;

  void nextPage() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (_currentStep > 1) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentStep = index + 1;
            });
          },
          physics: NeverScrollableScrollPhysics(),
          children: [
            StepOne(nextPage: nextPage),
            StepTwo(nextPage: nextPage, previousPage: previousPage),
            StepThree(previousPage: previousPage),
          ],
        ),
      );
  }
}

class StepOne extends StatelessWidget {
  final VoidCallback nextPage;
  StepOne({required this.nextPage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Awareness and Self Discovery", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          InputField(hint: "Who am I and why am I here?"),
          InputField(hint: "What do I want to contribute to this world?"),
          InputField(hint: "How do I want to grow?"),
          InputField(hint: "Where am I going? How do I want to be remembered?"),
          Spacer(),
          ElevatedButton(onPressed: nextPage, child: Text("Next")),
        ],
      ),
    );
  }
}

class StepTwo extends StatelessWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  StepTwo({required this.nextPage, required this.previousPage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Mission and Vision Statement", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          InputField(hint: "My life's mission statement"),
          InputField(hint: "My vision statement"),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(onPressed: previousPage, child: Text("Previous")),
              ElevatedButton(onPressed: nextPage, child: Text("Next")),
            ],
          ),
        ],
      ),
    );
  }
}

class StepThree extends StatelessWidget {
  final VoidCallback previousPage;
  StepThree({required this.previousPage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Goal Setting", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          InputField(hint: "Where I am now"),
          InputField(hint: "Where I am going"),
          InputField(hint: "How I want to get there"),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(onPressed: previousPage, child: Text("Previous")),
              ElevatedButton(onPressed: () {}, child: Text("Verify")),
            ],
          ),
        ],
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  
  const InputField({super.key, required this.hint, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: hint,
          fillColor: AppColors.greyDark,
          filled: true,
        ),
      ),
    );
  }
}
