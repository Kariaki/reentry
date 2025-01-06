import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:iconsax/iconsax.dart';
import 'package:reentry/core/theme/colors.dart';

import 'dividerv1.dart';

///
class RichTextInputField extends StatelessWidget {
  ///
  const RichTextInputField({
    required this.controller,
    this.showItalicButton = true,
    this.showHeaderStyle = true,
    this.showUnderLineButton = true,
    this.showCodeBlock = true,
    this.showListCheck = true,
    this.showListBullets = true,
    this.showLink = true,
    this.showBoldButton = true,
    super.key,
    this.borderColor,
    this.customButtons,
    this.maxHeight,
    this.maxWidth,
    this.padding,
  });

  ///
  final bool showHeaderStyle;

  ///
  final bool showBoldButton;

  ///
  final bool showItalicButton;

  ///
  final bool showUnderLineButton;

  ///
  final bool showCodeBlock;

  ///
  final bool showListCheck;

  ///
  final bool showListBullets;

  ///
  final bool showLink;

  ///
  final Color? borderColor;

  ///
  final double? maxHeight;

  ///
  final double? maxWidth;

  ///
  final QuillController controller;

  ///
  final List<QuillToolbarCustomButtonOptions>? customButtons;

  ///
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    const surface = AppColors.black;
    final border = borderColor ?? AppColors.inputBorderColor;
    return Theme(
      data: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      child: Container(
        constraints: BoxConstraints(
          minHeight: 52,
          maxHeight: maxHeight ?? 376,
          maxWidth: maxWidth ?? double.infinity,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: border, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: QuillEditor.basic(

                configurations: QuillEditorConfigurations(
                  controller: controller,

                  padding: padding ??
                      const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                  dialogTheme: const QuillDialogTheme(
                    dialogBackgroundColor: surface,

                    inputTextStyle:TextStyle(fontSize: 16,color: AppColors.white)
                  ),
                ),
              ),
            ),
            DividerV1(color: border),
            Padding(
              padding: const EdgeInsets.all(8),
              child: QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  controller: controller,
                  buttonOptions: QuillSimpleToolbarButtonOptions(
                    bold: _buttonOption(Iconsax.text_bold),
                    listBullets: _buttonOption(Icons.list),

                    underLine: _buttonOption(Iconsax.text_underline),
                    italic: _buttonOption(Iconsax.text_italic),

                    linkStyle: const QuillToolbarLinkStyleButtonOptions(
                      iconData: Iconsax.link_21,
                      iconTheme: const QuillIconTheme(
                          iconButtonUnselectedData: IconButtonData(color: AppColors.white)
                      ),
                      iconSize: 12,
                    ),
                  ),
                  showBoldButton: showBoldButton,
                  showUnderLineButton: showUnderLineButton,
                  showCodeBlock: showCodeBlock,

                  showListCheck: showListCheck,
                  showListBullets: showListBullets,
                  showLink: showLink,
                  showItalicButton: showItalicButton,
                  showHeaderStyle: showHeaderStyle,
                  showFontSize: false,
                  showInlineCode: false,
                  showFontFamily: false,
                  showRedo: false,
                  showUndo: false,
                  showDividers: false,
                  showClipboardCopy: false,
                  showClipboardCut: false,
                  showClipboardPaste: false,
                  showLeftAlignment: false,
                  showRightAlignment: false,
                  showCenterAlignment: false,
                  showBackgroundColorButton: false,
                  showListNumbers: false,
                  showStrikeThrough: false,
                  showSubscript: false,
                  showSuperscript: false,
                  showIndent: false,
                  showColorButton: false,
                  showClearFormat: false,
                  showSearchButton: false,
                  showQuote: false,
                  customButtons: customButtons ?? [],
                  color: surface,
                  dialogTheme: const QuillDialogTheme(
                    dialogBackgroundColor: surface,
                      inputTextStyle:TextStyle(fontSize: 16,color: AppColors.white)
                  ),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }

  QuillToolbarToggleStyleButtonOptions _buttonOption(IconData? iconData) {
    return QuillToolbarToggleStyleButtonOptions(
      iconData: iconData,
      iconTheme: const QuillIconTheme(
        iconButtonUnselectedData: IconButtonData(color: AppColors.white)
      ),
      iconSize: 12,
    );
  }
}
