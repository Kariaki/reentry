// ignore_for_file: library_private_types_in_public_api
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/blog/web/component/blog_card.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  _BlogPageState createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  final List<Map<String, String>> blogData = [
    {
      'author': 'Alec Whitten',
      'date': '17 Jan 2024',
      'title': 'Bill Walsh leadership lessons',
      'description':
          'Like to know the secrets of transforming a 2-14 team into a 3x Super Bowl winning Dynasty?',
      'link': '/blog/bill-walsh-leadership-lessons',
      "imageUrl": "assets/images/citiImg.png"
    },
    {
      'author': 'Demi Wilkinson',
      'date': '16 Jan 2024',
      'title': 'PM mental models',
      'description':
          'Mental models are simple expressions of complex processes or relationships.',
      'link': '/blog/pm-mental-models',
      "imageUrl": "assets/images/citiImg.png"
    },
    {
      'author': 'Candice Wu',
      'date': '15 Jan 2024',
      'title': 'What is Wireframing?',
      'description':
          'Introduction to Wireframing and its Principles. Learn from the best in the industry.',
      'link': '/blog/what-is-wireframing',
      "imageUrl": "assets/images/citiImg.png"
    },
    {
      'author': 'Candice Wu',
      'date': '15 Jan 2024',
      'title': 'What is Wireframing?',
      'description':
          'Introduction to Wireframing and its Principles. Learn from the best in the industry.',
      'link': '/blog/what-is-wireframing',
      "imageUrl": "assets/images/citiImg.png"
    },
    {
      'author': 'Demi Wilkinson',
      'date': '16 Jan 2024',
      'title': 'PM mental models',
      'description':
          'Mental models are simple expressions of complex processes or relationships.',
      'link': '/blog/pm-mental-models',
      "imageUrl": "assets/images/citiImg.png"
    },
    {
      'author': 'Alec Whitten',
      'date': '17 Jan 2024',
      'title': 'Bill Walsh leadership lessons',
      'description':
          'Like to know the secrets of transforming a 2-14 team into a 3x Super Bowl winning Dynasty?',
      'link': '/blog/bill-walsh-leadership-lessons',
      "imageUrl": "assets/images/citiImg.png"
    },
    {
      'author': 'Demi Wilkinson',
      'date': '16 Jan 2024',
      'title': 'PM mental models',
      'description':
          'Mental models are simple expressions of complex processes or relationships.',
      'link': '/blog/pm-mental-models',
      "imageUrl": "assets/images/citiImg.png"
    },
    {
      'author': 'Alec Whitten',
      'date': '17 Jan 2024',
      'title': 'Bill Walsh leadership lessons',
      'description':
          'Like to know the secrets of transforming a 2-14 team into a 3x Super Bowl winning Dynasty?',
      'link': '/blog/bill-walsh-leadership-lessons',
      "imageUrl": "assets/images/citiImg.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 4;
    if (screenWidth < 1200) {
      crossAxisCount = 4;
    }
    if (screenWidth < 900) {
      crossAxisCount = 3;
    }
    if (screenWidth < 600) {
      crossAxisCount = 2;
    }
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
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.greyWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InputField(
                  // controller: _searchController,
                  hint: 'Enter name, email or code to search',
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
            const SizedBox(height: 20,),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 30.0,
                  mainAxisSpacing: 40.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: blogData.length,
                itemBuilder: (context, index) {
                  final blog = blogData[index];
                  return BlogCard(
                    author: blog['author']!,
                    date: blog['date']!,
                    title: blog['title']!,
                    description: blog['description']!,
                    link: blog['link']!,
                    imageUrl: blog['imageUrl']!,
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
