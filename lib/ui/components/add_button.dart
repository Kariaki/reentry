import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../generated/assets.dart';

class AddButton extends StatelessWidget {
  final Function() onTap;

  const AddButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onTap, icon: SizedBox(
      width: 24,
      height: 24,
      child: SvgPicture.asset(Assets.svgAddButton,),
    ));
  }
}
