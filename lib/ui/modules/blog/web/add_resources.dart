import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/blog_dto.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_bloc.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_cubit.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_event.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_state.dart';
import 'package:reentry/ui/modules/blog/web/component/cover_image_uploader.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

class AddResourcesPage extends StatefulWidget {
  final String? editBlogId;
  final BlogDto? blog;

  const AddResourcesPage({super.key, this.editBlogId, this.blog});

  @override
  _AddResourcesPageState createState() => _AddResourcesPageState();
}

class _AddResourcesPageState extends State<AddResourcesPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
    if (widget.editBlogId != null) {
      final currentBlog = context.read<BlogCubit>().state.currentBlog;
      if (currentBlog != null) {
        _titleController.text = currentBlog.title;
        _contentController.text = currentBlog.content;
        _linkController.text = currentBlog.url ?? '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.editBlogId != null;

    if (isEditing) {
      return BlocConsumer<BlogCubit, BlogCubitState>(
        listener: (context, cubitState) {
          if (cubitState.state is CubitStateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Blog updated successfully!')),
            );
            Beamer.of(context).beamToNamed('/blog');
          }
          if (cubitState.state is CubitStateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error: ${(cubitState.state as CubitStateError).message}',
                ),
              ),
            );
          }
        },
        builder: (context, cubitState) {
          if (cubitState.state is CubitStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final currentBlog = cubitState.currentBlog;
          if (currentBlog != null) {
            _titleController.text = currentBlog.title;
            _contentController.text = currentBlog.content;
            _linkController.text = currentBlog.url ?? '';
          }
          return _buildForm(context, isEditing);
        },
      );
    } else {
      return BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is CreateBlogContentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Blog created successfully!')),
            );
            Beamer.of(context).beamToNamed('/blog');
          }
          if (state is BlogError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildForm(context, isEditing);
        },
      );
    }
  }

  Widget _buildForm(BuildContext context, bool isEditing) {
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
                  isEditing ? "Edit Blog" : "Add Blog",
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
              if (!isEditing)
               CoverImageUploader(
  onFileSelected: (fileName, fileBytes) {
    if (fileBytes != null) {
      try {
        // Save the file to a temporary directory
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/$fileName');
        tempFile.writeAsBytesSync(fileBytes);

        // Debugging
        print("Temporary file created at: ${tempFile.path}");

        // Update state with the selected file
        setState(() {
          _selectedFile = tempFile;
        });
      } catch (e) {
        print("Error saving file: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save file: $e')),
        );
      }
    } else {
      print("No file selected or file bytes are null.");
    }
  },
),

              const SizedBox(height: 40),
              Center(
                child: CustomIconButton(
                  backgroundColor: AppColors.white,
                  textColor: AppColors.black,
                  onPressed: () {
                   print(_selectedFile);
                    // if (_titleController.text.isEmpty ||
                    //     _contentController.text.isEmpty) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text('Title and content are required!'),
                    //     ),
                    //   );
                    //   return;
                    // }
                    // if (isEditing) {
                    //   final currentBlog =
                    //       context.read<BlogCubit>().state.currentBlog;
                    //   if (currentBlog != null) {
                    //     context.read<BlogCubit>().editBlog(
                    //           currentBlog.copyWith(
                    //             title: _titleController.text,
                    //             content: _contentController.text,
                    //             url: _linkController.text,
                    //           ),
                    //         );
                    //   }
                    // } else {
                    //   context.read<BlogBloc>().add(
                    //         CreateBlogEvent(
                    //           title: _titleController.text,
                    //           content: _contentController.text,
                    //           file: _selectedFile,
                    //           link: _linkController.text,
                    //         ),
                    //       );
                    // }
                    
                  },
                  icon: isEditing ? Assets.webEdit : Assets.webMatch,
                  label: isEditing ? 'Update Resource' : 'Add Resource',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
