import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/report/web/components/report_card.dart';

class ViewReportPage extends StatefulWidget {
  const ViewReportPage({super.key});

  @override
  _ViewReportPageState createState() => _ViewReportPageState();
}

class _ViewReportPageState extends State<ViewReportPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final int itemsPerPage = 5;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          child: Container(
            color: AppColors.greyDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ReportCard(
                  title: "Issue with my parole officer",
                  complainant: "Alec Whitten",
                  complaintDate: "17 Jan 2024",
                  complaintAgainst: "James Felix",
                  complaintAgainstRole: "Parole officer",
                  description:
                      "Like to know the secrets of transforming a 2–14 team into a 3× Super Bowl winning Dynasty? "
                      "Lectus leo massa amet posuere. Malesuada mattis non convallis quisque. "
                      "Libero sit et imperdiet bibendum quisque dictum vestibulum in non.",
                  responses: 2,
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
                const InputField(
                  hint: 'Enter your response here...',
                  radius: 10.0,
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
                        onPressed: () {},
                      ),
                      3.width,
                      CustomIconButton(
                        label: "Respond",
                        backgroundColor: AppColors.white,
                        textColor: AppColors.black,
                        onPressed: () {},
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
  }
}
