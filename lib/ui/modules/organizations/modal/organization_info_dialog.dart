import 'package:flutter/cupertino.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/organizations/cubit/organization_cubit_state.dart';

class OrganizationInfoDialog extends StatelessWidget {
  const OrganizationInfoDialog({super.key, required this.data,this.joined=true});

  final FoundOrganization data;
  final bool joined;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [Text(data.data.name), Text(data.citizens.toString())],
      ),
    );
  }
}
