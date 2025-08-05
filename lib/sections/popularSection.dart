import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../services/book_service.dart';
import '../widgets/bookCard.dart';

class PopularSectionPage extends StatelessWidget {
  final List<Map<String, dynamic>> books;

  const PopularSectionPage({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    // Filter popular books first
    final popularBooks =
        books.where((book) => book["isPopular"] == true).toList();

    // Shuffle the list each time it's loaded
    popularBooks.shuffle();

    if (popularBooks.isEmpty) {
      return const Center(child: Text('No popular books available.'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth < 730
            ? 2
            : constraints.maxWidth > 730 && constraints.maxWidth < 1100
                ? 4
                : 7; // Responsive columns

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.6,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: popularBooks.length,
          itemBuilder: (context, index) {
            final book = popularBooks[index];
            return BookCard(
              book: book,
              onTap: () => context.go('/book/${book['title']}'),
            );
          },
        );
      },
    );
  }
}

class PopularMainScreen extends StatefulWidget {
  const PopularMainScreen({super.key});

  @override
  _FeaturedMainScreen createState() => _FeaturedMainScreen();
}

class _FeaturedMainScreen extends State<PopularMainScreen> {
  final BookService _bookService = BookService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _bookService.streamBooks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 350,
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                },
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No books found.'));
        }
        return PopularSectionPage(books: snapshot.data!);
      },
    );
  }
}
