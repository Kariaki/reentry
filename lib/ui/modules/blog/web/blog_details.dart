import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_cubit.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_state.dart';

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
      ),
      backgroundColor: AppColors.greyDark,
      body: BlocBuilder<BlogCubit, BlogCubitState>(
        builder: (context, _state) {
          final currentBlog = _state.currentBlog;
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(currentBlog!.imageUrl ?? '',
                      fit: BoxFit.cover),
                  const SizedBox(height: 20),
                  Text(
                    currentBlog.title,
                    style: context.textTheme.bodyLarge?.copyWith(
                        color: AppColors.greyWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    currentBlog.content,
                    style: context.textTheme.bodyLarge?.copyWith(
                        color: AppColors.greyWhite,
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
