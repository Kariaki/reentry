import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';
import 'package:reentry/ui/modules/verification/bloc/question_state.dart';
import 'package:reentry/ui/modules/verification/bloc/submit_verification_question_cubit.dart';
import 'package:reentry/ui/modules/verification/dialog/verification_form_review_dialog.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/input/input_field.dart';

class VerificationFormDialog extends HookWidget {
   VerificationFormDialog({super.key});


  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<FormState>();
    return BlocConsumer<SubmitVerificationQuestionCubit,
            SubmitVerificationQuestionCubitState>(
        builder: (context, state) {
          final question = state.currentQuestion;
          final response = state.response;
          final questionIndex = state.questions.indexWhere((e)=>e.id==question?.id);
          controller.text = response[question?.id ?? ''] ?? '';
          print('ebilate -> ${response[question?.id]}');
          return  BlocBuilder<AccountCubit,UserDto?>(builder: (context,account){
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
                          child: Text('Verification form',
                              style: context.textTheme.bodyLarge?.copyWith()),
                        ),
                        40.height,
                        InputField(
                          hint: 'Enter your answer',
                          label: question?.question,
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
                        // PrimaryButton(
                        //   text: 'Preview',
                        //   loading: state.state is CubitStateLoading,
                        //   onPress: () {
                        //     context.displayDialog(VerificationFormReviewDialog(form: state.response,));
                        //     // index.value = index.value + 1;
                        //   },
                        // ),
                        // 20.height,
                        Row(
                          children: [
                            if(questionIndex>0)
                              Expanded(child: PrimaryButton(
                                text: 'Previous',
                                loading: state.state is CubitStateLoading,
                                onPress: () {
                                  context
                                      .read<SubmitVerificationQuestionCubit>()
                                      .previousQuestion(
                                    questionIndex-1,);
                                  // index.value = index.value + 1;
                                },
                              )),
                            if(questionIndex>0 && questionIndex<state.questions.length-1)
                              ...[
                                10.width
                              ],
                            if(questionIndex!=state.questions.length-1)
                              Expanded(child: PrimaryButton(
                                text: 'Save and proceed',
                                loading: state.state is CubitStateLoading,
                                onPress: () {
                                  context
                                      .read<SubmitVerificationQuestionCubit>()
                                      .addAnswerAndShowNext(
                                    controller.text,);
                                  controller.clear();
                                },
                              )),

                          ],
                        ),
                        50.height,
                      ],
                    )));
          });
        },
        listener: (_, state) {
          //
          // final question = state.currentQuestion;
          // final response = state.response;
          // controller.text = response[question?.id ?? ''] ?? '';
          // print('ebilate -> ${response[question?.id]}');
        });
  }
}
