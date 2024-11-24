// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/appointment/component/table.dart';

class ReportPage extends StatelessWidget {
  ReportPage({super.key});

  final List<Map<String, String>> data = [
    {"Name": "Alice", "Age": "25", "City": "New York"},
    {"Name": "Bob", "Age": "30", "City": "Los Angeles"},
    {"Name": "Charlie", "Age": "35", "City": "Chicago"},
    {"Name": "Diana", "Age": "28", "City": "Houston"},
    {"Name": "Eve", "Age": "40", "City": "Phoenix"},
  ];
  final TextEditingController _searchController = TextEditingController();

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
                  preffixIcon: SvgPicture.asset(Assets.search),
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
          child: Center(
            child:ReportTable() ),
        ),
      ),
    );
  }



}
  class ReportTable extends StatelessWidget {
  const ReportTable({super.key});

  @override
  Widget build(BuildContext context) {
    final columns = [
      const DataColumn(label: TableHeader("Name")),
      const DataColumn(label: TableHeader("Email")),
      const DataColumn(label: TableHeader("Date")),
      const DataColumn(label: TableHeader("Visit Time")),
      const DataColumn(label: TableHeader("Care Team")),
      const DataColumn(label: Text("Actions")),
    ];

    final rows = _buildRows(context);

    return Container(
      color: Colors.black,
      child: ReusableTable(
        columns: columns,
        rows: rows,
        headingRowColor: AppColors.white,
        dataRowColor: AppColors.greyDark,
        columnSpacing: 20.0,
        dataRowHeight: 56.0,
      ),
    );
  }

  List<DataRow> _buildRows(BuildContext context) {
    final data = [
      {
        'name': 'Leslie Alexander',
        'email': 'leslie.alexander@example.com',
        'date': '10/10/2020',
        'visitTime': '09:15–09:45am',
        'careTeam': 'Jacob Jones',
      },
      {
        'name': 'Ronald Richards',
        'email': 'ronald.richards@example.com',
        'date': '10/12/2020',
        'visitTime': '12:00–12:45pm',
        'careTeam': 'Theresa Webb',
      },
    ];

    return data.map((item) {
      return DataRow(cells: [
        DataCell(Text(item['name'] ?? '')),
        DataCell(Text(item['email'] ?? '')),
        DataCell(Text(item['date'] ?? '')),
        DataCell(Text(item['visitTime'] ?? '')),
        DataCell(Text(item['careTeam'] ?? '')),
        DataCell(
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {},
          ),
        ),
      ]);
    }).toList();
  }
}