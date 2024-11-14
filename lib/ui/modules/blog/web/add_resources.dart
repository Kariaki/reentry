// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/blog/web/component/blog_card.dart';
import 'package:reentry/ui/modules/blog/web/component/cover_image_uploader.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';

class AddResourcesPage extends StatefulWidget {
  const AddResourcesPage({super.key});

  @override
  _AddResourcesPageState createState() => _AddResourcesPageState();
}

class _AddResourcesPageState extends State<AddResourcesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyDark,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          backgroundColor: AppColors.greyDark,
          flexibleSpace: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Search",
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.greyWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  // controller: _searchController,
                  hint: 'Enter name, email or code to search',
                  radius: 10.0,
                  preffixIcon: SvgPicture.asset(Assets.search),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add resource",
                  style: context.textTheme.bodyLarge?.copyWith(
                      color: AppColors.greyWhite,
                      fontWeight: FontWeight.w400,
                      fontSize: 24)),
              const SizedBox(
                height: 20,
              ),
              const InputField(
                hint: 'Title',
                radius: 10.0,
              ),
              const SizedBox(
                height: 10,
              ),
              const InputField(
                hint: 'Link',
                radius: 10.0,
              ),
              const SizedBox(
                height: 10,
              ),
              const InputField(
                hint: 'Start typing here',
                radius: 10.0,
                maxLines: 10,
                lines: 6,
              ),
              const SizedBox(
                height: 40,
              ),
              CoverImageUploader(
                onFileSelected: (fileName, fileBytes) {
                  if (fileBytes != null) {
                  } else {
                    print("No file selected");
                  }
                },
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: CustomIconButton(
                  backgroundColor: AppColors.white,
                  textColor: AppColors.black,
                  onPressed: () {},
                  icon: Assets.match,
                  label: 'Add Resource',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
