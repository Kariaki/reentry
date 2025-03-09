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

import '../../incidents/cubit/report_cubit_state.dart';

class ViewReportPage extends StatefulWidget {
  const ViewReportPage({super.key});

  @override
  _ViewReportPageState createState() => _ViewReportPageState();
}

class _ViewReportPageState extends State<ViewReportPage> {
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

    return BlocConsumer<ReportCubit,ReportCubitState>(

      listener: (_,state){
        if(state is ResponseStateSuccess){
          context.showSnackbarSuccess('Response sent');
        }
      },
        builder: (context,state){
      final complaint = state.selected;
      if (complaint == null) {
        context.pop();
        return const SizedBox();
      }
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
                  ReportCard(
                    title: complaint.title,
                    complainant: complaint.victim.name,
                    preview: false,
                    complaintDate: complaint.date.formatDate(),
                    complaintAgainst: complaint.reported.name,
                    complaintAgainstRole: complaint.reported.account.name,
                    description: complaint.description,
                    responses: complaint.responseCount,
                  ),
                  50.height,
                  Text(
                    "Response",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.greyWhite,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  20.height,
                  InputField(
                    hint: 'Enter your response here...',
                    radius: 10.0,
                    controller: _controller,
                    maxLines: 10,
                    lines: 6,
                  ),
                  20.height,
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomIconButton(
                          label: "Cancel",
                          backgroundColor: AppColors.greyDark,
                          textColor: AppColors.white,
                          borderColor: AppColors.white,
                          onPressed: () {
                            _controller.clear();
                          },
                        ),
                        5.width,
                        CustomIconButton(
                          label: "Respond",
                          backgroundColor: AppColors.white,

                          textColor: AppColors.black,
                          onPressed: () {
                            if(_controller.text.isEmpty){
                              return;
                            }
                            context.read<ReportCubit>().submitResponse(_controller.text);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
