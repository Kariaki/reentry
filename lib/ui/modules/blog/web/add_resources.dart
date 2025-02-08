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

import '../../../../core/const/app_constants.dart';
import '../../../../core/theme/style/text_style.dart';
import '../../../components/pill_selector_component.dart';

class UpdateBlogEntity {
  final String? editBlogId;
  final BlogDto? blog;

  const UpdateBlogEntity({this.editBlogId, this.blog});
}

class CreateUpdateBlogPage extends StatefulWidget {
  final String? editBlogId;
  final BlogDto? blog;

  const CreateUpdateBlogPage({super.key, this.editBlogId, this.blog});

  @override
  _CreateUpdateBlogPageState createState() => _CreateUpdateBlogPageState();
}

class _CreateUpdateBlogPageState extends State<CreateUpdateBlogPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final QuillController controller = QuillController.basic();
  Uint8List? _selectedFile;

  String? category;

  @override
  void initState() {
    super.initState();
    if (widget.editBlogId != null) {
      final currentBlog = context.read<BlogCubit>().state.currentBlog;
      if (currentBlog != null) {
        _titleController.text = currentBlog.title;

        controller
            .setContents(Document.fromJson(currentBlog.content).toDelta());
        _linkController.text = currentBlog.url ?? '';
      }
    } else {
      context.read<BlogCubit>().selectBlog(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.editBlogId != null;

    return BlocConsumer<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state is UpdateBlogSuccess) {
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
          if (currentBlog.content.isNotEmpty) {
            controller
                .setContents(Document.fromJson(currentBlog.content).toDelta());
          }
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
    final currentBlog = context.read<BlogCubit>().state.currentBlog;
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
                child: Text(
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
                label: "Heading",
                radius: 10.0,
              ),
              20.height,
              Text(
                'Select category',
                style: AppTextStyle.heading
                    .copyWith(color: AppColors.white, fontSize: 14),
              ),
              10.height,
              Wrap(
                children:
                    List.generate(AppConstants.blogCategories.length, (index) {
                  final e = AppConstants.careTeamServices[index];
                  return PillSelectorComponent1(
                      selected: category == (e),
                      text: e,
                      callback: () {
                        setState(() {
                          category = e;
                        });
                      });
                }).toList(),
              ),
              20.height,
              Text(
                'Blog content',
                style: AppTextStyle.heading
                    .copyWith(color: AppColors.white, fontSize: 14),
              ),
              8.height,
              RichTextInputField(controller: controller),
              40.height,
              CoverImageUploader(
                url: currentBlog?.imageUrl,
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
                    if(category==null){
                      return;
                    }
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
                            category: category!,
                            content: controller.document.toDelta().toJson(),
                            url: currentBlog?.imageUrl,
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
