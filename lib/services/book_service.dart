import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:http/http.dart' as http;

class BookService {
  Client client = Client()
    ..setEndpoint('https://cloud.appwrite.io/v1')
    ..setProject('6719d1d0001cf69eb622');

  late Databases database;

  BookService() {
    database = Databases(client);
  }

  Stream<List<Map<String, dynamic>>> streamBooks() {
    return database.listDocuments(
      databaseId: '6719d29f00248a2fe2b7',
      collectionId: '6820637900012a15a948',
      queries: [
        Query.limit(1000), // Increase limit to get more books
      ],
    ).then((response) {
      final books = response.documents.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        data['\$id'] = doc.$id;
        return data;
      }).toList();

      print('StreamBooks: Total books fetched: ${books.length}');
      // Debug: Print isLatest values
      for (var book in books) {
        print(
            'Book: ${book['title']} - isLatest: ${book['isLatest']} (${book['isLatest'].runtimeType})');
      }

      return books;
    }).asStream();
  }

  // Specific method to fetch only latest books
  Future<List<Map<String, dynamic>>> fetchLatestBooks() async {
    try {
      print('Fetching latest books...');

      final response = await database.listDocuments(
        databaseId: '6719d29f00248a2fe2b7',
        collectionId: '6820637900012a15a948',
        queries: [
          Query.equal('isLatest', true),
          Query.limit(100),
        ],
      );

      print(
          'Latest books query returned: ${response.documents.length} documents');

      final books = response.documents.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        data['\$id'] = doc.$id;
        return data;
      }).toList();

      return books;
    } catch (e) {
      print('Error fetching latest books: $e');
      return [];
    }
  }

  // Alternative method to fetch latest books by getting all and filtering
  Future<List<Map<String, dynamic>>> fetchLatestBooksAlternative() async {
    try {
      print('Fetching all books to filter latest...');

      final response = await database.listDocuments(
        databaseId: '6719d29f00248a2fe2b7',
        collectionId: '6820637900012a15a948',
        queries: [
          Query.limit(1000),
        ],
      );

      print('Total books fetched: ${response.documents.length}');

      final allBooks = response.documents.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        data['\$id'] = doc.$id;
        return data;
      }).toList();

      // Filter for latest books
      final latestBooks = allBooks.where((book) {
        final isLatest = book['isLatest'];
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
      return latestBooks;
    } catch (e) {
      print('Error in alternative fetch latest books: $e');
      return [];
    }
  }

  // Updated fetch books by category with better error handling and debugging
  Future<List<Map<String, dynamic>>> fetchBooksByCategory(
      String category) async {
    try {
      print('Fetching books for category: $category');

      final response = await database.listDocuments(
        databaseId: '6719d29f00248a2fe2b7',
        collectionId: '6820637900012a15a948',
        queries: [
          Query.equal('category', category),
          Query.limit(100), // Add limit to ensure we get results
        ],
      );

      print('Response documents count: ${response.documents.length}');

      final books = response.documents.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        data['\$id'] = doc.$id;
        print('Book found: ${data['title']} - Category: ${data['category']}');
        return data;
      }).toList();

      print('Total books fetched for category "$category": ${books.length}');
      return books;
    } catch (e) {
      print('Error fetching books by category: $e');
      return [];
    }
  }

  // Alternative method to fetch books by category with different query approach
  Future<List<Map<String, dynamic>>> fetchBooksByCategoryAlternative(
      String category) async {
    try {
      print('Alternative fetch for category: $category');

      // First, get all books
      final response = await database.listDocuments(
        databaseId: '6719d29f00248a2fe2b7',
        collectionId: '6820637900012a15a948',
        queries: [
          Query.limit(1000), // Increase limit to get more books
        ],
      );

      print('Total documents fetched: ${response.documents.length}');

      // Then filter by category in code
      final allBooks = response.documents.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        data['\$id'] = doc.$id;
        return data;
      }).toList();

      // Debug: Print all categories found
      final categories = allBooks.map((book) => book['category']).toSet();
      print('All categories found: $categories');

      // Filter books by category (case-insensitive)
      final filteredBooks = allBooks.where((book) {
        final bookCategory = book['category']?.toString().toLowerCase() ?? '';
        final searchCategory = category.toLowerCase();
        print('Comparing: "$bookCategory" with "$searchCategory"');
        return bookCategory == searchCategory;
      }).toList();

      print('Filtered books count: ${filteredBooks.length}');
      return filteredBooks;
    } catch (e) {
      print('Error in alternative fetch: $e');
      return [];
    }
  }

  // Debug method to check all books and their categories
  Future<void> debugCategories() async {
    try {
      final response = await database.listDocuments(
        databaseId: '6719d29f00248a2fe2b7',
        collectionId: '6820637900012a15a948',
        queries: [Query.limit(100)],
      );

      print('=== DEBUG: All Books and Categories ===');
      for (var doc in response.documents) {
        final data = doc.data;
        print('Title: ${data['title']} | Category: ${data['category']}');
      }
      print('=== END DEBUG ===');
    } catch (e) {
      print('Debug error: $e');
    }
  }

  // Fetch categories
  Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response = await database.listDocuments(
        collectionId: 'books-categories',
        databaseId: '6719d29f00248a2fe2b7',
      );

      return response.documents.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        data['\$id'] = doc.$id;
        return data;
      }).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  // Fetch book details
  Future<Map<String, dynamic>?> fetchBookDetails(String title) async {
    try {
      print('Fetching book details for title: $title');
      final response = await database.listDocuments(
        collectionId: '6820637900012a15a948',
        queries: [
          Query.equal('title', title),
        ],
        databaseId: '6719d29f00248a2fe2b7',
      );

      if (response.documents.isEmpty) {
        print('No book found with title: $title');
        return null;
      }

      final doc = response.documents.first;
      final data = Map<String, dynamic>.from(doc.data);
      data['\$id'] = doc.$id;

      // Debug log the entire book data
      print('Book data from Appwrite:');
      data.forEach((key, value) {
        print('$key: $value');
      });

      // Ensure image URLs are properly set
      data['coverUrl'] = data['coverUrl'] ?? '';
      data['previewUrl1'] =
          data['preview1Url'] ?? ''; // Note the field name difference
      data['previewUrl2'] =
          data['preview2Url'] ?? ''; // Note the field name difference

      print('Processed book data:');
      print('Cover URL: ${data['coverUrl']}');
      print('Preview URL 1: ${data['previewUrl1']}');
      print('Preview URL 2: ${data['previewUrl2']}');

      return data;
    } catch (e) {
      print('Error fetching book details: $e');
      rethrow;
    }
  }

  // Search books
  Future<List<Map<String, dynamic>>> searchBooks(String query) async {
    try {
      final response = await database.listDocuments(
        collectionId: '6820637900012a15a948',
        queries: [
          Query.search('title', query),
        ],
        databaseId: '6719d29f00248a2fe2b7',
      );

      return response.documents.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        data['\$id'] = doc.$id;
        return data;
      }).toList();
    } catch (e) {
      print('Error searching books: $e');
      return [];
    }
  }

  static const String baseUrl = 'https://cloud.appwrite.io/v1';

  Future<List<Map<String, dynamic>>> fetchNotesByQuery(String query) async {
    try {
      // Add headers if required by your API
      final headers = {
        'Content-Type': 'application/json',
        // Add any authentication headers if needed
        // 'Authorization': 'Bearer YOUR_TOKEN',
      };

      // Create proper URL with query parameter
      final uri = Uri.parse('$baseUrl/notes').replace(
        queryParameters: {'search': query},
      );

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        // Ensure we're properly handling the JSON response
        final dynamic responseData = json.decode(response.body);

        // Handle different response structures
        List<dynamic> data;
        if (responseData is Map) {
          // If the response is wrapped in an object
          data = responseData['data'] ?? responseData['notes'] ?? [];
        } else if (responseData is List) {
          // If the response is directly an array
          data = responseData;
        } else {
          throw Exception('Unexpected response format');
        }

        // Convert and filter the data
        return data.where((note) {
          // Safely access the title with null checking
          final title = note['title']?.toString().toLowerCase() ?? '';
          final content = note['content']?.toString().toLowerCase() ?? '';
          final searchQuery = query.toLowerCase();

          // Search in both title and content
          return title.contains(searchQuery) || content.contains(searchQuery);
        }).map((note) {
          // Ensure we return a Map<String, dynamic>
          return note is Map<String, dynamic>
              ? note
              : Map<String, dynamic>.from(note);
        }).toList();
      } else {
        throw Exception('Failed to load notes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching notes: $e');
      rethrow; // Rethrow to handle in UI
    }
  }
}
