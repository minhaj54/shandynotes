import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/book_service.dart';
import '../widgets/bookCard.dart';

class RelatedBookScreen extends StatefulWidget {
  final List<Map<String, dynamic>> books;
  final String category;
  final String selectedBookTitle;

  const RelatedBookScreen({
    super.key,
    required this.books,
    required this.category,
    required this.selectedBookTitle,
  });

  @override
  State<RelatedBookScreen> createState() => _RelatedBookScreenState();
}

class _RelatedBookScreenState extends State<RelatedBookScreen> {
  // Pagination variables
  final int _booksPerPage = 5;
  int _currentPage = 1;
  late List<Map<String, dynamic>> _relatedBooks;
  late List<Map<String, dynamic>> _displayedBooks;
  bool _hasMoreBooks = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeBooks();
  }

  void _initializeBooks() {
    // Filter books to exclude the selected book and match the given category
    _relatedBooks = widget.books
        .where((book) =>
            book["category"] == widget.category &&
            book["title"] != widget.selectedBookTitle)
        .toList();

    // Initialize displayed books
    if (_relatedBooks.length <= _booksPerPage) {
      // If total related books are less than or equal to initial count, show all
      _displayedBooks = List.from(_relatedBooks);
      _hasMoreBooks = false;
    } else {
      // Otherwise show initial count and set flag for "Load More"
      _displayedBooks = _relatedBooks.sublist(0, _booksPerPage);
      _hasMoreBooks = true;
    }
  }

  void _loadMoreBooks() {
    if (_isLoading || !_hasMoreBooks) return;

    setState(() {
      _isLoading = true;

      _currentPage++;

      // Calculate start and end indices for the next batch
      final startIndex = (_currentPage - 1) * _booksPerPage;
      final endIndex = startIndex + _booksPerPage;

      // Check if we've reached the end
      if (endIndex >= _relatedBooks.length) {
        // Add remaining books
        _displayedBooks = List.from(_relatedBooks);
        _hasMoreBooks = false;
      } else {
        // Add next batch of books (keeping the already displayed ones)
        _displayedBooks = _relatedBooks.sublist(0, endIndex);
        _hasMoreBooks = true;
      }

      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_relatedBooks.isEmpty) {
      return const Center(
        child: Text('No related notes found.'),
      );
    }

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth < 730
                ? 2
                : constraints.maxWidth > 730 && constraints.maxWidth < 1000
                    ? 4
                    : 5; // Responsive columns

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
              itemCount: _displayedBooks.length,
              itemBuilder: (context, index) {
                final book = _displayedBooks[index];
                return BookCard(
                  book: book,
                  onTap: () => context.go('/book/${book['title']}'),
                );
              },
            );
          },
        ),

        // Load More Button - only shown if there are more books to load
        if (_hasMoreBooks && _relatedBooks.length > _booksPerPage)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _loadMoreBooks,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Load More',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ),
      ],
    );
  }
}

class RelatedBookMainScreen extends StatefulWidget {
  final String category;
  final String selectedBookTitle;

  const RelatedBookMainScreen({
    super.key,
    required this.category,
    required this.selectedBookTitle,
  });

  @override
  State<RelatedBookMainScreen> createState() => _RelatedBookMainScreenState();
}

class _RelatedBookMainScreenState extends State<RelatedBookMainScreen> {
  late Stream<List<Map<String, dynamic>>> booksStream;

  @override
  void initState() {
    super.initState();
    booksStream = BookService().streamBooks();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: booksStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Notes found.'));
        }
        return RelatedBookScreen(
          books: snapshot.data!,
          category: widget.category,
          selectedBookTitle: widget.selectedBookTitle,
        );
      },
    );
  }
}
