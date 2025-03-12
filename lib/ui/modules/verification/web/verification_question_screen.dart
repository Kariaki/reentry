import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/routes/router.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/incidents/cubit/report_cubit.dart';
import 'package:reentry/ui/modules/report/web/components/report_card.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';
import 'package:reentry/ui/modules/verification/bloc/question_state.dart';
import 'package:reentry/ui/modules/verification/bloc/verification_question_bloc.dart';
import 'package:reentry/ui/modules/verification/bloc/verification_question_cubit.dart';

import '../../incidents/cubit/report_cubit_state.dart';

class VerificationQuestionScreen extends StatefulWidget {
  const VerificationQuestionScreen({super.key});

  @override
  _VerificationQuestionScreenState createState() => _VerificationQuestionScreenState();
}

class _VerificationQuestionScreenState extends State<VerificationQuestionScreen> {
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = '';
  final int itemsPerPage = 5;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<VerificationQuestionBloc,QuestionState>(
        listener: (_,state){
          // if(state is ResponseStateSuccess){
          //   context.showSnackbarSuccess('Response sent');
          // }
        },
    child: BlocBuilder<VerificationQuestionCubit,VerificationQuestionCubitState>(

        builder: (context,state){
          // final complaint = state.selected;
          // if (complaint == null) {
          //   context.pop();
          //   return const SizedBox();
          // }
          return BaseScaffold(
            isLoading: state.state is CubitStateLoading,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Container(
                  color: AppColors.greyDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text('view question')
                    ],
                  ),
                ),
              ),
            ),
          );
        }
    ),);
  }
}
