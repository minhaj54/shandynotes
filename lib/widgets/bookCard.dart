import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookCard extends StatefulWidget {
  final Map<String, dynamic> book;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    // Reduced card width by 40%
    final cardWidth = isMobile ? screenWidth * 0.27 : 110.0;
    // Height calculated using 9:16 ratio
    final cardHeight = (cardWidth * 16) / 9;

    // Get the cover image URL
    final String? coverUrl = widget.book['coverUrl'] as String?;
    final String? previewUrl1 = widget.book['previewUrl1'] as String?;
    final String? previewUrl2 = widget.book['previewUrl2'] as String?;

    // Create a list of available images
    List<String> images = [
      if (coverUrl != null) coverUrl,
      if (previewUrl1 != null) previewUrl1,
      if (previewUrl2 != null) previewUrl2,
    ];

    final title = widget.book['title']?.toString() ?? 'Untitled';
    final category = widget.book['category']?.toString() ?? "Category";
    final publisher = widget.book['publisher']?.toString() ?? "Publisher";
    final language = widget.book['language']?.toString() ?? "English";
    final description = widget.book['description']?.toString() ?? "";
    final creditPages = widget.book['creditPages']?.toString() ?? "0";
    final pdfUrl = widget.book['pdfUrl']?.toString();

    // formated title for routing
    String encodedTitle = title.replaceAll(" ", "-");

    return MouseRegion(
      onEnter: (_) {
        setState(() => isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap ?? () {
          final title = widget.book['title']?.toString() ?? 'Untitled';
          final encodedTitle = title.replaceAll(" ", "-");
          context.go('/book/$encodedTitle');
        },
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(5),
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: isHovered
                      ? Colors.black.withOpacity(0.15)
                      : Colors.black.withOpacity(0.1),
                  blurRadius: isHovered ? 16 : 8,
                  offset: isHovered ? const Offset(0, 8) : const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Book Cover Image - 80% of height
                Expanded(
                  flex: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(8),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (images.isNotEmpty)
                            Image.network(
                              images[0],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(
                                    Icons.book,
                                    size: 24,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                          else
                            Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.book,
                                size: 24,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Book Details - 20% of height
                Expanded(
                  flex: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        // Title and Category
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.deepPurpleAccent,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text(
                                category,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: Colors.white, fontSize: 6),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Publisher and Arrow
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                publisher,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                color: isHovered
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                Icons.arrow_forward,
                                size: 15,
                                color: isHovered
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                              ),
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
        ),
      ),
    );
  }
}
