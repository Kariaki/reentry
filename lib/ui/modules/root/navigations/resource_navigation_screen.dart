import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
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

import '../../../../core/const/app_constants.dart';
import '../../../../data/enum/account_type.dart';
import '../../../components/input/input_field.dart';
import '../../../components/pill_selector_component.dart';
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

    final _searchController = useTextEditingController();
    final category = useState('All');
    final user = context.read<AccountCubit>().state;
    if (user == null) {
      return const SizedBox();
    }
    return BaseScaffold(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.height,
        InputField(
          controller: _searchController,
          hint: 'Enter name or email to search',
          radius: 10.0,
          onChange: (value) {
            context.read<BlogCubit>().search(value);
          },
          preffixIcon: const Icon(
            CupertinoIcons.search,
            color: AppColors.white,
          ),
        ),
        10.height,
        Align(
          alignment: Alignment.centerLeft,
          child: SizedBox(
            height: 45,
            child: ListView(
              padding: const EdgeInsets.all(0),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: List.generate(AppConstants.blogCategories.length + 1,
                  (index) {
                String e = 'All';
                if (index > 0) {
                  e = AppConstants.careTeamServices[index - 1];
                }
                return PillSelectorComponent1(
                    selected: category.value == (e),
                    text: e,
                    callback: () {
                      category.value = e;
                    });
              }).toList(),
            ),
          ),
        ),
        20.height,
        Expanded(child:
            BlocBuilder<BlogCubit, BlogCubitState>(builder: (context, state) {
          if (state.state is CubitStateLoading) {
            return LoadingComponent();
          }
          if (state.state is CubitStateSuccess) {
            List<BlogDto> data = state.data;
            if (category.value != 'All') {
              data = state.data
                  .where((e) =>
                      e.category
                          ?.toLowerCase()
                          .contains(category.value.toLowerCase()) ??
                      false)
                  .toList();
            }
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
    final doc = Document.fromJson(data.content).toPlainText();
    return Builder(
        builder: (context) => InkWell(
              onTap: () {
                context.pushRoute(ViewBlogScreen(data: data));
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
                          doc,
                          style: context.textTheme.bodyMedium
                              ?.copyWith(color: AppColors.gray2),
                          maxLines: 2,
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
