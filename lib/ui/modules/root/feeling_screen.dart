import 'package:flutter/cupertino.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';

class FeelingScreen extends StatelessWidget {
  const FeelingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: CustomAppbar(
          showBack: false,
        ),
        child: Column(
          children: [],
        ));
  }
}
