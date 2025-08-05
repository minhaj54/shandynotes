import 'package:flutter/material.dart';
import 'package:shandynotes/widgets/appbarWidgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../sections/relatedBook.dart';
import '../widgets/navigationDrawer.dart';
import '../widgets/share_button.dart';
// import '../services/user_service.dart';
// import 'login_page.dart';

class EbookDetailPage extends StatefulWidget {
  final Map<String, dynamic> book;

  const EbookDetailPage({
    super.key,
    required this.book,
  });

  @override
  State<EbookDetailPage> createState() => _EbookDetailPageState();
}

class _EbookDetailPageState extends State<EbookDetailPage> {
  int selectedFormat = 0;
  int selectedCoverIndex = 0;
  final PageController _pageController = PageController();
  bool _isDownloading = false;
  List<String> _coverImages = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  void _loadImages() {
    print('Loading images for book: ${widget.book}');
    setState(() {
      _coverImages = [];
      
      // Add cover URL if available
      final coverUrl = widget.book['coverUrl'];
      print('Cover URL: $coverUrl');
      if (coverUrl != null && coverUrl.isNotEmpty) {
        _coverImages.add(coverUrl);
      }

      // Add preview URLs if available (using the correct field names)
      final preview1Url = widget.book['preview1Url']; // Changed from previewUrl1
      print('Preview URL 1: $preview1Url');
      if (preview1Url != null && preview1Url.isNotEmpty) {
        _coverImages.add(preview1Url);
      }

      final preview2Url = widget.book['preview2Url']; // Changed from previewUrl2
      print('Preview URL 2: $preview2Url');
      if (preview2Url != null && preview2Url.isNotEmpty) {
        _coverImages.add(preview2Url);
      }

      print('Final cover images list: $_coverImages');
      // Add default image if no images available
      if (_coverImages.isEmpty) {
        _coverImages.add('https://via.placeholder.com/300x450');
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String formatPrice(dynamic price) {
    if (price == null) return '₹0.00';
    if (price is String) return price;
    if (price is num) {
      return '₹${price.toStringAsFixed(2)}';
    }
    return '₹0.00';
  }

  double calculateDiscountedPrice(
      {required double actualPrice, required double discountPercent}) {
    if (discountPercent < 0 || discountPercent > 100) {
      throw ArgumentError('Discount percent must be between 0 and 100');
    }

    double discountAmount = (actualPrice * discountPercent) / 100;
    return actualPrice - discountAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ModernNavBar(),
      endDrawer: MediaQuery.of(context).size.width < 900
          ? const MyNavigationDrawer()
          : null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 970) {
            return _buildDesktopLayout(context);
          } else if (constraints.maxWidth > 700) {
            return _buildTabletLayout(context);
          }
          return _buildMobileLayout(context);
        },
      ),
    );
  }

