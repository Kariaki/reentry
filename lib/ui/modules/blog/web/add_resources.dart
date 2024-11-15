import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_bloc.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_event.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_state.dart';
import 'package:reentry/ui/modules/blog/web/component/cover_image_uploader.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';

class AddResourcesPage extends StatefulWidget {
  const AddResourcesPage({super.key});

  @override
  _AddResourcesPageState createState() => _AddResourcesPageState();
}

class _AddResourcesPageState extends State<AddResourcesPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  File? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is CreateBlogContentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Blog created successfully!')),
          );
           Beamer.of(context).beamToNamed('/blog');
        } else if (state is BlogError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      },
      builder: (context, state) {
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
                      "Add Blog",
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: AppColors.greyWhite,
                        fontWeight: FontWeight.w700,
                      ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add resource",
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: AppColors.greyWhite,
                      fontWeight: FontWeight.w400,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 20),
                  InputField(
                    controller: _titleController,
                    hint: 'Title',
                    radius: 10.0,
                  ),
                  const SizedBox(height: 10),
                  InputField(
                    controller: _linkController,
                    hint: 'Link',
                    radius: 10.0,
                  ),
                  const SizedBox(height: 10),
                  InputField(
                    controller: _contentController,
                    hint: 'Start typing here',
                    radius: 10.0,
                    maxLines: 10,
                    lines: 6,
                  ),
                  const SizedBox(height: 40),
                  CoverImageUploader(
                    onFileSelected: (fileName, fileBytes) {
                      if (fileBytes != null) {
                        final tempDir = Directory.systemTemp;
                        final tempFile = File('${tempDir.path}/$fileName');
                        tempFile.writeAsBytesSync(fileBytes);

                        setState(() {
                          _selectedFile = tempFile;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: state is BlogLoading
                        ? const CircularProgressIndicator()
                        : CustomIconButton(
                            backgroundColor: AppColors.white,
                            textColor: AppColors.black,
                            onPressed: () {
                              if (_titleController.text.isEmpty ||
                                  _contentController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Title and content are required!'),
                                  ),
                                );
                                return;
                              }

                              context.read<BlogBloc>().add(
                                    CreateBlogEvent(
                                      title: _titleController.text,
                                      content: _contentController.text,
                                      file: _selectedFile,
                                      link: _linkController.text,
                                    ),
                                  );
                            },
                            icon: Assets.match,
                            label: 'Add Resource',
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
