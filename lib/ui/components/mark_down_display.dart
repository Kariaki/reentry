import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:reentry/core/theme/colors.dart';
///
class MarkDownDisplay extends StatelessWidget {
  ///
  const MarkDownDisplay({
    required this.controller,
    super.key,
    this.maxWidth,
    this.constraints,
  });

  ///
  final QuillController controller;

  ///
  final double? maxWidth;

  ///
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      child: ConstrainedBox(
        constraints: constraints ??
            BoxConstraints(
              maxWidth: maxWidth ?? double.infinity,
            ),
        child: QuillEditor.basic(
          focusNode: AlwaysDisabledFocusNode(),
          configurations: QuillEditorConfigurations(
            scrollable: false,
            controller: controller,
          ),
        ),
      ),
    );
  }
}

///
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
