import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/util/bloc/utility_event.dart';

import '../../../core/util/input_validators.dart';
import '../../components/app_bar.dart';
import '../../components/buttons/primary_button.dart';
import '../../components/input/input_field.dart';
import '../authentication/bloc/account_cubit.dart';
import '../shared/success_screen.dart';
import '../util/bloc/utility_bloc.dart';
import '../util/bloc/utility_state.dart';

class SupportTicketScreen extends HookWidget {
  const SupportTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final account = context.read<AccountCubit>().state;
    final detailsController = useTextEditingController();
    final titleController = useTextEditingController();
    return BlocProvider(create: (context)=>UtilityBloc(),
    child: BlocConsumer<UtilityBloc, UtilityState>(
      listener: (_, state) {
        if (state is UtilityFailed) {
          context.showSnackbarError(state.error);
        }
        if (state is UtilitySuccess) {
          context.pushReplace(SuccessScreen(
            callback: () {},
            title: 'Saved',
            description: 'Thanks for your feedback, it will be reviewed',
          ));
        }
      },
      builder: (context, state) {
        return BaseScaffold(
            appBar: const CustomAppbar(
              title: 'Support',
            ),
            child: Form(
                key: key,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      20.height,
                      InputField(
                        controller: titleController,
                        hint: 'Enter a title for your feedback',
                        label: 'Title',
                        validator: InputValidators.stringValidation,
                        lines: 3,
                        maxLines: 5,
                        radius: 15,
                      ),
                      20.height,
                      InputField(
                        controller: detailsController,
                        hint: 'Enter the your experience or feedback',
                        label: 'Details of ticket',
                        validator: InputValidators.stringValidation,
                        lines: 3,
                        maxLines: 5,
                        radius: 15,
                      ),
                      50.height,
                      PrimaryButton(
                        text: 'Send',
                        loading: state is UtilityLoading,
                        onPress: () {
                          if (key.currentState!.validate()) {
                            context.read<UtilityBloc>().add(SupportTicketEvent(
                                description: detailsController.text,
                                title: titleController.text));
                          }
                        },
                      )
                    ],
                  ),
                )));
      },
    ),);
  }
}
