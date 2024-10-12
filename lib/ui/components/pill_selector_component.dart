import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/style/text_style.dart';

class PillSelector extends HookWidget {
  final List<String> options;
  final int initialSelectedItemIndex;
  final Function(int) onChange;

  const PillSelector(
      {super.key,
      required this.options,
      required this.onChange,
      this.initialSelectedItemIndex = -1});

  @override
  Widget build(BuildContext context) {
    final selectedItemIndex = useState(initialSelectedItemIndex);
    return Column(
      children: List.generate(options.length, (index) {
        final item = options[index];
        return PillSelectorComponent(
            text: item,
            selected: index == selectedItemIndex.value,
            callback: () {
              selectedItemIndex.value = index;
              onChange(index);
            });
      }),
    );
  }
}

class PillSelectorComponent extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback callback;

  const PillSelectorComponent(
      {super.key,
      required this.text,
      this.selected = false,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(vertical: 10),child: InkWell(
      onTap: callback,
      radius: 100,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: ShapeDecoration(
          color: selected ? AppColors.white : AppColors.gray1,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppTextStyle.buttonText.copyWith(
              color: selected ? AppColors.black : AppColors.white,
              fontWeight: FontWeight.bold),
        ),
      ),
    ),);
  }
}
