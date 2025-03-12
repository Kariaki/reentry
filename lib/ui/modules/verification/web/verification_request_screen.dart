import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';
import 'package:reentry/ui/modules/verification/bloc/question_event.dart';
import 'package:reentry/ui/modules/verification/bloc/question_state.dart';
import 'package:reentry/ui/modules/verification/bloc/submit_verification_question_cubit.dart';
import 'package:reentry/ui/modules/verification/bloc/verification_question_bloc.dart';
import 'package:reentry/ui/modules/verification/bloc/verification_question_cubit.dart';
import '../../../dialog/alert_dialog.dart';
import '../dialog/verification_form_dialog.dart';
import 'dialog/add_question_dialog.dart';

class VerificationRequestScreen extends StatefulWidget {
  const VerificationRequestScreen({super.key});

  @override
  _VerificationRequestScreenState createState() =>
      _VerificationRequestScreenState();
}

class _VerificationRequestScreenState
    extends State<VerificationRequestScreen> {
  final TextEditingController _controller = TextEditingController();
  final int itemsPerPage = 5;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    context.read<SubmitVerificationQuestionCubit>().fetchQuestions();
    context.read<VerificationQuestionCubit>()
      ..fetchQuestions()
      ..uploadDummyQuestions();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerificationQuestionBloc, QuestionState>(
      listener: (_, state) {
        if (state is QuestionDeletedSuccess) {
          context.showSnackbarSuccess('Question deleted');
        }
        if (state is QuestionUpdatedSuccess) {
          context.showSnackbarSuccess('Changes saved');
        }
        if (state is QuestionCreatedSuccess) {
          context.showSnackbarSuccess('New question added');
        }
      },
      child: BlocBuilder<VerificationQuestionBloc, QuestionState>(
          builder: (context, blocState) {
        return BlocBuilder<VerificationQuestionCubit,
            VerificationQuestionCubitState>(builder: (context, state) {
          return BaseScaffold(
            isLoading: state.state is CubitStateLoading ||
                blocState is QuestionLoading,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(120),
              child: AppBar(
                backgroundColor: Colors.transparent,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Search",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.greyWhite,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 10),
                      InputField(
                        hint: 'Enter title or author to search',
                        radius: 10.0,
                        onChange: (value) {
                          context
                              .read<VerificationQuestionCubit>()
                              .search(value);
                        },
                        preffixIcon: const Icon(
                          CupertinoIcons.search,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Container(
                  color: AppColors.greyDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //todo use table instead of list
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      }),
    );
  }
}
