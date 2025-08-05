import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../services/user_service.dart';
import 'bookDetails.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _userService = UserService();
  bool _isLoading = true;
  String? _phoneNumber;
  List<Map<String, dynamic>> _downloadHistory = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _userService.getCurrentUser();
      final history = await _userService.getDownloadHistory();
      if (mounted) {
        setState(() {
          _phoneNumber = user?.phone;
          _downloadHistory = history;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await _userService.signOut();
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurpleAccent,
                    child: Icon(
                      Iconsax.user,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Phone Number',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _phoneNumber ?? 'Not available',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  if (_downloadHistory.isNotEmpty) ...[
                    Text(
                      'Download History',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _buildDownloadHistory(),
                  ] else ...[
                    const Center(
                      child: Column(
                        children: [
                          Icon(
                            Iconsax.document_download,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text('No downloads yet'),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _signOut,
                    icon: const Icon(Iconsax.logout),
                    label: const Text('Sign Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDownloadHistory() {
    if (_downloadHistory.isEmpty) {
      return const Center(
        child: Text('No downloads yet'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _downloadHistory.length,
      itemBuilder: (context, index) {
        final download = _downloadHistory[index];
        final downloadDate = DateTime.parse(download['downloadedAt']);
        final formattedDate = '${downloadDate.day}/${downloadDate.month}/${downloadDate.year}';

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: InkWell(
            onTap: () {
              // Navigate to book details page
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EbookDetailPage(
                    book: {
                      'Title': download['bookTitle'],
                      '\$id': download['bookId'],
                      'pdfFileId': download['pdfUrl'],
                      'Author': 'Shandy Notes',
                      'Description': 'Downloaded on $formattedDate',
                      'coverImages': ['https://via.placeholder.com/150'],
                      'Category': 'Downloaded',
                      'Language': 'English',
                      'Pages': 'N/A',
                      'Publisher': 'Shandy Notes',
                      'Price': '0.00',
                      'comparedPrice': 0.00,
                      'discountPercent': 0.00,
                    },
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.book,
                      size: 40,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          download['bookTitle'] ?? 'Unknown Title',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Downloaded on $formattedDate',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
} 