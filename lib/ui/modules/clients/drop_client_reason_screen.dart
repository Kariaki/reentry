import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/data/model/client_dto.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/clients/bloc/client_event.dart';
import 'package:reentry/ui/modules/root/root_page.dart';

import '../../../core/util/input_validators.dart';
import '../../components/app_bar.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/input/input_field.dart';
import '../appointment/select_appointment_user.dart';
import '../root/mobile_root.dart';
import 'bloc/client_bloc.dart';
import 'bloc/client_state.dart';

class DropClientReasonScreen extends HookWidget {
  final ClientDto entity;

  const DropClientReasonScreen({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final user = context.read<AccountCubit>().state;
    if (user == null) {
      return Center(
        child: Text("No user found"),
      );
    }
    final incidentFiledController = useTextEditingController();
    return BlocConsumer<ClientBloc, ClientState>(builder: (context, state) {
      return BaseScaffold(
        appBar: CustomAppbar(
          title: "Sainte",
        ),
          child:Form(
            key: key,

              child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.height,
              selectableUserContainer(
                  name: entity.name, onTap: () {}, url: entity.avatar ?? ''),
              50.height,
              InputField(
                controller: incidentFiledController,
                hint: 'What is your reason for dropping this client.',
                label: 'Reason',
                validator: InputValidators.stringValidation,
                lines: 3,
                maxLines: 5,
                radius: 15,
              ),
              50.height,
              PrimaryButton(
                text: 'Drop client',
                loading: state is ClientLoading,
                onPress: () {
                  if (key.currentState!.validate()) {
                    context.read<ClientBloc>().add(ClientActionEvent(
                        entity.copyWith(
                            assignees: entity.assignees
                                .where((e) => e != user.userId)
                                .toList(),
                            droppedReason: incidentFiledController.text,
                            status: ClientStatus.dropped)));
                  }
                },
              )
            ],
          )));
    }, listener: (_, state) {
      if (state is ClientError) {
        context.showSnackbarError(state.error);
      }
      if (state is ClientSuccess) {
        context.showSnackbarSuccess("Client dropped");
        context.pushRemoveUntil(MobileRootPage());
      }
    });
  }
}
