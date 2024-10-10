import 'package:flutter/material.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reentry/core/theme/icons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: AppColors.black,
        body: Center(  // Wrap the entire body in Center to center everything
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Vertically center content
            crossAxisAlignment: CrossAxisAlignment.center,  // Horizontally center content
            children: [
              Container(
                height: 75,
                width: 75,
                color: AppColors.gray2,
              ),
              SizedBox(height: 20),  // Spacing before Wrap
              Wrap(
                spacing: 20.0,  // Horizontal spacing between icons
                runSpacing: 20.0,  // Vertical spacing between rows
                alignment: WrapAlignment.center,  // Center icons horizontally
                children: [
                  SvgPicture.asset(AppIcons.apple, height: 50, width: 50),
                  SvgPicture.asset(AppIcons.activity, height: 50, width: 50),
                  SvgPicture.asset(AppIcons.addOutline, height: 50, width: 50),
                  SvgPicture.asset(AppIcons.bin, height: 50, width: 50),
                  SvgPicture.asset(AppIcons.chatBubble, height: 50, width: 50),
                  SvgPicture.asset(AppIcons.chevronLeft, height: 50, width: 50),
                  SvgPicture.asset(AppIcons.eyeHide, height: 50, width: 50),
                  SvgPicture.asset(AppIcons.greenCheck, height: 50, width: 50),
                  SvgPicture.asset(AppIcons.google, height: 50, width: 50),
                  SvgPicture.asset(AppIcons.home, height: 50, width: 50),
                  SvgPicture.asset(AppIcons.mailOutline, height: 50, width: 50),
                  SvgPicture.asset(AppIcons.pen, height: 50, width: 50),
                  // Add more icons as needed
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}
