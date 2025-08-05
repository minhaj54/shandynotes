import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../services/book_service.dart';
import '../widgets/bookCard.dart';

class LatestSectionPage extends StatelessWidget {
  final List<Map<String, dynamic>> books;

  const LatestSectionPage({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    // Filter latest books with better debugging
    print('Total books received: ${books.length}');

    final latestBooks = books.where((book) {
      final isLatest = book["isLatest"];
      print(
          'Book: ${book['title']} - isLatest: $isLatest (Type: ${isLatest.runtimeType})');

      // Handle different possible values for isLatest
      if (isLatest is bool) {
        return isLatest == true;
      } else if (isLatest is String) {
        return isLatest.toLowerCase() == 'true';
      } else if (isLatest is int) {
        return isLatest == 1;
      }
      return false;
    }).toList();

    print('Latest books found: ${latestBooks.length}');

    // Shuffle the list each time it's loaded
    latestBooks.shuffle();

    if (latestBooks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.new_releases_outlined,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'No latest notes available.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Total notes: ${books.length}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth < 730
            ? 2
            : constraints.maxWidth > 730 && constraints.maxWidth < 1100
                ? 4
                : 7; // Responsive columns
        return Center(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.6,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: latestBooks.length,
            itemBuilder: (context, index) {
              final book = latestBooks[index];
              return BookCard(
                book: book,
                onTap: () => context.go('/book/${book['title']}'),
              );
            },
          ),
        );
      },
    );
  }
}

class LatestMainScreen extends StatefulWidget {
  const LatestMainScreen({super.key});

  @override
  _LatestMainScreenState createState() => _LatestMainScreenState();
}

class _LatestMainScreenState extends State<LatestMainScreen> {
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 60,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.book_outlined,
                  size: 60,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No notes found.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }
        return LatestSectionPage(books: snapshot.data!);
      },
    );
  }
}
