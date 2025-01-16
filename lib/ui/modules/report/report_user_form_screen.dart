import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/util/input_validators.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/incidence_dto.dart';
import 'package:reentry/data/model/mentor_request.dart';
import 'package:reentry/data/model/report_dto.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/appointment/select_appointment_user.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/mentor/bloc/mentor_bloc.dart';
import 'package:reentry/ui/modules/mentor/bloc/mentor_event.dart';
import 'package:reentry/ui/modules/mentor/bloc/mentor_state.dart';
import 'package:reentry/ui/modules/messaging/entity/conversation_user_entity.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';
import 'package:reentry/ui/modules/util/bloc/utility_bloc.dart';
import 'package:reentry/ui/modules/util/bloc/utility_event.dart';
import 'package:reentry/ui/modules/util/bloc/utility_state.dart';

class ReportUserFormScreen extends HookWidget {
  final ConversationUserEntity entity;

  const ReportUserFormScreen({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final account = context.read<AccountCubit>().state;
    final incidentFiledController = useTextEditingController();
    final titleController = useTextEditingController();
    return BlocProvider(
      create: (context) => UtilityBloc(),
      child: BlocConsumer<UtilityBloc, UtilityState>(
        listener: (_, state) {
          if (state is UtilityFailed) {
            context.showSnackbarError(state.error);
          }
          if (state is UtilitySuccess) {
            context.pushReplace(SuccessScreen(
              callback: () {},
              title: 'Saved',
              description: 'Your report will be reviewed',
            ));
          }
        },
        builder: (context, state) {
          return BaseScaffold(
              appBar: const CustomAppbar(
                title: 'Report an incident',
              ),
              child: Form(
                  key: key,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        20.height,
                        selectableUserContainer(
                            name: entity.name,
                            onTap: () {},
                            url: entity.avatar ?? ''),
                        50.height,
                        InputField(
                          controller: titleController,
                          hint: 'Enter the summary of the incident',
                          label: 'Title',
                          validator: InputValidators.stringValidation,
                          lines: 3,
                          maxLines: 5,
                          radius: 15,
                        ),
                        20.height,
                        InputField(
                          controller: incidentFiledController,
                          hint: 'Enter the details of the incident',
                          label: 'Incident',
                          validator: InputValidators.stringValidation,
                          lines: 3,
                          maxLines: 5,
                          radius: 15,
                        ),
                        // 20.height,
                        // InputField(
                        //   controller: reasonController,
                        //   hint: 'What if your reason for a mentor request?',
                        //   label: 'Reason for request',
                        //   validator: InputValidators.stringValidation,
                        //   lines: 3,
                        //   maxLines: 5,
                        //   radius: 15,
                        // ),
                        50.height,
                        PrimaryButton(
                          text: 'Report',
                          loading: state is UtilityLoading,
                          onPress: () {
                            if (key.currentState!.validate()) {
                              final reportedUser = UsersInvolved(
                                  name: entity.name,
                                  userId: entity.userId,
                                  account: AccountType.mentor);
                              final victim = UsersInvolved(
                                  name: account?.name ?? '',
                                  userId: account?.userId ?? '',
                                  account: account?.accountType ??
                                      AccountType.citizen);
                              final reportDto = IncidenceDto(
                                  title: titleController.text,
                                  description: incidentFiledController.text,
                                  date: DateTime.now(),
                                  id: '',
                                  reported: reportedUser,
                                  victim: victim);
                              context
                                  .read<UtilityBloc>()
                                  .add(ReportUserEvent(reportDto));
                            }
                          },
                        )
                      ],
                    ),
                  )));
        },
      ),
    );
  }
}
