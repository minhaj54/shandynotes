import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String? thumbnail;
  final String? description;
  final double? rating;
  final String? publishedDate;
  final String? previewLink;
  final String? webReaderLink;
  final String? pdfDownloadLink;
  final String? price;
  final bool hasPreview;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    this.thumbnail,
    this.description,
    this.rating,
    this.publishedDate,
    this.previewLink,
    this.webReaderLink,
    this.pdfDownloadLink,
    this.price,
    this.hasPreview = false,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    final saleInfo = json['saleInfo'] ?? {};
    final accessInfo = json['accessInfo'] ?? {};

    return Book(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? 'Unknown Title',
      authors: List<String>.from(volumeInfo['authors'] ?? ['Unknown Author']),
      thumbnail: volumeInfo['imageLinks']?['thumbnail'],
      description: volumeInfo['description'],
      rating: volumeInfo['averageRating']?.toDouble(),
      publishedDate: volumeInfo['publishedDate'],
      previewLink: volumeInfo['previewLink'],
      webReaderLink: accessInfo['webReaderLink'],
      pdfDownloadLink: accessInfo['pdf']?['downloadLink'],
      price: saleInfo['listPrice']?['amount']?.toString(),
      hasPreview: accessInfo['viewability'] == 'PARTIAL' ||
          accessInfo['viewability'] == 'ALL_PAGES',
    );
  }
}

class BookStorePage extends StatefulWidget {
  @override
  _BookStorePageState createState() => _BookStorePageState();
}

class _BookStorePageState extends State<BookStorePage> {
  List<Book> books = [];
  List<Book> filteredBooks = [];
  bool isLoading = false;
  String searchQuery = '';
  String selectedCategory = 'All';
  TextEditingController searchController = TextEditingController();

  final List<String> categories = [
    'All',
    'Fiction',
    'Science',
    'Technology',
    'History',
    'Biography',
    'Romance',
    'Mystery',
    'Fantasy',
    'Self-Help'
  ];

  @override
  void initState() {
    super.initState();
    fetchBooks('flutter programming');
  }

  Future<void> fetchBooks(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://www.googleapis.com/books/v1/volumes?q=$query&maxResults=40'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> items = data['items'] ?? [];

        setState(() {
          books = items.map((item) => Book.fromJson(item)).toList();
          filteredBooks = books;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching books: $e')),
      );
    }
  }

  Future<void> _openBookPDF(Book book) async {
    String? urlToOpen;

    // Priority order for opening books:
    // 1. PDF Download Link (if available)
    // 2. Web Reader Link (Google's web reader)
    // 3. Preview Link (fallback)

    if (book.pdfDownloadLink != null) {
      urlToOpen = book.pdfDownloadLink;
    } else if (book.webReaderLink != null) {
      urlToOpen = book.webReaderLink;
    } else if (book.previewLink != null) {
      urlToOpen = book.previewLink;
    }

    if (urlToOpen != null) {
      try {
        final Uri url = Uri.parse(urlToOpen);
        if (await canLaunchUrl(url)) {
          await launchUrl(
            url,
            mode: LaunchMode
                .externalApplication, // This opens in browser/external app
          );
        } else {
          _showErrorSnackBar('Cannot open this book');
        }
      } catch (e) {
        _showErrorSnackBar('Error opening book: $e');
      }
    } else {
      _showErrorSnackBar('No preview available for this book');
    }
  }

  void filterBooks() {
    setState(() {
      filteredBooks = books.where((book) {
        final matchesSearch =
            book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                book.authors.any((author) =>
                    author.toLowerCase().contains(searchQuery.toLowerCase()));

        final matchesCategory = selectedCategory == 'All' ||
            book.title.toLowerCase().contains(selectedCategory.toLowerCase()) ||
            book.description
                    ?.toLowerCase()
                    .contains(selectedCategory.toLowerCase()) ==
                true;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📚 E-Book Store',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchSection(),
          _buildCategoryFilter(),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : _buildBookGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search books...',
                prefixIcon: Icon(Icons.search, color: Colors.indigo),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.indigo, width: 2),
                ),
              ),
              onChanged: (value) {
                searchQuery = value;
                filterBooks();
              },
            ),
          ),
          SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              if (searchController.text.isNotEmpty) {
                fetchBooks(searchController.text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Search', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedCategory = category;
                  filterBooks();
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.indigo[100],
              checkmarkColor: Colors.indigo,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookGrid() {
    if (filteredBooks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.book_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No books found',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (constraints.maxWidth > 600) crossAxisCount = 3;
        if (constraints.maxWidth > 900) crossAxisCount = 4;
        if (constraints.maxWidth > 1200) crossAxisCount = 5;

        return GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 0.65,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: filteredBooks.length,
          itemBuilder: (context, index) {
            return _buildBookCard(filteredBooks[index]);
          },
        );
      },
    );
  }

  Widget _buildBookCard(Book book) {
    return GestureDetector(
      onTap: () => _openBookPDF(book),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                      color: Colors.grey[100],
                    ),
                    child: book.thumbnail != null
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              book.thumbnail!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.book,
                                    size: 48, color: Colors.grey);
                              },
                            ),
                          )
                        : Icon(Icons.book, size: 48, color: Colors.grey),
                  ),
                  // Preview indicator
                  if (book.hasPreview)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Preview',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // PDF indicator
                  if (book.pdfDownloadLink != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'PDF',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      book.authors.join(', '),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (book.rating != null)
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 16),
                              SizedBox(width: 4),
                              Text(
                                book.rating!.toStringAsFixed(1),
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        Icon(
                          Icons.open_in_new,
                          size: 16,
                          color: Colors.indigo,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookDetailPage extends StatelessWidget {
  final Book book;

  BookDetailPage({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: book.thumbnail != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            book.thumbnail!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.book, size: 64, color: Colors.grey),
                        ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'By ${book.authors.join(', ')}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 12),
                      if (book.rating != null)
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < book.rating!.round()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.orange,
                                  size: 20,
                                );
                              }),
                            ),
                            SizedBox(width: 8),
                            Text('${book.rating!.toStringAsFixed(1)}/5'),
                          ],
                        ),
                      SizedBox(height: 12),
                      if (book.publishedDate != null)
                        Text(
                          'Published: ${book.publishedDate}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            if (book.description != null) ...[
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                book.description!.replaceAll(RegExp(r'<[^>]*>'), ''),
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 24),
            ],
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Add to cart functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added to cart!')),
                      );
                    },
                    icon: Icon(Icons.shopping_cart),
                    label: Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Preview functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening preview...')),
                      );
                    },
                    icon: Icon(Icons.preview),
                    label: Text('Preview'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.indigo,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
