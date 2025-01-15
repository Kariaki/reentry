import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/routes/router.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/pagination.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/incidents/cubit/report_cubit.dart';
import 'package:reentry/ui/modules/incidents/cubit/report_cubit_state.dart';
import 'package:reentry/ui/modules/report/web/components/report_card.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final List<Map<String, dynamic>> complaints = [
    {
      "title": "Issue with my parole officer",
      "complainant": "Alec Whitten",
      "complaintDate": "17 Jan 2024",
      "complaintAgainst": "James Felix",
      "complaintAgainstRole": "Parole officer",
      "description":
          "Like to know the secrets of transforming a 2–14 team into a 3× Super Bowl winning Dynasty? "
              "Lectus leo massa amet posuere. Malesuada mattis non convallis quisque. "
              "Libero sit et imperdiet bibendum quisque dictum vestibulum in non.",
      "responses": 2,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
    {
      "title": "Concern about neighborhood safety",
      "complainant": "John Doe",
      "complaintDate": "18 Jan 2024",
      "complaintAgainst": "Local Council",
      "complaintAgainstRole": "Government agency",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum.",
      "responses": 5,
    },
  ];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final int itemsPerPage = 5;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    context.read<ReportCubit>().fetchReports();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
        currentPage = 1;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> getFilteredComplaints() {
    if (_searchQuery.isEmpty) {
      return complaints;
    }
    return complaints.where((complaint) {
      final title = complaint['title']?.toLowerCase() ?? '';
      final complainant = complaint['complainant']?.toLowerCase() ?? '';
      return title.contains(_searchQuery) || complainant.contains(_searchQuery);
    }).toList();
  }

  void setPage(int pageNumber) {
    setState(() {
      currentPage = pageNumber;
    });
  }

  List<Map<String, dynamic>> getPaginatedComplaints() {
    final filteredComplaints = getFilteredComplaints();
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return filteredComplaints.sublist(
      startIndex,
      endIndex > filteredComplaints.length
          ? filteredComplaints.length
          : endIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredComplaints = getFilteredComplaints();
    final paginatedComplaints = getPaginatedComplaints();
    final totalPages = (filteredComplaints.length / itemsPerPage).ceil();

    return BlocBuilder<ReportCubit, ReportCubitState>(
        builder: (context, state) {
      return BaseScaffold(
          isLoading: state.state is CubitStateLoading,
          child: Scaffold(
            backgroundColor: AppColors.greyDark,
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
                        controller: _searchController,
                        hint: 'Enter title or author to search',
                        radius: 10.0,
                        preffixIcon: SvgPicture.asset(Assets.webSearch),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                color: AppColors.greyDark,
                child: Column(
                  children: [
                    Expanded(
                      child: Builder(builder: (context){
                        if(state.state is CubitStateLoading){
                          return SizedBox();
                        }
                        if(state
                        .state is CubitStateError){
                         return _reportEmptyState(context);
                        }
                        return state.data.isNotEmpty
                            ? ListView.builder(
                          padding: const EdgeInsets.only(left: 16,right: 16,bottom: 16),
                          itemCount: state.data.length,
                          itemBuilder: (context, index) {
                            final complaint = state.data[index];
                            return ReportCard(
                              onClick: () {
                                context.read<ReportCubit>().select(complaint);
                                context.goNamed(AppRoutes.viewReports.name,
                                    extra: complaint);
                              },
                              title: complaint.title,
                              complainant: complaint.victim.name,
                              complaintDate: complaint.date.formatDate(),
                              complaintAgainst: complaint.reported.name,
                              complaintAgainstRole:
                              complaint.reported.account.name,
                              description: complaint.description,
                              responses: complaint.responseCount,
                            );
                          },
                        )
                            : _reportEmptyState(context);
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ));
    });
  }

  Widget _reportEmptyState(BuildContext context) {
    return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.warning,
                              size: 100,
                              color: AppColors.greyWhite,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "No complaints found",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                color: AppColors.greyWhite,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
  }
}
