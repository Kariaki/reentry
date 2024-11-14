import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/admin/components/over_view_component.dart';

class DashboardPage  extends StatelessWidget {
  const DashboardPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(child: Column(
      children: [

        50.height,
        OverViewComponent(),
      ],
    ));
  }
}
