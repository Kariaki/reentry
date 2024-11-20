import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_cubit.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_state.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';

class BlogDetailsPage extends StatelessWidget {
  final String blogId;

  const BlogDetailsPage({super.key, required this.blogId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greyDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.greyWhite),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          CustomIconButton(
            icon: Assets.edit,
            label: "Edit",
            onPressed: () {
              final currentBlog = context.read<BlogCubit>().state.currentBlog;
              if (currentBlog != null) {
                context.read<BlogCubit>().selectBlog(currentBlog);
                Beamer.of(context)
                    .beamToNamed('/blog/edit/${currentBlog.id}');
              }
            },
            backgroundColor: AppColors.white,
            textColor: AppColors.greyDark,
          ),
          const SizedBox(width: 10),
          CustomIconButton(
            icon: Assets.delete,
            label: "Delete",
            onPressed: () {
              deleteBlog(context, () {
                final currentBlog = context.read<BlogCubit>().state.currentBlog;
                if (currentBlog != null) {
                  context.read<BlogCubit>().deleteBlog(currentBlog);
                  Navigator.pop(context);
                }
              });
            },
            backgroundColor: AppColors.red,
            textColor: AppColors.white,
          ),
          const SizedBox(width: 10),
        ],
      ),
      backgroundColor: AppColors.greyDark,
      body: BlocBuilder<BlogCubit, BlogCubitState>(
        builder: (context, _state) {
          final currentBlog = _state.currentBlog;
          if (_state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (_state.isError) {
            return Center(
              child: Text(
                _state.errorMessage,
                style: const TextStyle(color: AppColors.red),
              ),
            );
          }
          if (currentBlog == null) {
            return const Center(
              child: Text(
                'No blog found',
                style: TextStyle(color: AppColors.greyWhite),
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(currentBlog.imageUrl ?? '', fit: BoxFit.cover),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    currentBlog.title,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: AppColors.greyWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    currentBlog.content,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: AppColors.greyWhite,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void deleteBlog(BuildContext context, void Function() callback) {
    showPlatformDialog(
      context: context,
      builder: (context) => BasicDialogAlert(
        title: const Text("Delete Blog?"),
        content: const Text(
          "Are you sure you want to delete this blog?",
          style: TextStyle(color: AppColors.black),
        ),
        actions: <Widget>[
          BasicDialogAction(
            title: const Text("Yes"),
            onPressed: () {
              context.pop();
              callback();
            },
          ),
          BasicDialogAction(
            title: const Text("Cancel"),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
    );
  }
}
