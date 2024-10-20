import 'package:flutter/cupertino.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';

class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CustomAppbar(title: 'Messaging',),
        child: Column(
      children: [

      ],
    ));
  }
}
