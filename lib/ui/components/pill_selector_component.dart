import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/style/text_style.dart';

class PillSelector extends HookWidget {
  final List<String> options;
  final int initialSelectedItemIndex;
  final Function(int) onChange;
  final bool wrap;
  final bool selectable;

  const PillSelector(
      {super.key,
      required this.options,
      required this.onChange,
        this.selectable=true,
      this.wrap = false,
      this.initialSelectedItemIndex = -1});

  @override
  Widget build(BuildContext context) {
    final selectedItemIndex = useState(initialSelectedItemIndex);

    if (wrap) {
      return Wrap(

        children: List.generate(options.length, (index) {
          final e = options[index];
          return PillSelectorComponent1(
              selected: index == selectedItemIndex.value,
              text: e,
              callback: () {
                if(selectable==false){
                  return;
                }
                selectedItemIndex.value = index;
                onChange(index);
              });
        }).toList(),
      );
    }

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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: callback,
        radius: 100,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: ShapeDecoration(
            color: selected ? AppColors.white : AppColors.gray1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
          ),
          alignment: Alignment.center,
          child: Text(
            text.capitalizeFirst().replaceAll('_', ' '),
            style: AppTextStyle.buttonText.copyWith(
                color: selected ? AppColors.black : AppColors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class PillSelectorComponent1 extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback callback;
  const PillSelectorComponent1(
      {super.key,
      required this.text,
      this.selected = false,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7.5),
        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
        decoration: ShapeDecoration(
          color: selected ? AppColors.white : AppColors.black,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 1,
                color: selected ? Colors.transparent : Color(0x4C1A1A1A)),
            borderRadius: BorderRadius.circular(142),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: !selected ? Colors.white : Colors.black,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
class PillSelectorComponent2 extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback callback;
  const PillSelectorComponent2(
      {super.key,
      required this.text,
      this.selected = false,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7.5),
        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
        decoration: ShapeDecoration(
          color: selected ? AppColors.white :Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                width: 1,
                color: selected ? Colors.transparent :
            AppColors.white),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: !selected ? Colors.white : Colors.black,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
