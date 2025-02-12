import 'package:flutter/cupertino.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('DELETE ACCOUNT')

      ],
    ));
  }
}