  Widget _buildBookCoverSection(BuildContext context, {required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        // Main Image Box
        Container(
          width: isDesktop ? 300 : 200,
          height: isDesktop ? 450 : 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurpleAccent),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              _coverImages[selectedCoverIndex],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading main image: $error');
                return Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.book, size: 80),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Preview Boxes
        SizedBox(
          height: isDesktop ? 150 : 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPreviewBox(0, isDesktop),
              const SizedBox(width: 16),
              _buildPreviewBox(1, isDesktop),
              const SizedBox(width: 16),
              _buildPreviewBox(2, isDesktop),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewBox(int index, bool isDesktop) {
    final bool hasImage = index < _coverImages.length;
    final bool isSelected = selectedCoverIndex == index;
    final String imageUrl = hasImage ? _coverImages[index] : '';
    print('Building preview box $index: hasImage=$hasImage, isSelected=$isSelected, url=$imageUrl');

    return GestureDetector(
      onTap: hasImage ? () {
        print('Tapped preview box $index');
        setState(() {
          selectedCoverIndex = index;
        });
      } : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: isDesktop ? 100 : 80,
        height: isDesktop ? 150 : 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected && hasImage
                ? Colors.deepPurpleAccent
                : Colors.grey[300]!,
            width: isSelected && hasImage ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[100],
          boxShadow: isSelected && hasImage ? [
            BoxShadow(
              color: Colors.deepPurpleAccent.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: hasImage ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading preview image $index: $error');
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.book, size: 24),
                    );
                  },
                ),
              ),
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.deepPurpleAccent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
            ],
          ),
        ) : Center(
          child: Icon(
            Icons.image_not_supported,
            size: 24,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _buildBookHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.book['title'] ?? 'Unknown Title',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            ShareButton(
              bookTitle: widget.book['title'] ?? 'Unknown Title',
              bookAuthor: widget.book['publisher'] ?? 'Unknown Publisher',
              bookUrl:
                  'https://shandynotes.com/#/book/${widget.book['title'].toString().replaceAll(' ', '-')}',
              price: 0.0, // Remove price since it's not part of the new structure
            ),
          ],
        ),
        const SizedBox(height: 4),
        Wrap(
          children: [
            Text(
              'By ${widget.book['publisher'] ?? 'Unknown Publisher'}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Text(
          widget.book['description'] ?? 'No description available.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[700],
                height: 1.6,
              ),
        ),
      ],
    );
  }

  Widget _buildInfoGrid(BuildContext context, {required int crossAxisCount}) {
    final infoItems = [
      {
        'title': 'Publisher',
        'value': widget.book['publisher'] ?? 'Unknown',
        'icon': Icons.business,
      },
      {
        'title': 'Language',
        'value': widget.book['language'] ?? 'Unknown',
        'icon': Icons.language,
      },
      {
        'title': 'Credit Pages',
        'value': widget.book['creditPages']?.toString() ?? '0',
        'icon': Icons.book,
      },
      {
        'title': 'Category',
        'value': widget.book['category'] ?? 'Uncategorized',
        'icon': Icons.category,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: infoItems.length,
      itemBuilder: (context, index) {
        final item = infoItems[index];
        return _buildInfoCard(
          context: context,
          title: item['title'] as String,
          value: item['value'] as String,
          icon: item['icon'] as IconData,
        );
      },
    );
  }

  Widget _buildInfoCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Future<void> _handleDownload() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      final pdfUrl = widget.book['pdfUrl'];
      if (pdfUrl == null || pdfUrl.isEmpty) {
        throw Exception('PDF URL is not available');
      }

      // Launch PDF URL
      final Uri uri = Uri.parse(pdfUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception('Could not launch PDF');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading PDF: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  Widget _buildBuySection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: _isDownloading ? null : _handleDownload,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isDownloading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.download, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  _isDownloading ? 'Downloading...' : 'Download PDF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedBooksSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Related Notes',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        RelatedBookMainScreen(
          category: widget.book['category'] ?? 'Uncategorized',
          selectedBookTitle: widget.book['title'] ?? 'Unknown Title',
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildBookCoverSection(context, isDesktop: true),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBookHeader(context),
                          const SizedBox(height: 24),
                          _buildBuySection(context),
                          const SizedBox(height: 32),
                          _buildDescriptionSection(context),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),
                _buildInfoGrid(context, crossAxisCount: 4),
                const SizedBox(height: 48),
                _buildRelatedBooksSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: _buildBookCoverSection(context, isDesktop: false),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBookHeader(context),
                      const SizedBox(height: 24),
                      _buildBuySection(context),
                      const SizedBox(height: 24),
                      _buildDescriptionSection(context),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildInfoGrid(context, crossAxisCount: 3),
            const SizedBox(height: 32),
            _buildRelatedBooksSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          _buildBookCoverSection(context, isDesktop: false),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBookHeader(context),
                const SizedBox(height: 24),
                _buildBuySection(context),
                const SizedBox(height: 32),
                _buildDescriptionSection(context),
                const SizedBox(height: 32),
                _buildInfoGrid(context, crossAxisCount: 2),
                const SizedBox(height: 32),
                _buildRelatedBooksSection(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
