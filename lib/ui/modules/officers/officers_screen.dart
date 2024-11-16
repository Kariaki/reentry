import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/pagination.dart';
import 'package:reentry/ui/modules/activities/chart/graph_component.dart';
import 'package:reentry/ui/modules/citizens/component/profile_card.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

class OfficersScreen extends StatefulWidget {
  const OfficersScreen({super.key});

  @override
  _OfficersScreenState createState() => _OfficersScreenState();
}

class _OfficersScreenState extends State<OfficersScreen> {
  final int itemsPerPage = 10;
  int currentPage = 1;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<AdminUsersCubit>().fetchOfficers();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> getPaginatedItems(List<dynamic> officersList) {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return officersList.sublist(
      startIndex,
      endIndex > officersList.length ? officersList.length : endIndex,
    );
  }

  List<dynamic> filterOfficers(List<dynamic> officersList) {
    if (_searchQuery.isEmpty) {
      return officersList;
    }

    return officersList
        .where((officer) =>
            officer.name.toLowerCase().contains(_searchQuery) ||
            officer.email.toLowerCase().contains(_searchQuery) ||
            officer.userId.toString().contains(_searchQuery))
        .toList();
  }

  void setPage(int pageNumber) {
    setState(() {
      currentPage = pageNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 5;
    if (screenWidth < 1200) {
      crossAxisCount = 4;
    }
    if (screenWidth < 900) {
      crossAxisCount = 3;
    }
    if (screenWidth < 600) {
      crossAxisCount = 2;
    }

    return Scaffold(
      backgroundColor: AppColors.greyDark,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          backgroundColor: AppColors.greyDark,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Search",
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.greyWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  controller: _searchController,
                  hint: 'Enter name, email or code to search',
                  radius: 10.0,
                  preffixIcon: SvgPicture.asset(Assets.search),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocBuilder<AdminUsersCubit, CubitState>(
          builder: (context, state) {
            if (state is CubitStateLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is CubitDataStateSuccess<List<dynamic>>) {
              final officersList = filterOfficers(state.data);
              if (officersList.isEmpty) {
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
                        "No officers available",
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: AppColors.greyWhite,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Try searching for a term or check back later.",
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.gray2,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final totalPages = (officersList.length / itemsPerPage).ceil();
              return Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 30.0,
                        mainAxisSpacing: 40.0,
                        childAspectRatio: 0.67,
                      ),
                      itemCount: getPaginatedItems(officersList).length,
                      itemBuilder: (context, index) {
                        final user = getPaginatedItems(officersList)[index];
                        return ProfileCard(
                          name: user.name,
                          email: user.email,
                          imageUrl: user.avatar,
                          showActions: true,
                          onViewProfile: () {
                            Beamer.of(context).beamToNamed(
                              '/parole_officers/profile/${user.userId}',
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Pagination(
                    totalPages: totalPages,
                    currentPage: currentPage,
                    onPageSelected: setPage,
                  ),
                ],
              );
            } else if (state is CubitStateError) {
              return Center(
                child: Text(
                  "Error: ${state.message}",
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.red,
                  ),
                ),
              );
            } else {
              return Center(
                child: Text(
                  "No data available",
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.red,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
