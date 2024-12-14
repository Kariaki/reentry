import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/util/input_validators.dart';
import 'package:reentry/data/model/mentor_request.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/app_button.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_bloc.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_event.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_state.dart';
import 'package:reentry/ui/modules/mentor/bloc/mentor_bloc.dart';
import 'package:reentry/ui/modules/mentor/bloc/mentor_event.dart';
import 'package:reentry/ui/modules/mentor/bloc/mentor_state.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';

class RequestResourceScreen extends HookWidget {
  const RequestResourceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final account = context.read<AccountCubit>().state;
    final titleController = useTextEditingController();
    final reasonController = useTextEditingController();
    return BlocProvider(
      create: (context) => BlogBloc(),
      child: BlocListener<BlogBloc, BlogState>(
        listener: (_, state) {
          if (state is RequestBlogSuccess) {
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

          if (state is BlogError) {
            context.showSnackbarError(state.error);
          }
        },
        child: BaseScaffold(
            appBar: const CustomAppbar(
              title: 'Request a resource',
            ),
            child: Form(
                key: key,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      20.height,
                       InputField(
                         controller: titleController,
                        hint: 'eg: I need help with my email..',
                        label: 'Ticket title',
                      ),
                      20.height,
                      InputField(
                        controller: reasonController,
                        hint: 'Enter the details of the assistance you need',
                        label: 'Details',
                        validator: InputValidators.stringValidation,
                        lines: 3,
                        maxLines: 5,
                        radius: 10,
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
                      30.height,
                      BlocBuilder<BlogBloc, BlogState>(
                          builder: (context, mentorState) {
                        return PrimaryButton(
                          text: 'Send',
                          loading: mentorState is BlogLoading,
                          onPress: () {
                            if (key.currentState!.validate()) {
                              context.read<BlogBloc>().add(RequestBlogEvent(
                                  userId: account?.userId ?? '',
                                  title: titleController.text,
                                  email: account?.email ?? '',
                                  details: reasonController.text));
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
