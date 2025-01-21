import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/routes/router.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/quill_text.dart';
import 'package:reentry/ui/dialog/alert_dialog.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_cubit.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_state.dart';
import 'package:reentry/ui/modules/blog/web/add_resources.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

import '../../../../data/enum/account_type.dart';

class BlogDetailsPage extends StatelessWidget {
  final String blogId;

  const BlogDetailsPage({super.key, required this.blogId});

  @override
  Widget build(BuildContext context) {
    final account = context.read<AccountCubit>().state;
    return Scaffold(
      backgroundColor: AppColors.greyDark,
      body: BlocConsumer<BlogCubit, BlogCubitState>(
        listener: (_, cubitstate) {
          final state = cubitstate.state;
          if (state is CubitStateSuccess) {
            context.pop();
          }
        },
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
                20.height,

                if(account?.accountType==AccountType.admin)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomIconButton(
                      icon: Assets.webEdit,
                      label: "Edit",
                      onPressed: () async {
                        final currentBlog =
                            context.read<BlogCubit>().state.currentBlog;
                        if (currentBlog != null) {
                          context.read<BlogCubit>().selectBlog(currentBlog);
                          context.goNamed(AppRoutes.updateBlog.name,
                              extra: UpdateBlogEntity(
                                  editBlogId: blogId, blog: currentBlog));
                        }
                      },
                      backgroundColor: AppColors.white,
                      textColor: AppColors.greyDark,
                    ),
                    10.width,
                    CustomIconButton(
                      icon: Assets.webDelete,
                      label: "Delete",
                      onPressed: () {
                        deleteBlog(context, () {
                          final currentBlog =
                              context.read<BlogCubit>().state.currentBlog;
                          if (currentBlog != null) {
                            context.read<BlogCubit>().deleteBlog(currentBlog);
                            //context.pop();
                          }
                        });
                      },
                      backgroundColor: AppColors.red,
                      textColor: AppColors.white,
                    ),
                    10.width
                  ],
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 350),
                  child: Image.network(currentBlog.imageUrl ?? '',
                      fit: BoxFit.cover),
                ),
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
                Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
                child: QuillTextView(
                    text:
                    currentBlog.content.map((e) => jsonEncode(e)).toList()),),
                20.height,
              ],
            ),
          );
        },
      ),
    );
  }

  void deleteBlog(BuildContext context, void Function() callback) {
    AppAlertDialog.show(context,
        title: "Delete blog?",
        description: "Are you sure you want to delete this blog?",
        action: "Yes", onClickAction: () {
      callback();
    });
  }
}
