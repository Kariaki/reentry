import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';
import 'package:reentry/ui/modules/verification/bloc/question_state.dart';
import 'package:reentry/ui/modules/verification/bloc/submit_verification_question_cubit.dart';
import '../../../../data/model/user_dto.dart';
import '../../../components/buttons/primary_button.dart';
import '../bloc/verification_request_cubit.dart';
import '../bloc/verification_state.dart';

class VerificationFormReviewDialog extends HookWidget {
  VerificationFormReviewDialog({super.key, required this.form, this.user});

  final Map<String, String> form;

  final UserDto? user;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubmitVerificationQuestionCubit,
        SubmitVerificationQuestionCubitState>(builder: (context, state) {
      // final question = state.currentQuestion;
      // final response = state.response;
      // final questionIndex = state.questions.indexWhere((e)=>e.id==question?.id);
      // controller.text = response[question?.id ?? ''] ?? '';
      // print('ebilate -> ${response[question?.id]}');
      // // final index = useState(0);
      final questions = state.questions;
      return BlocBuilder<AccountCubit, UserDto?>(builder: (context, account) {
        return Container(
            padding: const EdgeInsets.all(20),
            child: Scrollbar(
                child: SingleChildScrollView(
              child: BlocConsumer<VerificationRequestCubit,
                      VerificationRequestCubitState>(
                  builder: (context, verificationState) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        20.height,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Verification form',
                              style: context.textTheme.bodyLarge?.copyWith(fontSize: 18,fontWeight: FontWeight.bold)),
                        ),
                        20.height,
                        ...questions.map((value) {
                          String? answer = form[value.id ?? ''];
                          return ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(
                              value.question,
                              style:
                                  const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            subtitle: Text(
                              "Answer: ${answer ?? 'No answer'}",
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white54),
                            ),
                          );
                        }),
                        20.height,
                        if(verificationState.state is CubitStateLoading)
                          const Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        if (user?.accountType == AccountType.admin &&
                            user?.verificationStatus !=
                                VerificationStatus.verified.name && verificationState.state is! CubitStateLoading) ...[
                          PrimaryButton(
                            text: 'Approve',
                            onPress: () {
                              if(user!=null) {
                                context.read<VerificationRequestCubit>()
                                    .updateRequest(user!, VerificationStatus.verified);
                              }
                            },
                          ),
                          20.height,
                          PrimaryButton.dark(text: 'Reject', onPress: () {
                            if(user!=null) {
                              context.read<VerificationRequestCubit>()
                                  .updateRequest(user!, VerificationStatus.rejected);
                            }
                          })
                        ]
                        //todo show decline
                      ],
                    );
                  },
                  listener: (_, state) {
                    if(state.state is CubitStateSuccess){
                      context.showSnackbarSuccess('Form updated');
                    }
                    if(state.state is CubitStateError){
                      context.showSnackbarError('Something went wrong');
                    }
                  }),
            )));
      });
    });
  }
}
