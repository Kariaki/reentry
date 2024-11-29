import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/modules/appointment/component/table.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';

class AcitivityPage extends StatefulWidget {
  const AcitivityPage({super.key});

  @override
  _AcitivityPageState createState() => _AcitivityPageState();
}

class _AcitivityPageState extends State<AcitivityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyDark,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          backgroundColor: AppColors.greyDark,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Activities",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.greyWhite,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ActivitiesTable(),
              30.height,
              SizedBox(
                width: double.infinity,
                child: CustomIconButton(
                    backgroundColor: AppColors.greyDark,
                    textColor: AppColors.white,
                    label: "Create a new activity",
                    borderColor: AppColors.white,
                    onPressed: () {
                      Beamer.of(context).beamToNamed('/activities/create');
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ActivitiesTable extends StatelessWidget {
  const ActivitiesTable({super.key});

  @override
  Widget build(BuildContext context) {
    final columns = [
      const DataColumn(label: TableHeader("Activity")),
      const DataColumn(label: TableHeader("Date created")),
      const DataColumn(label: TableHeader("Streak")),
      const DataColumn(label: Text("")),
    ];

    final rows = _buildRows(context);

    return Container(
      color: AppColors.greyDark,
      child: ReusableTable(
        columns: columns,
        rows: rows,
        headingRowColor: AppColors.white,
        dataRowColor: Colors.grey[900],
        columnSpacing: 20.0,
        dataRowHeight: 56.0,
      ),
    );
  }

  List<DataRow> _buildRows(BuildContext context) {
    final data = [
      {
        'goal': 'Read a book',
        'dateCreated': '22 Jan 2022',
        'progress': 60,
        'streak': '13%',
        'endDate': '22 Jan 2022',
      },
      {
        'goal': 'Lose 10 pounds',
        'dateCreated': '20 Jan 2022',
        'progress': 72,
        'streak': '13%',
        'endDate': '20 Jan 2022',
      },
      {
        'goal': 'Run a marathon',
        'dateCreated': '28 Jan 2022',
        'progress': 66,
        'streak': '13%',
        'endDate': '28 Jan 2022',
      },
    ];

    return data.map((item) {
      return DataRow(cells: [
        DataCell(Text(item['goal'] as String,
            style: const TextStyle(color: Colors.white))),
        DataCell(Text(item['dateCreated'] as String,
            style: const TextStyle(color: Colors.white))),
        DataCell(Row(
          children: [
            Text(item['streak'] as String,
                style: const TextStyle(color: Colors.white)),
            SvgPicture.asset(Assets.streak),
          ],
        )),
        DataCell(
          Row(
            children: [
              IconButton(
                icon:
                    const Icon(Icons.edit_outlined, color: AppColors.hintColor),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ]);
    }).toList();
  }
}
