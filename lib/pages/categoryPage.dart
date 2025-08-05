import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shandynotes/services/book_service.dart';

import '../widgets/appbarWidgets.dart';
import '../widgets/bookCard.dart';
import '../widgets/navigationDrawer.dart';

class BooksByCategoryPage extends StatefulWidget {
  final String categoryName;
  final String bannerUrl =
      'https://fra.cloud.appwrite.io/v1/storage/buckets/book-covers/files/6777eac40025e0fe90b7/view?project=6719d1d0001cf69eb622&mode=admin';

  const BooksByCategoryPage({
    super.key,
    required this.categoryName,
  });

  @override
  _BooksByCategoryPageState createState() => _BooksByCategoryPageState();
}

class _BooksByCategoryPageState extends State<BooksByCategoryPage> {
  late Future<List<Map<String, dynamic>>> booksFuture;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Pagination variables
  List<Map<String, dynamic>> _allBooks = [];
  List<Map<String, dynamic>> _displayedBooks = [];
  bool _isLoading = false;
  bool _hasMoreBooks = true;
  int _currentPage = 0;
  final int _booksPerPage = 14;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInitialBooks();
    // Debug: Print category name
    print('Category page initialized for: ${widget.categoryName}');
  }

  Future<void> _loadInitialBooks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('Loading books for category: ${widget.categoryName}');

      // Try the primary method first
      List<Map<String, dynamic>> books =
          await BookService().fetchBooksByCategory(widget.categoryName);

      // If no books found, try the alternative method
      if (books.isEmpty) {
        print('No books found with primary method, trying alternative...');
        books = await BookService()
            .fetchBooksByCategoryAlternative(widget.categoryName);
      }

      // If still no books, run debug to see all categories
      if (books.isEmpty) {
        print('Still no books found, running debug...');
        await BookService().debugCategories();
      }

      setState(() {
        _allBooks = books;
        print(
            'Loaded ${books.length} books for category: ${widget.categoryName}');

        // If total books are less than or equal to booksPerPage,
        // display all books immediately and don't show "Load More"
        if (books.length <= _booksPerPage) {
          _displayedBooks = books;
          _hasMoreBooks = false;
          _currentPage = 1;
        } else {
          // Otherwise, display first batch and keep "Load More" button
          _displayedBooks = books.sublist(0, _booksPerPage);
          _hasMoreBooks = true;
          _currentPage = 1;
        }

        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading books: $error';
      });
      print('Error loading books: $error');
    }
  }

  void _loadMoreBooks() {
    if (_isLoading || !_hasMoreBooks) return;

    setState(() {
      _isLoading = true;
      _currentPage++;

      final startIndex = (_currentPage - 1) * _booksPerPage;
      final endIndex = startIndex + _booksPerPage;

      // Filter books based on search query if any
      final filteredAllBooks = _filterBooks(_allBooks, _searchQuery);

      if (endIndex >= filteredAllBooks.length) {
        // If we've reached the end of the list
        _displayedBooks = filteredAllBooks;
        _hasMoreBooks = false;
      } else {
        // Add next batch of books
        _displayedBooks = filteredAllBooks.sublist(0, endIndex);
        _hasMoreBooks = true;
      }

      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> _filterBooks(
      List<Map<String, dynamic>> books, String query) {
    if (query.isEmpty) return books;

    return books.where((book) {
      final title = book['title']?.toString().toLowerCase() ?? '';
      final publisher = book['publisher']?.toString().toLowerCase() ?? '';
      final description = book['description']?.toString().toLowerCase() ?? '';

      return title.contains(query) ||
          publisher.contains(query) ||
          description.contains(query);
    }).toList();
  }

  void _performSearch(String query) {
    print('Performing search with query: $query');
    setState(() {
      _searchQuery = query.toLowerCase();
      _currentPage = 0;
      _displayedBooks = [];

      // Apply search filter to all books
      final filteredBooks = _filterBooks(_allBooks, query.toLowerCase());

      // If filtered results fit in one page, show all and hide "Load More"
      if (filteredBooks.length <= _booksPerPage) {
        _displayedBooks = filteredBooks;
        _hasMoreBooks = false;
        _currentPage = 1;
      } else {
        // Otherwise, show first batch and display "Load More" button
        _displayedBooks = filteredBooks.sublist(0, _booksPerPage);
        _hasMoreBooks = true;
        _currentPage = 1;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredBooks = _displayedBooks;

    return Scaffold(
      appBar: const ModernNavBar(),
      endDrawer: MediaQuery.of(context).size.width < 900
          ? const MyNavigationDrawer()
          : null,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Banner Section
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      image: NetworkImage(widget.bannerUrl),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.categoryName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _performSearch,
                    decoration: InputDecoration(
                      hintText: 'Search in ${widget.categoryName}...',
                      prefixIcon: const Icon(Iconsax.search_normal),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading initial data indicator
          if (_allBooks.isEmpty && _isLoading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )

          // Error message
          else if (_errorMessage != null)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
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
                      _errorMessage!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadInitialBooks,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )

          // No books found message
          else if (_allBooks.isEmpty && !_isLoading)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.book_outlined,
                      size: 60,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No notes found in "${widget.categoryName}" category.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Category: ${widget.categoryName}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )

          // No search results message
          else if (filteredBooks.isEmpty && _searchQuery.isNotEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.search_off,
                      size: 60,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No notes found matching "${_searchController.text}"',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        _performSearch('');
                      },
                      child: const Text('Clear Search'),
                    ),
                  ],
                ),
              ),
            )

          // Books Grid
          else
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: _calculateMaxCrossAxisExtent(context),
                  mainAxisExtent: 350,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // negative index - last in first out
                    final book =
                        filteredBooks[filteredBooks.length - 1 - index];

                    //positive indexing
                    //  final book = filteredBooks[index];
                    return BookCard(
                      book: book,
                      onTap: () => context.go('/book/${book['title']}'),
                    );
                  },
                  childCount: filteredBooks.length,
                ),
              ),
            ),

          // Load More Button - only shown if there are more books to load
          if (_hasMoreBooks && _allBooks.length > _booksPerPage)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _loadMoreBooks,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
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
            ),

          // Debug info (remove in production)
          if (_allBooks.isNotEmpty && !_isLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Debug: Found ${_allBooks.length} books in "${widget.categoryName}" category',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  double _calculateMaxCrossAxisExtent(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1100) {
      return screenWidth / 7; // 6 items per row for very large screens
    } else if (screenWidth < 1100 && screenWidth > 810) {
      return screenWidth / 4; // 4 items per row for large screens
    } else if (screenWidth < 810 && screenWidth > 650) {
      return screenWidth / 3; // 3 items per row for medium screens
    } else {
      return screenWidth / 2; // 2 items per row for small screens
    }
  }
}

// Custom painter for decorative pattern
class PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final spacing = size.width / 20;

    for (var i = 0; i < size.width; i += spacing.toInt()) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble() + spacing, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
