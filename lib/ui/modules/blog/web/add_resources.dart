import 'dart:io';
import 'dart:typed_data';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/blog_dto.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/mark_down_input_field.dart';
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
  final TextEditingController _linkController = TextEditingController();
  final QuillController controller = QuillController.basic();
  Uint8List? _selectedFile;

  @override
  void initState() {
    super.initState();
    if (widget.editBlogId != null) {
      final currentBlog = context.read<BlogCubit>().state.currentBlog;
      if (currentBlog != null) {
        _titleController.text = currentBlog.title;
        controller.setContents(Document.fromJson(currentBlog.content).toDelta());
        _linkController.text = currentBlog.url ?? '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.editBlogId != null;


    return BlocConsumer<BlogBloc, BlogState>(
      listener: (context, state) {
        if(state is UpdateBlogSuccess){

          context.read<BlogCubit>().fetchBlogs();
          context.read<BlogCubit>().selectBlog(state.blog);
          context.pop();
          return;
        }
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

        final currentBlog = context.watch<BlogCubit>().state.currentBlog;
        if (currentBlog != null) {
          _titleController.text = currentBlog.title;
          controller.setContents(Document.fromJson(currentBlog.content).toDelta());
          _linkController.text = currentBlog.url ?? '';
        }
        if (state is BlogLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildForm(context, isEditing);
      },
    );
  }

  Widget _buildForm(BuildContext context, bool isEditing) {
    return Scaffold(
      backgroundColor: AppColors.greyDark,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.height,
              Align(
                alignment: Alignment.centerLeft,
                child:
                Text(
                  isEditing ? "Edit Blog" : "Add Blog",
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.greyWhite,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              30.height,
              InputField(
                controller: _titleController,
                hint: 'Heading',
                radius: 10.0,
              ),
              20.height,
              RichTextInputField(controller: controller),
              40.height,
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
                    if (_titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Title and content are required!'),
                        ),
                      );
                      return;
                    }
                    final currentBlog =
                        context.read<BlogCubit>().state.currentBlog;
                    context.read<BlogBloc>().add(
                      CreateBlogEvent(
                        title: _titleController.text,
                        blogId: currentBlog?.id,
                        content: controller.document.toDelta().toJson(),
                        url: currentBlog?.url,
                        file: _selectedFile,
                      ),
                    );
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
