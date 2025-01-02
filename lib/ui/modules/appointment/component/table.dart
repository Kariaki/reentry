import 'package:flutter/material.dart';
import 'package:reentry/core/theme/colors.dart';

class ReusableTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final Color? headingRowColor;
  final Color? dataRowColor;
  final String? userId;
  final double columnSpacing;
  final double dataRowHeight;
  final double headingRowHeight;

  const ReusableTable({
    super.key,
    required this.columns,
    required this.rows,
    this.headingRowColor,
    this.dataRowColor,
    this.userId,
    this.columnSpacing = 20.0,
    this.dataRowHeight = 56.0,
    this.headingRowHeight = 56.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
             constraints: BoxConstraints(
                minWidth: constraints.maxWidth, 
              ),
            child: DataTable(
              columnSpacing: columnSpacing,
              showCheckboxColumn: false,

              headingRowColor: headingRowColor != null
                  ? MaterialStateProperty.all(headingRowColor)
                  : null,
              dataRowColor: dataRowColor != null
                  ? MaterialStateProperty.all(dataRowColor)
                  : null,
              dataRowHeight: dataRowHeight,
              headingRowHeight: headingRowHeight,
              columns: columns,
              rows: rows,
            ),
          ),
        ),
      );
    });
  }
}

class TableHeader extends StatelessWidget {
  final String title;

  const TableHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.greyDark,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
    );
  }
}
