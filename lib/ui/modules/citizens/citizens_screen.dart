// ignore_for_file: library_private_types_in_public_api

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/pagination.dart';
import 'package:reentry/ui/modules/activities/chart/chart_component.dart';
import 'package:reentry/ui/modules/activities/chart/graph_component.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/citizens/component/profile_card.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

class CitizensScreen extends StatefulWidget {
  const CitizensScreen({super.key});

  @override
  _CitizensScreenState createState() => _CitizensScreenState();
}

class _CitizensScreenState extends State<CitizensScreen> {
  final int itemsPerPage = 10;
  int currentPage = 1;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<AdminUserCubitNew>().fetchCitizens();
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

  List<dynamic> getPaginatedItems(List<dynamic> citizensList) {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return citizensList.sublist(
      startIndex,
      endIndex > citizensList.length ? citizensList.length : endIndex,
    );
  }

  List<dynamic> filterCitizens(List<dynamic> citizensList) {
    if (_searchQuery.isEmpty) {
      return citizensList;
    }
    return citizensList
        .where((citizen) =>
            citizen.name.toLowerCase().contains(_searchQuery) ||
            citizen.email.toLowerCase().contains(_searchQuery) ||
            citizen.id.toString().contains(_searchQuery))
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
                  preffixIcon: SvgPicture.asset(Assets.webSearch),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocBuilder<AdminUserCubitNew, MentorDataState>(
            builder: (context, _state) {
          final state = _state.state;
          if (state is CubitStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CubitStateError) {
            return Center(
              child: Text(
                "Error: ${state.message}",
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.red,
                ),
              ),
            );
          }

          final data = _state.data;
          if (data.isEmpty) {
            return Center(
              child: Text(
                "No data available",
                style: context.textTheme.bodyLarge?.copyWith(
                  color: AppColors.red,
                ),
              ),
            );
          }

          final citizensList = filterCitizens(data);
          if (citizensList.isEmpty) {
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
                    "No citizens available",
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

          final totalPages = (citizensList.length / itemsPerPage).ceil();
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 30.0,
                    mainAxisSpacing: 40.0,
                    childAspectRatio: 0.73,
                  ),
                  itemCount: getPaginatedItems(citizensList).length,
                  itemBuilder: (context, index) {
                    final user = getPaginatedItems(citizensList)[index];
                    return ProfileCard(
                      name: user.name,
                      email: user.email,
                      imageUrl: user.avatar,
                      showActions: true,
                      onViewProfile: () {
                        context
                            .read<AdminUserCubitNew>()
                            .selectCurrentUser(user);
                        Beamer.of(context)
                            .beamToNamed('/citizens/${user.userId}');
                      },
                      onUnmatch: () {
                        _showRescheduleModal(context);
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
        }),
      ),
    );
  }

  void _showRescheduleModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.greyDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 168,
                        height: 200,
                        child: ProfileCard(
                          name: "client.name",
                          email: "client.email",
                          imageUrl: Assets.imagesCitiImg,
                          showActions: false,
                        ),
                      ),
                      20.width,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Unmatch citizen?",
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: AppColors.greyWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 30,
                            ),
                          ),
                          1.height,
                          Text(
                            "This action cannot be undone",
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: AppColors.hintColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                          10.height,
                          const Divider(
                            color: AppColors.white,
                            thickness: 1,
                            height: 30,
                          ),
                        ],
                      )
                    ],
                  ),
                  20.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter reason for unmatching",
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: AppColors.greyWhite,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      10.height,
                      const InputField(
                        hint: "Enter your message",
                        radius: 5.0,
                        maxLines: 10,
                        lines: 6,
                        suffixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                      20.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomIconButton(
                              backgroundColor: AppColors.white,
                              textColor: AppColors.black,
                              label: "Unmatch",
                              onPressed: () {}),
                          20.height,
                          CustomIconButton(
                              backgroundColor: AppColors.greyDark,
                              textColor: AppColors.white,
                              label: "Cancel",
                              borderColor: AppColors.white,
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
