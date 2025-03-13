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
import '../../../../core/const/app_constants.dart';
import '../../../dialog/alert_dialog.dart';
import '../../appointment/component/table.dart';
import '../bloc/verification_request_cubit.dart';
import '../bloc/verification_state.dart';
import '../dialog/verification_form_dialog.dart';
import '../dialog/verification_form_review_dialog.dart';
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
    context.read<VerificationRequestCubit>().fetchVerificationRequest();
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
      child: BlocBuilder<VerificationRequestCubit,
          VerificationRequestCubitState>(builder: (context, state) {
        return BaseScaffold(
          isLoading: state.state is CubitStateLoading ,
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
                            .read<VerificationRequestCubit>()
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
          child: Scrollbar(
              thumbVisibility: true,
              trackVisibility: true,
              child:  SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Builder(
                    builder: (
                        context,
                        ) {
                      final data = state.users;
                      if (data.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.people_outline,
                                size: 100,
                                color: AppColors.greyWhite,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "No submission.",
                                style: context.textTheme.bodyLarge?.copyWith(
                                  color: AppColors.greyWhite,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "There are no verification submission at this time.",
                                textAlign: TextAlign.center,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: AppColors.gray2,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final columns = [
                        const DataColumn(
                            label: TableHeader("Name ")),
                        const DataColumn(label: TableHeader("Email address")),
                        const DataColumn(label: TableHeader("Date submitted")),
                      ];
                      List<DataRow> _buildRows(_) {
                        return data.map((item) {
                          return DataRow(
                            onSelectChanged: (isSelected) {
                              context.read<SubmitVerificationQuestionCubit>().seResponse(item.verification?.form??{});
                             context.displayDialog(VerificationFormReviewDialog(form: item.verification?.form
                               ??{},user: item,));
                              // _context
                              //     .read<OrganizationCubit>()
                              //     .selectOrganization(item);
                              // _context.goNamed(AppRoutes.organizationProfile.name);
                            },
                            cells: [
                              DataCell(Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          item.avatar ?? AppConstants.avatar),
                                    ),
                                  ),
                                  10.width,
                                  Text(item.name ?? "")
                                ],
                              )),
                              DataCell(Text(item.email ?? "")),
                              DataCell(Text(item.verification?.date?.split('T').firstOrNull ?? "")),
                            ],
                          );
                        }).toList();
                      }
                      final rows = _buildRows(context);
                      return Column(
                        children: [
                          Container(
                            color: Colors.black,
                            child: ReusableTable(
                              columns: columns,
                              rows: rows,
                              headingRowColor: AppColors.white,
                              dataRowColor: AppColors.greyDark,
                              columnSpacing: 20.0,
                              dataRowHeight: 56.0,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ),
              )),
        );
      }),
    );
  }
}
