import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'mark_down_display.dart';
class QuillTextView extends StatelessWidget {
  const QuillTextView({super.key,required this.text});
  final List<String> text;

  @override
  Widget build(BuildContext context) {
    if(text.isEmpty){
      return Text('');
    }
    var textData = text.map((e) {
      return jsonDecode(e) as Map<String, dynamic>;
    }).toList();
    final quillController = quill.QuillController(
      document: quill.Document.fromJson(textData),
      selection: const TextSelection.collapsed(offset: 0),
    );


    return MarkDownDisplay(controller: quillController,
    );
  }
}
