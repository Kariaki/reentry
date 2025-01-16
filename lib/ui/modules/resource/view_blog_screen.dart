import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/blog_dto.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/quill_text.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';

class ViewBlogScreen extends StatelessWidget {
  final BlogDto data;

  const ViewBlogScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.black,
        appBar: CustomAppbar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (data.imageUrl != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: Image.network(
                    data.imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
                10.height,
              ],
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  data.title,
                  style: TextStyle(color: AppColors.white, fontSize: 20),
                ),
              ),
              10.height,
           Padding(padding: EdgeInsets.symmetric(horizontal: 10),
           child:    QuillTextView(
               text: data.content.map((e) => jsonEncode(e)).toList()),)
            ],
          ),
        ));
  }
}
