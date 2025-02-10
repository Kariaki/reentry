import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/blog_dto.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_cubit.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_state.dart';
import 'package:reentry/ui/modules/blog/web/component/blog_card.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import '../../../../core/const/app_constants.dart';
import '../../../components/pill_selector_component.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final TextEditingController _searchController = TextEditingController();
  final int itemsPerPage = 10;
  int currentPage = 1;
  String _searchQuery = '';
  String category = 'All';

  @override
  void initState() {
    super.initState();
    context.read<BlogCubit>().fetchBlogs();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
        currentPage = 1;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BlogDto> filterBlogs(List<BlogDto> blogList) {
    if (_searchQuery.isEmpty) {
      return blogList;
    }
    return blogList.where((blog) {
      return blog.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (blog.category?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
              false);
    }).toList();
  }

  List<dynamic> getPaginatedItems(List<dynamic> filteredBlogs) {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return filteredBlogs.sublist(
      startIndex,
      endIndex > filteredBlogs.length ? filteredBlogs.length : endIndex,
    );
  }

  void setPage(int pageNumber) {
    setState(() {
      currentPage = pageNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final account = context.read<AccountCubit>().state;
    return Scaffold(
      backgroundColor: AppColors.greyDark,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.goNamed(
              AppRoutes.createBlog.name,
            );
          },
          label: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Resource',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (account?.accountType == AccountType.admin)
              Center(
                child: header(context),
              ),
            10.height,
            InputField(
              controller: _searchController,
              hint: 'Enter name or email to search',
              radius: 10.0,
              onChange: (value) {
                setState(() {
                  _searchQuery = value;
                });
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
                  children: List.generate(
                      AppConstants.blogCategories.length + 1, (index) {
                    String e = 'All';
                    if (index > 0) {
                      e = AppConstants.careTeamServices[index - 1];
                    }
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
              ),
            ),
            20.height,
            Expanded(child: BlocBuilder<BlogCubit, BlogCubitState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.isError) {
                  return Center(
                    child: Text(
                      'Error: ${state.errorMessage}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state.data.isEmpty) {
                  return const Center(
                    child: Text('No blogs available.'),
                  );
                }
                List<BlogDto> filteredBlogs = filterBlogs(state.data);
                if (category != 'All') {
                  filteredBlogs = filterBlogs(state.data)
                      .where((e) =>
                          e.category
                              ?.toLowerCase()
                              .contains(category.toLowerCase()) ??
                          false)
                      .toList();
                }

                if (filteredBlogs.isEmpty) {
                  return const Center(
                    child: Text('No blogs match your search query.'),
                  );
                }
                return SizedBox(
                  // width: 500,
                  child: ListView.builder(
                    itemCount: filteredBlogs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final blog = filteredBlogs[index];
                      final description =
                          quill.Document.fromJson(blog.content).toPlainText();
                      return InkWell(
                        onTap: () {
                          context.read<BlogCubit>().selectBlog(blog);
                          context.goNamed(AppRoutes.blogDetails.name,
                              extra: blog.id);
                        },
                        child: BlogCard(
                          author: blog.authorName ?? '',
                          date: blog.dateCreated ?? '',
                          title: blog.title ?? '',
                          description: description,
                          link: blog.url ?? '',
                          imageUrl: blog.imageUrl ?? '',
                        ),
                      );
                    },
                  ),
                );
              },
            ))
          ],
        ),
      ),
    );
  }

  Widget header(BuildContext context) {
    return SizedBox();
  }
}
