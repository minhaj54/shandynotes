import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shandynotes/widgets/appbarWidgets.dart';

import '../services/book_service.dart';
import '../widgets/bookCard.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final BookService _bookService = BookService();
  String? selectedCategory;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>>? categories;
  Stream<List<Map<String, dynamic>>>? booksStream;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentPage = 0;
  static const int _booksPerPage = 12;
  List<Map<String, dynamic>> _allBooks = [];
  List<Map<String, dynamic>> _displayedBooks = [];
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _initBooksStream();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadCategories() async {
    categories = await _bookService.fetchCategories();
    if (mounted) setState(() {});
  }

  void _initBooksStream() {
    booksStream = _bookService.streamBooks();
  }

  void _filterByCategory(String? category) {
    setState(() {
      selectedCategory = category;
      _currentPage = 0;
      _displayedBooks = [];
      _allBooks = []; // Clear all books when changing category
    });

    // Reset the books stream based on category selection
    if (category != null) {
      booksStream = _bookService.fetchBooksByCategory(category).asStream();
    } else {
      _initBooksStream(); // This should fetch all books without category filter
    }

    if (MediaQuery.of(context).size.width < 900) {
      Navigator.pop(context);
    }
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _currentPage = 0;
      _displayedBooks = [];
    });

    // We'll let the stream builder handle the filtering
    // instead of calling _filterAndDisplayBooks() directly
  }

  void _filterAndDisplayBooks() {
    // Filter books based on search query
    List<Map<String, dynamic>> filteredBooks = _searchQuery.isEmpty
        ? List.from(_allBooks)
        : _allBooks.where((book) {
            final title = book['title']?.toString().toLowerCase() ?? '';
            final publisher = book['publisher']?.toString().toLowerCase() ?? '';
            final description =
                book['description']?.toString().toLowerCase() ?? '';
            return title.contains(_searchQuery) ||
                publisher.contains(_searchQuery) ||
                description.contains(_searchQuery);
          }).toList();

    // Reset displayed books and load first page
    _displayedBooks = [];
    _loadMoreBooksFrom(filteredBooks);
  }

  void _loadMoreBooks() {
    if (_isLoadingMore) return;

    // Filter the books again (in case search has changed)
    List<Map<String, dynamic>> filteredBooks = _searchQuery.isEmpty
        ? List.from(_allBooks)
        : _allBooks.where((book) {
            final title = book['title']?.toString().toLowerCase() ?? '';
            final publisher = book['publisher']?.toString().toLowerCase() ?? '';
            final description =
                book['description']?.toString().toLowerCase() ?? '';
            return title.contains(_searchQuery) ||
                publisher.contains(_searchQuery) ||
                description.contains(_searchQuery);
          }).toList();

    _loadMoreBooksFrom(filteredBooks);
  }

  void _loadMoreBooksFrom(List<Map<String, dynamic>> sourceBooks) {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final startIndex = _displayedBooks.length;
    final endIndex = startIndex + _booksPerPage;

    if (startIndex < sourceBooks.length) {
      final newBooks =
          sourceBooks.skip(startIndex).take(_booksPerPage).toList();
      setState(() {
        _displayedBooks.addAll(newBooks);
        _currentPage++;
        _isLoadingMore = false;
      });
    } else {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Widget _buildLoadMoreButton() {
    // Calculate how many books should be visible after filtering
    List<Map<String, dynamic>> filteredBooks = _searchQuery.isEmpty
        ? _allBooks
        : _allBooks.where((book) {
            final title = book['title']?.toString().toLowerCase() ?? '';
            final publisher = book['publisher']?.toString().toLowerCase() ?? '';
            final description =
                book['description']?.toString().toLowerCase() ?? '';
            return title.contains(_searchQuery) ||
                publisher.contains(_searchQuery) ||
                description.contains(_searchQuery);
          }).toList();

    if (_displayedBooks.length >= filteredBooks.length) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: ElevatedButton(
          onPressed: _isLoadingMore ? null : _loadMoreBooks,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: _isLoadingMore
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Load More',
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search notes...',
          prefixIcon: const Icon(Iconsax.search_normal),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Iconsax.close_circle),
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        onChanged: _performSearch,
      ),
    );
  }

  Widget _buildSidebar(
      BuildContext context, List<Map<String, dynamic>> categories) {
    return Container(
      width: 250,
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(16.0),
            color: Colors.deepPurpleAccent,
            child: Text(
              'Categories',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ListTile(
            title: const Text('All Notes'),
            selectedColor: Colors.deepPurpleAccent,
            selected: selectedCategory == null,
            onTap: () => _filterByCategory(null),
            leading: const Icon(Iconsax.note),
            selectedTileColor: Colors.deepPurpleAccent,
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final categoryName = category['category-name'] ??
                    category['category-name'] ??
                    '';
                return ListTile(
                  selectedColor: Colors.deepPurpleAccent,
                  title: Text(categoryName),
                  selected: selectedCategory == categoryName,
                  selectedTileColor: Colors.deepPurpleAccent,
                  onTap: () => _filterByCategory(categoryName),
                  leading: const Icon(Iconsax.book),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      key: _scaffoldKey,
      appBar: const ModernNavBar(),
      endDrawer: !isDesktop && categories != null
          ? Drawer(
              shape: const RoundedRectangleBorder(),
              child: _buildSidebar(context, categories!),
            )
          : null,
      body: Row(
        children: [
          if (isDesktop && categories != null)
            _buildSidebar(context, categories!),
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              selectedCategory ?? 'All Notes',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildSearchBar(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16.0),
                    sliver: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: booksStream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SliverFillRemaining(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (snapshot.hasError) {
                          return SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.error_outline,
                                      size: 60, color: Colors.red),
                                  const SizedBox(height: 16),
                                  Text('Error: ${snapshot.error}'),
                                ],
                              ),
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Iconsax.book,
                                      size: 60, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text('Coming soon...'),
                                ],
                              ),
                            ),
                          );
                        }

                        // Update our _allBooks whenever new data comes in from the stream
                        _allBooks = snapshot.data!;

                        // If we haven't loaded any books yet, set the initial books
                        // but don't call setState within build as that causes the "build dirty widget" error
                        if (_displayedBooks.isEmpty) {
                          // Apply filter but don't trigger setState during build
                          List<Map<String, dynamic>> filteredBooks =
                              _searchQuery.isEmpty
                                  ? List.from(_allBooks)
                                  : _allBooks.where((book) {
                                      final title = book['title']
                                              ?.toString()
                                              .toLowerCase() ??
                                          '';
                                      final publisher = book['publisher']
                                              ?.toString()
                                              .toLowerCase() ??
                                          '';
                                      final description = book['description']
                                              ?.toString()
                                              .toLowerCase() ??
                                          '';
                                      return title.contains(_searchQuery) ||
                                          publisher.contains(_searchQuery) ||
                                          description.contains(_searchQuery);
                                    }).toList();

                          // Take the first page of books
                          _displayedBooks =
                              filteredBooks.take(_booksPerPage).toList();
                          _currentPage = 1;
                        }

                        // Recompute filtered books based on current search query
                        final filteredBooks = _searchQuery.isEmpty
                            ? _allBooks
                            : _allBooks.where((book) {
                                final title =
                                    book['title']?.toString().toLowerCase() ??
                                        '';
                                final publisher = book['publisher']
                                        ?.toString()
                                        .toLowerCase() ??
                                    '';
                                final description = book['description']
                                        ?.toString()
                                        .toLowerCase() ??
                                    '';
                                return title.contains(_searchQuery) ||
                                    publisher.contains(_searchQuery) ||
                                    description.contains(_searchQuery);
                              }).toList();

                        if (filteredBooks.isEmpty) {
                          return const SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off,
                                      size: 60, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text('No results found'),
                                ],
                              ),
                            ),
                          );
                        }

                        return SliverList(
                          delegate: SliverChildListDelegate([
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithMaxCrossAxisExtent(
                                mainAxisExtent: 350,
                                maxCrossAxisExtent:
                                    _calculateMaxCrossAxisExtent(context),
                                mainAxisSpacing: 8.0,
                                crossAxisSpacing: 8.0,
                              ),
                              itemCount: _displayedBooks.length,
                              itemBuilder: (context, index) {
                                // Using index directly instead of reversed index
                                final book = _displayedBooks[index];

                                return BookCard(
                                  book: book,
                                  onTap: () =>
                                      context.go('/book/${book['title']}'),
                                );
                              },
                            ),
                            _buildLoadMoreButton(),
                          ]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateMaxCrossAxisExtent(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      // Mobile
      return 200; // Adjust for smaller screens
    } else if (screenWidth < 900) {
      // Tablet
      return 220; // Adjust for tablet screens
    } else {
      // Desktop
      return 250; // Adjust for larger screens
    }
  }
}
