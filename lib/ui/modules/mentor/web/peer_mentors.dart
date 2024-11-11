// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/pagination.dart';
import 'package:reentry/ui/modules/citizens/component/citizen_data.dart';
import 'package:reentry/ui/modules/citizens/component/profile_card.dart';

class PeerMentorScreen extends StatefulWidget {
  const PeerMentorScreen({super.key});

  @override
  _PeerMentorScreenState createState() => _PeerMentorScreenState();
}

class _PeerMentorScreenState extends State<PeerMentorScreen> {
  late List<dynamic> citizensList;
  final int itemsPerPage = 10;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    citizensList = jsonDecode(citizensData);
  }

  List<dynamic> getPaginatedItems() {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return citizensList.sublist(startIndex,
        endIndex > citizensList.length ? citizensList.length : endIndex);
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

    final totalPages = (citizensList.length / itemsPerPage).ceil();

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
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 30.0,
                  mainAxisSpacing: 40.0,
                  childAspectRatio: 0.67,
                ),
                itemCount: getPaginatedItems().length,
                itemBuilder: (context, index) {
                  final user = getPaginatedItems()[index];
                  return CitizensProfileCard(
                    name: user['name'],
                    email: user['email'],
                    phone: user['id'],
                    verified: user['verified'],
                    imageUrl: user['imageUrl'],
                  );
                },
              ),
            ),
            const SizedBox(height: 20,),
            Pagination(
              totalPages: totalPages,
              currentPage: currentPage,
              onPageSelected: setPage,
            ),
          ],
        ),
      ),
    );
  }
}
