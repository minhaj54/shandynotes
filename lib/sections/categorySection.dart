import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shandynotes/services/book_service.dart';
import 'package:shimmer/shimmer.dart';

import '../widgets/categorySectionWidget.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: BookService().fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: Shimmer.fromColors(
                  baseColor: Colors.grey,
                  highlightColor: Colors.white,
                  child: const Wrap(
                    children: [
                      CategorySectionWidget(
                        categoryName: '',
                        imageUrl: '',
                        onTap: null,
                      ),
                      CategorySectionWidget(
                        categoryName: '',
                        imageUrl: '',
                        onTap: null,
                      ),
                      CategorySectionWidget(
                        categoryName: '',
                        imageUrl: '',
                        onTap: null,
                      ),
                      CategorySectionWidget(
                        categoryName: '',
                        imageUrl: '',
                        onTap: null,
                      ),
                      CategorySectionWidget(
                        categoryName: '',
                        imageUrl: '',
                        onTap: null,
                      ),
                      CategorySectionWidget(
                        categoryName: '',
                        imageUrl: '',
                        onTap: null,
                      ),
                      CategorySectionWidget(
                        categoryName: '',
                        imageUrl: '',
                        onTap: null,
                      ),
                    ],
                  )));
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return const Center(child: Text('No categories available'));
        }

        final categories = snapshot.data!;
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return constraints.maxWidth > 600
                ? DesktopView(categories: categories)
                : MobileView(categories: categories);
          },
        );
      },
    );
  }
}

class DesktopView extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const DesktopView({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: categories.map((category) {
          return CategorySectionWidget(
            onTap: () => context.go('/category/${category['category-name']}'),
            // onTap: () => Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => BooksByCategoryPage(
            //         categoryName:
            //             category['category-name'] ?? 'Unknown Category',
            //         bannerUrl: category['bannerUrl']),
            //   ),
            // ),
            imageUrl: category['bannerUrl'] ??
                'https://static.vecteezy.com/system/resources/thumbnails/044/303/796/small/abstract-wrapping-paper-rolling-on-a-black-background-concept-of-gifts-and-celebrations-design-two-rolls-of-decorative-gift-paper-in-motion-video.jpg',
            categoryName: category['category-name'] ?? 'Unknown',
          );
        }).toList(),
      ),
    );
  }
}

class MobileView extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const MobileView({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: categories.map((category) {
          return CategorySectionWidget(
            onTap: () => context.go('/category/${category['category-name']}'),

            // onTap: () => Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => BooksByCategoryPage(
            //         categoryName:
            //             category['category-name'] ?? 'Unknown Category',
            //         bannerUrl: category['bannerUrl']),
            //   ),
            // ),
            imageUrl: category['bannerUrl'] ??
                'https://example.com/default-image.jpg',
            categoryName: category['category-name'] ?? 'Unknown',
          );
        }).toList(),
      ),
    );
  }
}
