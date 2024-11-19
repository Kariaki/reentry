import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/pagination.dart';
import 'package:reentry/ui/modules/citizens/component/profile_card.dart';
import 'package:reentry/ui/modules/shared/cubit/admin_cubit.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

class NoncitizensScreen extends StatefulWidget {
  final AccountType accountType;
  const NoncitizensScreen({super.key,required this.accountType});

  @override
  _NoncitizensScreenState createState() => _NoncitizensScreenState();
}

class _NoncitizensScreenState extends State<NoncitizensScreen> {
  final int itemsPerPage = 10;
  int currentPage = 1;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<AdminUserCubitNew>().fetchOfficers();
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

  List<dynamic> getPaginatedItems(List<dynamic> mentorList) {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return mentorList.sublist(
      startIndex,
      endIndex > mentorList.length ? mentorList.length : endIndex,
    );
  }

  List<dynamic> filterMentors(List<dynamic> mentorList) {
    if (_searchQuery.isEmpty) {
      return mentorList;
    }

    return mentorList
        .where((mentor) =>
    mentor.name.toLowerCase().contains(_searchQuery) ||
        mentor.email.toLowerCase().contains(_searchQuery) ||
        mentor.userId.toString().contains(_searchQuery))
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
        child: BlocBuilder<AdminUserCubitNew, MentorDataState>(
          builder: (context, _state) {
            //[], userDto, state
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
                      "No mentors available",
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
            final mentorList = filterMentors(data);

            final totalPages = (mentorList.length / itemsPerPage).ceil();
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
                    itemCount: getPaginatedItems(mentorList).length,
                    itemBuilder: (context, index) {
                      final user = getPaginatedItems(mentorList)[index];
                      return ProfileCard(
                        name: user.name,
                        email: user.email,
                        imageUrl: user.avatar,
                        showActions: true,
                        onViewProfile: () {
                          context.read<AdminUserCubitNew>().selectCurrentUser(user);
                          Beamer.of(context).beamToNamed(
                            '/peer_mentors/profile/${user.userId}',
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
          },
        ),
      ),
    );
  }
}
