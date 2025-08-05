import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class UserService {
  final Client client = Client()
    ..setEndpoint(
        'https://cloud.appwrite.io/v1') // Replace with your Appwrite endpoint
    ..setProject('6719d1d0001cf69eb622') // Replace with your project ID
    ..setSelfSigned(status: true); // Remove in production

  final Account account;
  final Databases databases;
  static const String databaseId =
      '6719d29f00248a2fe2b7'; // Replace with your database ID
  static const String downloadHistoryCollectionId =
      '682046e50021b8c1ebe9'; // Replace with your collection ID

  UserService()
      : account = Account(Client()
          ..setEndpoint('https://cloud.appwrite.io/v1')
          ..setProject('6719d1d0001cf69eb622')
          ..setSelfSigned(status: true)),
        databases = Databases(Client()
          ..setEndpoint('https://cloud.appwrite.io/v1')
          ..setProject('6719d1d0001cf69eb622')
          ..setSelfSigned(status: true));

  // Create phone session
  // Future<Token> createPhoneSession(String phoneNumber) async {
  //   try {
  //     final session = await account.createPhoneSession(
  //       userId: 'unique()', // Appwrite will generate a unique ID
  //       phone: phoneNumber,
  //     );
  //     return session;
  //   } catch (e) {
  //     throw Exception('Failed to create phone session: $e');
  //   }
  // }

  // Update phone session with OTP
  Future<Session> updatePhoneSession(String userId, String secret) async {
    try {
      final session = await account.updatePhoneSession(
        userId: userId,
        secret: secret,
      );
      return session;
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    try {
      return await account.get();
    } catch (e) {
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await account.deleteSession(sessionId: 'current');
    } catch (e) {
      throw Exception('Failed to sign out: $e');
    }
  }

  // Record a download
  Future<void> recordDownload({
    required String bookTitle,
    required String bookId,
    required String pdfUrl,
  }) async {
    try {
      final user = await getCurrentUser();
      if (user == null) throw Exception('User not logged in');

      // Create document with user ID as part of the document ID for better security
      final documentId = '${user.$id}_${DateTime.now().millisecondsSinceEpoch}';

      // Validate input data
      if (bookTitle.isEmpty || bookId.isEmpty || pdfUrl.isEmpty) {
        throw Exception(
            'Invalid input data: bookTitle, bookId, and pdfUrl are required');
      }

      await databases.createDocument(
        databaseId: databaseId,
        collectionId: downloadHistoryCollectionId,
        documentId: documentId,
        data: {
          'userId': user.$id,
          'bookTitle': bookTitle,
          'bookId': bookId,
          'pdfUrl': pdfUrl,
          'downloadedAt': DateTime.now().toIso8601String(),
        },
        permissions: [
          Permission.read(Role.user(user.$id)),
          Permission.write(Role.user(user.$id)),
        ],
      );
    } catch (e) {
      print('Error recording download: $e'); // For debugging
      throw Exception('Failed to record download: $e');
    }
  }

  // Get download history
  Future<List<Map<String, dynamic>>> getDownloadHistory() async {
    try {
      final user = await getCurrentUser();
      if (user == null) throw Exception('User not logged in');

      final response = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: downloadHistoryCollectionId,
        queries: [
          Query.equal('userId', user.$id),
          Query.orderDesc('downloadedAt'),
        ],
      );

      return response.documents.map((doc) => doc.data).toList();
    } catch (e) {
      print('Error getting download history: $e'); // For debugging
      throw Exception('Failed to get download history: $e');
    }
  }
}
