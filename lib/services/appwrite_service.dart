import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';

class AppwriteService {
  static final client = Client()
    ..setEndpoint('https://cloud.appwrite.io/v1') // Fixed endpoint
    ..setProject('6719d1d0001cf69eb622')
    ..setSelfSigned(status: false); // Set to false for production

  static final databases = Databases(client);
  static final storage = Storage(client);

  static const String databaseId = '6719d29f00248a2fe2b7';
  static const String booksCollectionId = '6820637900012a15a948';
  static const String bucketId =
      'books-storage'; // You need to create this bucket in Appwrite Console

  // Create a new book
  static Future<void> createBook(Map<String, dynamic> bookData) async {
    try {
      // Add timestamp
      bookData['createdAt'] = DateTime.now().toIso8601String();
      bookData['updatedAt'] = DateTime.now().toIso8601String();

      await databases.createDocument(
        databaseId: databaseId,
        collectionId: booksCollectionId,
        documentId: ID.unique(),
        data: bookData,
      );
    } catch (e) {
      print('Error creating book: $e');
      throw Exception('Failed to create book: ${_getErrorMessage(e)}');
    }
  }

  // Get all books with proper error handling
  static Future<List<Map<String, dynamic>>> getBooks() async {
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: booksCollectionId,
        queries: [
          Query.orderDesc(
              '\$createdAt'), // Order by creation date, newest first
          Query.limit(100), // Limit to 100 books
        ],
      );

      // Handle null documents list
      if (response.documents.isEmpty) {
        return [];
      }

