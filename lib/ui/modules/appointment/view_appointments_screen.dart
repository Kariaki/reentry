import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';

import '../../components/container/box_container.dart';
import '../root/navigations/home_navigation_screen.dart';

class ViewAppointmentsScreen extends StatelessWidget {
  const ViewAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const CustomAppbar(
        title: "Reentry",
      ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        30.height,
        label('Appointments'),
        15.height,
        BoxContainer(
            verticalPadding: 10,
            horizontalPadding: 10,
            radius: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              ...[  Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  child: HookBuilder(builder: (context) {
                    final selectedTab = useState(0);
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(items.length, (index) {
                        final item = items[index];
                        return tabComponent(
                            item, index, selectedTab.value == index,
                            onPress: () {
                              selectedTab.value = index;
                            });
                      }),
                    );
                  }),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  separatorBuilder: (context, index) => 0.height,
                  itemBuilder: (context, index) {
                    return appointmentComponent();
                  },
                )]
              ],
            )),
      ],
    ));
  }

}
