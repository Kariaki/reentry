import 'package:flutter/cupertino.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';

class RequestMentorScreen extends StatelessWidget {
  const RequestMentorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: CustomAppbar(
          title: 'Request a mentor',
        ),
        child: Column(
          children: [
            20.height,
            InputField(hint: 'hello@gmail.com',label: 'Email',),
            20.height,
            InputField(hint: 'What if your reason for a mentor request?', label: 'Reason for request',lines: 3,maxLines: 5,radius: 15,),
            50.height,
            PrimaryButton(text: 'Send request',onPress: (){},)
          ],
        ));
  }
}