      return response.documents.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        data['\$id'] = doc.$id;
        data['\$createdAt'] = doc.$createdAt;
        data['\$updatedAt'] = doc.$updatedAt;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting books: $e');
      throw Exception('Failed to get books: ${_getErrorMessage(e)}');
    }
  }

  // Get books by category
  static Future<List<Map<String, dynamic>>> getBooksByCategory(
      String category) async {
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: booksCollectionId,
        queries: [
          Query.equal('category', category),
          Query.orderDesc('\$createdAt'),
          Query.limit(50),
        ],
      );

      if (response.documents.isEmpty) {
        return [];
      }

      return response.documents.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        data['\$id'] = doc.$id;
        data['\$createdAt'] = doc.$createdAt;
        data['\$updatedAt'] = doc.$updatedAt;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting books by category: $e');
      throw Exception(
          'Failed to get books by category: ${_getErrorMessage(e)}');
    }
  }

  // Search books
  static Future<List<Map<String, dynamic>>> searchBooks(
      String searchTerm) async {
    try {
      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: booksCollectionId,
        queries: [
          Query.search('title', searchTerm),
          Query.orderDesc('\$createdAt'),
          Query.limit(50),
        ],
      );

      if (response.documents.isEmpty) {
        return [];
      }

      return response.documents.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        data['\$id'] = doc.$id;
        data['\$createdAt'] = doc.$createdAt;
        data['\$updatedAt'] = doc.$updatedAt;
        return data;
      }).toList();
    } catch (e) {
      print('Error searching books: $e');
      throw Exception('Failed to search books: ${_getErrorMessage(e)}');
    }
  }

  // Get book by ID
  static Future<Map<String, dynamic>?> getBookById(String bookId) async {
    try {
      final response = await databases.getDocument(
        databaseId: databaseId,
        collectionId: booksCollectionId,
        documentId: bookId,
      );

      final data = Map<String, dynamic>.from(response.data);
      data['\$id'] = response.$id;
      data['\$createdAt'] = response.$createdAt;
      data['\$updatedAt'] = response.$updatedAt;
      return data;
    } catch (e) {
      print('Error getting book by ID: $e');
      return null;
    }
  }

  // Update a book
  static Future<void> updateBook(
      String bookId, Map<String, dynamic> bookData) async {
    try {
      // Add update timestamp
      bookData['updatedAt'] = DateTime.now().toIso8601String();

      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: booksCollectionId,
        documentId: bookId,
        data: bookData,
      );
    } catch (e) {
      print('Error updating book: $e');
      throw Exception('Failed to update book: ${_getErrorMessage(e)}');
    }
  }

  // Delete a book
  static Future<void> deleteBook(String bookId) async {
    try {
      // First, get the book to check for file URLs
      final book = await getBookById(bookId);
      if (book != null) {
        // TODO: Delete associated files from storage if they exist
        // You would extract file IDs from URLs and delete them
      }

      await databases.deleteDocument(
        databaseId: databaseId,
        collectionId: booksCollectionId,
        documentId: bookId,
      );
    } catch (e) {
      print('Error deleting book: $e');
      throw Exception('Failed to delete book: ${_getErrorMessage(e)}');
    }
  }

  // Upload file to storage
  static Future<String> uploadFile({
    required String filePath,
    required String fileName,
    String? fileId,
  }) async {
    try {
      final file = InputFile.fromPath(
        path: filePath,
        filename: fileName,
      );

      final response = await storage.createFile(
        bucketId: bucketId,
        fileId: fileId ?? ID.unique(),
        file: file,
      );

      // Return the file URL
      return getFileUrl(response.$id);
    } catch (e) {
      print('Error uploading file: $e');
      throw Exception('Failed to upload file: ${_getErrorMessage(e)}');
    }
  }

  // Upload file from bytes (for web)
  static Future<String> uploadFileFromBytes({
    required Uint8List bytes,
    required String fileName,
    String? fileId,
  }) async {
    try {
      final file = InputFile.fromBytes(
        bytes: bytes,
        filename: fileName,
      );

      final response = await storage.createFile(
        bucketId: bucketId,
        fileId: fileId ?? ID.unique(),
        file: file,
      );

      // Return the file URL
      return getFileUrl(response.$id);
    } catch (e) {
      print('Error uploading file from bytes: $e');
      throw Exception('Failed to upload file: ${_getErrorMessage(e)}');
    }
  }

  // Get file URL
  static String getFileUrl(String fileId) {
    return '${client.endPoint}/storage/buckets/$bucketId/files/$fileId/view?project=${client.config['project']}';
  }

  // Delete file from storage
  static Future<void> deleteFile(String fileId) async {
    try {
      await storage.deleteFile(
        bucketId: bucketId,
        fileId: fileId,
      );
    } catch (e) {
      print('Error deleting file: $e');
      throw Exception('Failed to delete file: ${_getErrorMessage(e)}');
    }
  }

  // Get books statistics
  static Future<Map<String, int>> getBooksStatistics() async {
    try {
      final allBooks = await getBooks();

      final stats = {
        'total': allBooks.length,
        'latest': allBooks.where((book) => book['isLatest'] == true).length,
        'popular': allBooks.where((book) => book['isPopular'] == true).length,
        'categories': allBooks.map((book) => book['category']).toSet().length,
      };

      return stats;
    } catch (e) {
      print('Error getting statistics: $e');
      return {
        'total': 0,
        'latest': 0,
        'popular': 0,
        'categories': 0,
      };
    }
  }

  // Get books by multiple filters
  static Future<List<Map<String, dynamic>>> getFilteredBooks({
    String? category,
    bool? isLatest,
    bool? isPopular,
    String? language,
    int limit = 50,
  }) async {
    try {
      List<String> queries = [
        Query.orderDesc('\$createdAt'),
        Query.limit(limit),
      ];

      if (category != null && category != 'All') {
        queries.add(Query.equal('category', category));
      }

      if (isLatest != null) {
        queries.add(Query.equal('isLatest', isLatest));
      }

      if (isPopular != null) {
        queries.add(Query.equal('isPopular', isPopular));
      }

      if (language != null) {
        queries.add(Query.equal('language', language));
      }

      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: booksCollectionId,
        queries: queries,
      );

      if (response.documents.isEmpty) {
        return [];
      }

      return response.documents.map((doc) {
        final data = Map<String, dynamic>.from(doc.data);
        data['\$id'] = doc.$id;
        data['\$createdAt'] = doc.$createdAt;
        data['\$updatedAt'] = doc.$updatedAt;
        return data;
      }).toList();
    } catch (e) {
      print('Error getting filtered books: $e');
      throw Exception('Failed to get filtered books: ${_getErrorMessage(e)}');
    }
  }

  // Batch operations
  static Future<void> updateMultipleBooks(
    List<String> bookIds,
    Map<String, dynamic> updateData,
  ) async {
    try {
      updateData['updatedAt'] = DateTime.now().toIso8601String();

      for (String bookId in bookIds) {
        await databases.updateDocument(
          databaseId: databaseId,
          collectionId: booksCollectionId,
          documentId: bookId,
          data: updateData,
        );
      }
    } catch (e) {
      print('Error updating multiple books: $e');
      throw Exception(
          'Failed to update multiple books: ${_getErrorMessage(e)}');
    }
  }

  static Future<void> deleteMultipleBooks(List<String> bookIds) async {
    try {
      for (String bookId in bookIds) {
        await deleteBook(bookId);
      }
    } catch (e) {
      print('Error deleting multiple books: $e');
      throw Exception(
          'Failed to delete multiple books: ${_getErrorMessage(e)}');
    }
  }

  // Validate book data
  static Map<String, String> validateBookData(Map<String, dynamic> bookData) {
    Map<String, String> errors = {};

    if (bookData['title'] == null ||
        bookData['title'].toString().trim().isEmpty) {
      errors['title'] = 'Title is required';
    }

    if (bookData['publisher'] == null ||
        bookData['publisher'].toString().trim().isEmpty) {
      errors['publisher'] = 'Publisher is required';
    }

    if (bookData['category'] == null ||
        bookData['category'].toString().trim().isEmpty) {
      errors['category'] = 'Category is required';
    }

    if (bookData['language'] == null ||
        bookData['language'].toString().trim().isEmpty) {
      errors['language'] = 'Language is required';
    }

    if (bookData['description'] == null ||
        bookData['description'].toString().trim().isEmpty) {
      errors['description'] = 'Description is required';
    }

    if (bookData['pages'] != null) {
      final pages = int.tryParse(bookData['pages'].toString());
      if (pages == null || pages <= 0) {
        errors['pages'] = 'Pages must be a positive number';
      }
    }

    // Validate URLs if provided
    if (bookData['pdfUrl'] != null &&
        bookData['pdfUrl'].toString().isNotEmpty) {
      if (!_isValidUrl(bookData['pdfUrl'].toString())) {
        errors['pdfUrl'] = 'Invalid PDF URL format';
      }
    }

    if (bookData['coverUrl'] != null &&
        bookData['coverUrl'].toString().isNotEmpty) {
      if (!_isValidUrl(bookData['coverUrl'].toString())) {
        errors['coverUrl'] = 'Invalid cover image URL format';
      }
    }

    if (bookData['preview1Url'] != null &&
        bookData['preview1Url'].toString().isNotEmpty) {
      if (!_isValidUrl(bookData['preview1Url'].toString())) {
        errors['preview1Url'] = 'Invalid preview image 1 URL format';
      }
    }

    if (bookData['preview2Url'] != null &&
        bookData['preview2Url'].toString().isNotEmpty) {
      if (!_isValidUrl(bookData['preview2Url'].toString())) {
        errors['preview2Url'] = 'Invalid preview image 2 URL format';
      }
    }

    return errors;
  }

  // Create book with validation
  static Future<void> createBookWithValidation(
      Map<String, dynamic> bookData) async {
    final errors = validateBookData(bookData);
    if (errors.isNotEmpty) {
      throw Exception('Validation errors: ${errors.values.join(', ')}');
    }

    await createBook(bookData);
  }

  // Update book with validation
  static Future<void> updateBookWithValidation(
    String bookId,
    Map<String, dynamic> bookData,
  ) async {
    final errors = validateBookData(bookData);
    if (errors.isNotEmpty) {
      throw Exception('Validation errors: ${errors.values.join(', ')}');
    }

    await updateBook(bookId, bookData);
  }

  // Helper method to extract error message
  static String _getErrorMessage(dynamic error) {
    if (error is AppwriteException) {
      return error.message ?? 'Unknown Appwrite error';
    }
    return error.toString();
  }

  // Helper method to validate URL format
  static bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }

  // Check connection to Appwrite
  static Future<bool> checkConnection() async {
    try {
      await databases.listDocuments(
        databaseId: databaseId,
        collectionId: booksCollectionId,
        queries: [Query.limit(1)],
      );
      return true;
    } catch (e) {
      print('Connection check failed: $e');
      return false;
    }
  }

  // Get all categories used in books
  static Future<List<String?>> getUsedCategories() async {
    try {
      final books = await getBooks();
      final categories = books
          .map((book) => book['category']?.toString())
          .where((category) => category != null && category.isNotEmpty)
          .toSet()
          .toList();

      categories.sort();
      return categories;
    } catch (e) {
      print('Error getting used categories: $e');
      return [];
    }
  }

  // Get all languages used in books
  static Future<List<String?>> getUsedLanguages() async {
    try {
      final books = await getBooks();
      final languages = books
          .map((book) => book['language']?.toString())
          .where((language) => language != null && language.isNotEmpty)
          .toSet()
          .toList();

      languages.sort();
      return languages;
    } catch (e) {
      print('Error getting used languages: $e');
      return [];
    }
  }

  // Export books data (for backup purposes)
  static Future<List<Map<String, dynamic>>> exportBooks() async {
    try {
      return await getBooks();
    } catch (e) {
      print('Error exporting books: $e');
      throw Exception('Failed to export books: ${_getErrorMessage(e)}');
    }
  }

  // Import books data (for backup restoration)
  static Future<void> importBooks(List<Map<String, dynamic>> booksData) async {
    try {
      for (final bookData in booksData) {
        // Remove system fields
        bookData.remove('\$id');
        bookData.remove('\$createdAt');
        bookData.remove('\$updatedAt');

        await createBook(bookData);
      }
    } catch (e) {
      print('Error importing books: $e');
      throw Exception('Failed to import books: ${_getErrorMessage(e)}');
    }
  }
}
