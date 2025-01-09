import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/routes/routes.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/blog_dto.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/pagination.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_cubit.dart';
import 'package:reentry/ui/modules/blog/bloc/blog_state.dart';
import 'package:reentry/ui/modules/blog/web/component/blog_card.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';

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

  List<dynamic> filterBlogs(List<dynamic> blogList) {
    if (_searchQuery.isEmpty) {
      return blogList;
    }
    return blogList.where((blog) {
      return blog.title.toLowerCase().contains(_searchQuery);
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
                  "Search",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.greyWhite,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                InputField(
                  controller: _searchController,
                  hint: 'Enter title or author to search',
                  radius: 10.0,
                  preffixIcon: Icon(CupertinoIcons.search),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CustomIconButton(
                backgroundColor: AppColors.white,
                textColor: AppColors.black,
                icon: Assets.svgAddOutline,
                onPressed: () {
                  context.goNamed(
                    AppRoutes.createBlog.name,
                  );
                },
                label: 'Add Resources',
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<BlogCubit, BlogCubitState>(
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
                  final filteredBlogs = filterBlogs(state.data);

                  if (filteredBlogs.isEmpty) {
                    return const Center(
                      child: Text('No blogs match your search query.'),
                    );
                  }
                  return Container(
                    width: 500,
                    child: ListView.builder(
                      itemCount: filteredBlogs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final blog = filteredBlogs[index] as BlogDto;
                        return GestureDetector(
                          onTap: () {
                            context.read<BlogCubit>().selectBlog(blog);
                            context.goNamed(AppRoutes.blogDetails.name,
                                extra: blog.id);
                          },
                          child: BlogCard(
                            author: blog.authorName ?? '',
                            date: blog.dateCreated ?? '',
                            title: blog.title ?? '',
                            description: '',
                            link: blog.url ?? '',
                            imageUrl: blog.imageUrl ?? '',
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
