import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/blog_dto.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_cubit.dart';
import 'package:reentry/ui/modules/messaging/components/chat_list_component.dart';
import 'package:reentry/ui/modules/resource/request_a_blog_resource.dart';
import 'package:reentry/ui/modules/resource/view_blog_screen.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

import '../../../../data/enum/account_type.dart';
import '../../../components/scaffold/base_scaffold.dart';
import '../../authentication/bloc/account_cubit.dart';
import '../../blog/bloc/blog_state.dart';

class ResourcesNavigationScreen extends HookWidget {
  const ResourcesNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<BlogCubit>().fetchBlogs();
    }, []);

    final user = context.read<AccountCubit>().state;
    if (user == null) {
      return const SizedBox();
    }
    return BaseScaffold(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('My Resource', style: context.textTheme.titleSmall),
            if (user.accountType == AccountType.citizen)
              InkWell(
                onTap: () {
                  context.push(RequestResourceScreen());
                },
                child: const Icon(
                  Icons.add_circle_sharp,
                  color: AppColors.primary,
                  size: 28,
                ),
              )
          ],
        ),
        20.height,
        Expanded(child:
            BlocBuilder<BlogCubit, BlogCubitState>(builder: (context, state) {
          if (state.state is CubitStateLoading) {
            return LoadingComponent();
          }
          if (state.state is CubitStateSuccess) {
            final data = state.data;
            return RefreshIndicator(
                child: ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return _resourceComponent(data[index]);
                    }),
                onRefresh: () async {
                  await context.read<BlogCubit>().fetchBlogs();
                });
          }
          return ErrorComponent(
            onActionButtonClick: () {
              context.read<BlogCubit>().fetchBlogs();
            },
          );
        }))
      ],
    ));
  }

  /*
  ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: ,
              title: ,
              subtitle: ,
            )
   */
  Widget _resourceComponent(BlogDto data) {
    return Builder(
        builder: (context) => InkWell(
          onTap: (){
            context.push(ViewBlogScreen(data: data));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 64,
                  width: 64,
                  child: Image.network(
                    data.imageUrl ?? data.url ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
                15.width,
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title,
                          style: context.textTheme.bodyMedium,
                          maxLines: 3,
                        ),
                        10.height,
                        Text(
                          data.content,
                          style: context.textTheme.bodyMedium
                              ?.copyWith(color: AppColors.gray2),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
