import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/app_button.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/clients/drop_client_reason_screen.dart';

import '../../../data/model/client_dto.dart';
import '../appointment/select_appointment_user.dart';

class ClientProfileScree extends HookWidget {
  final ClientDto client;

  const ClientProfileScree({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        appBar: const CustomAppbar(
          title: "Sainte",
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: selectableUserContainer(
                        name: client.name,
                        onTap: () {},
                        url: client.avatar ?? '')),
                AppOutlineButton(
                    title: 'Drop',
                    onPress: () {
                      context.pushRoute(DropClientReasonScreen(entity: client));
                    })
              ],
            ),
            20.height,
          ],
        ));
  }
}
