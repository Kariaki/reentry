import 'package:flutter/material.dart';

class Pagination extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  final ValueChanged<int> onPageSelected;

  const Pagination({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(totalPages, (index) {
        final pageNumber = index + 1;
        return GestureDetector(
          onTap: () => onPageSelected(pageNumber),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            height: 32.0,
            width: 32.0,
            decoration: BoxDecoration(
              color: currentPage == pageNumber
                  ? Colors.transparent
                  : Colors.transparent,
              border: Border.all(
                color: currentPage == pageNumber
                    ? Colors.white
                    : Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(2.5),
            ),
            alignment: Alignment.center,
            child: Text(
              pageNumber.toString(),
              style: TextStyle(
                color: currentPage == pageNumber
                    ? Colors.white
                    : Colors.grey,
              ),
            ),
          ),
        );
      }),
    );
  }
}
