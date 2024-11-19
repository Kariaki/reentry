import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/theme/colors.dart';
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
      return blog.title.toLowerCase().contains(_searchQuery) ||
          blog.author.toLowerCase().contains(_searchQuery);
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
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 4;
    if (screenWidth < 1200) crossAxisCount = 4;
    if (screenWidth < 900) crossAxisCount = 3;
    if (screenWidth < 600) crossAxisCount = 2;

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
                  preffixIcon: SvgPicture.asset(Assets.search),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CustomIconButton(
                backgroundColor: AppColors.white,
                textColor: AppColors.black,
                icon: Assets.svgAddOutline,
                onPressed: () {
                  Beamer.of(context).beamToNamed('/blog/create');
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
                  final paginatedBlogs = getPaginatedItems(filteredBlogs);
                  final totalPages =
                      (filteredBlogs.length / itemsPerPage).ceil();

                  if (filteredBlogs.isEmpty) {
                    return const Center(
                      child: Text('No blogs match your search query.'),
                    );
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 30.0,
                            mainAxisSpacing: 40.0,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: paginatedBlogs.length,
                          itemBuilder: (context, index) {
                            final blog = paginatedBlogs[index];
                            return GestureDetector(
                              onTap: () {
                                Beamer.of(context).beamToNamed(
                                  '/blog/details',
                                  data: {
                                    'title': blog.title ?? '',
                                    'content': blog.content ?? '',
                                    'imageUrl': blog.imageUrl ?? '',
                                    'author': blog.userId ?? '',
                                    // 'date': blog.date ?? '',
                                  },
                                  
                                );
                              },
                              child: BlogCard(
                                author: blog.userId ?? '',
                                date: blog.userId ?? '',
                                title: blog.title ?? '',
                                description: blog.content ?? '',
                                link: blog.url ?? '',
                                imageUrl: blog.imageUrl ?? '',
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Pagination(
                        totalPages: totalPages,
                        currentPage: currentPage,
                        onPageSelected: setPage,
                      ),
                    ],
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
