import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/util/input_validators.dart';
import 'package:reentry/data/model/mentor_request.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/careTeam/bloc/mentor_bloc.dart';
import 'package:reentry/ui/modules/careTeam/bloc/mentor_event.dart';
import 'package:reentry/ui/modules/careTeam/bloc/mentor_state.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';

class RequestMentorScreen extends HookWidget {
  const RequestMentorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final account = context.read<AccountCubit>().state;
    final emailController = useTextEditingController();
    final reasonController = useTextEditingController();
    return BlocProvider(
      create: (context) => MentorBloc(),
      child: BlocListener<MentorBloc, MentorState>(
        listener: (_, state) {
          if (state is MentorStateSuccess) {
            //navigate to success screen
            context.pushReplace(SuccessScreen(
              callback: () {
                context.popRoute();
              },
              title: "Request sent",
              description:
                  "You will receive an email when your request is approved",
            ));
          }

          if (state is MentorStateError) {
            context.showSnackbarError(state.message);
          }
        },
        child: BaseScaffold(
            appBar: const CustomAppbar(
              title: 'Request a mentor',
            ),
            child: Form(
                key: key,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      20.height,
                      InputField(
                        initialValue: account?.email ?? '',
                        enable: false,
                        hint: 'hello@gmail.com',
                        validator: InputValidators.emailValidation,
                        label: 'Email',
                      ),
                      20.height,
                      InputField(
                        controller: reasonController,
                        hint: 'What is your reason for a mentor request?',
                        label: 'Reason for request',
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
                      BlocBuilder<MentorBloc, MentorState>(
                          builder: (context, mentorState) {
                        return PrimaryButton(
                          text: 'Send request',
                          loading: mentorState is MentorStateLoading,
                          onPress: () {
                            if (key.currentState!.validate()) {
                              context.read<MentorBloc>().add(RequestMentorEvent(
                                  MentorRequest(
                                      name: account?.name ?? '',
                                      avatar: account?.avatar ?? 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
                                      reasonForRequest: reasonController.text,
                                      whatYouNeedInAMentor:
                                          reasonController.text,
                                      email: account?.email ?? '')));
                            }
                          },
                        );
                      })
                    ],
                  ),
                ))),
      ),
    );
  }
}
