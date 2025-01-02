import 'dart:io';
import 'dart:typed_data';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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

class UpdateBlogEntity {
  final String? editBlogId;
  final BlogDto? blog;

  const UpdateBlogEntity({this.editBlogId, this.blog});
}

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
  Uint8List? _selectedFile;

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
          final state = cubitState.state;
          if (state is CubitStateSuccess) {
            context.showSnackbarSuccess('Blog updated successfully');
            context.pop();
          }
          if (state is CubitStateError) {
            context.showSnackbarError(state.message);
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
            context.showSnackbarSuccess('Bloc created successfully');

            context.read<BlogCubit>().fetchBlogs();
            context.pop();
            return;
          }
          if (state is BlogError) {
            context.showSnackbarError(state.error);
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
                  onFileSelected: (fileName, fileBytes, path) {
                    if (fileBytes != null) {
                      setState(() {
                        _selectedFile = fileBytes;
                      });
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
                    print(_selectedFile?.lengthInBytes);
                    if (_titleController.text.isEmpty ||
                        _contentController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Title and content are required!'),
                        ),
                      );
                      return;
                    }
                    if (isEditing) {
                      final currentBlog =
                          context.read<BlogCubit>().state.currentBlog;
                      if (currentBlog != null) {
                        context.read<BlogCubit>().editBlog(
                              currentBlog.copyWith(
                                title: _titleController.text,
                                content: _contentController.text,
                                url: _linkController.text,
                              ),
                            );
                      }
                    } else {
                      context.read<BlogBloc>().add(
                            CreateBlogEvent(
                              title: _titleController.text,
                              content: _contentController.text,
                              file: _selectedFile,
                              link: _linkController.text,
                            ),
                          );
                    }
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
