import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/data/model/verification_question.dart';
import 'package:reentry/ui/modules/verification/bloc/question_event.dart';
import 'package:reentry/ui/modules/verification/bloc/question_state.dart';
import 'package:reentry/ui/modules/verification/bloc/verification_question_bloc.dart';
import '../../../../components/buttons/primary_button.dart';
import '../../../../components/input/input_field.dart';

class CreateQuestionDialog extends HookWidget {
  const CreateQuestionDialog({super.key, this.question});

  final VerificationQuestionDto? question;

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    final controller = useTextEditingController(text: question?.question??'');
    return BlocConsumer<VerificationQuestionBloc, QuestionState>(
      listener: (_,state){
        if(state is QuestionCreatedSuccess || state is QuestionUpdatedSuccess){
          context.popRoute();
        }
      },
        builder: (context, state) {
      return Container(
          padding: const EdgeInsets.all(20),
          child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  20.height,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Manage question',
                        style: context.textTheme.bodyLarge?.copyWith()),
                  ),
                  20.height,
                  15.height,
                  InputField(
                    hint: 'What is your name',
                    controller: controller,
                    lines: 3,
                    validator: (input) => (input?.isNotEmpty ?? true)
                        ? null
                        : 'Please enter a valid input',
                    radius: 10,
                    fillColor: Colors.transparent,
                  ),
                  15.height,
                  50.height,
                  PrimaryButton(
                    text: question == null
                        ? 'Create question'
                        : 'Update question',
                    loading: state is QuestionLoading,
                    onPress: () {
                      if (key.currentState!.validate()) {
                        if (question == null) {
                          context
                              .read<VerificationQuestionBloc>()
                              .add(CreateQuestionEvent(controller.text));
                        } else {
                          final data =
                              question!.copyWith(question: controller.text);
                          context
                              .read<VerificationQuestionBloc>()
                              .add(UpdateQuestionEvent(data));
                        }
                      }
                    },
                  ),
                  50.height,
                ],
              )));
    });
  }
}
