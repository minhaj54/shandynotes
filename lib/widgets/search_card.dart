import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SimpleSearchCard extends StatefulWidget {
  final String hintText;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool showBorder;

  const SimpleSearchCard({
    super.key,
    this.hintText = 'Search Notes with Sooogle...',
    this.width,
    this.height = 45.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.margin = const EdgeInsets.symmetric(horizontal: 8.0),
    this.showBorder = true,
  });

  @override
  State<SimpleSearchCard> createState() => _SimpleSearchCardState();
}

class _SimpleSearchCardState extends State<SimpleSearchCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Material(
          borderRadius:
              BorderRadius.circular(22.5), // Half of height for pill shape
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _isHovered ? Colors.grey[50] : Colors.white,
              borderRadius: BorderRadius.circular(22.5),
              border: widget.showBorder
                  ? Border.all(
                      color: _isHovered
                          ? theme.primaryColor.withOpacity(0.5)
                          : Colors.grey[300]!,
                      width: _isHovered ? 1.5 : 1.0,
                    )
                  : null,
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
            ),
            child: InkWell(
              onTap: () => context.go('/sooogle'),
              borderRadius: BorderRadius.circular(22.5),
              child: Container(
                padding: widget.padding,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.search_rounded,
                        size: 20,
                        color:
                            _isHovered ? theme.primaryColor : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          color:
                              _isHovered ? Colors.grey[700] : Colors.grey[500],
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        child: Text(
                          widget.hintText,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Compact version for tight spaces
class CompactSearchCard extends StatefulWidget {
  final String? tooltip;
  final double size;

  const CompactSearchCard({
    super.key,
    this.tooltip = 'Search Notes',
    this.size = 40.0,
  });

  @override
  State<CompactSearchCard> createState() => _CompactSearchCardState();
}

class _CompactSearchCardState extends State<CompactSearchCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      message: widget.tooltip ?? 'Search',
      child: Container(
        width: widget.size,
        height: widget.size,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: _isHovered ? Colors.grey[100] : Colors.transparent,
              borderRadius: BorderRadius.circular(widget.size / 2),
              border: Border.all(
                color: _isHovered
                    ? theme.primaryColor.withOpacity(0.3)
                    : Colors.grey[300]!,
                width: 1.0,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(widget.size / 2),
              child: InkWell(
                onTap: () => context.go('/sooogle'),
                borderRadius: BorderRadius.circular(widget.size / 2),
                child: Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: _isHovered ? theme.primaryColor : Colors.grey[600],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Example usage in different navbar scenarios
class NavbarSearchExamples extends StatelessWidget {
  const NavbarSearchExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        title: Row(
          children: [
            // Logo/Brand
            Text(
              'MyApp',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 32),

            // Search card in navbar - takes available space
            Expanded(
              child: SimpleSearchCard(
                hintText: 'Search notes, documents...',
                width: double.infinity,
              ),
            ),

            const SizedBox(width: 16),

            // Other navbar items
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: Colors.grey[700]),
              onPressed: () {},
            ),
            IconButton(
              icon:
                  Icon(Icons.account_circle_outlined, color: Colors.grey[700]),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search Card Variations',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),

            // Different width examples
            Text('Fixed Width (300px):',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SimpleSearchCard(
              width: 300,
              hintText: 'Search with fixed width...',
            ),

            const SizedBox(height: 24),

            Text('Compact Version:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                CompactSearchCard(),
                const SizedBox(width: 16),
                CompactSearchCard(size: 36),
                const SizedBox(width: 16),
                CompactSearchCard(size: 44),
              ],
            ),

            const SizedBox(height: 24),

            Text('No Border Version:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SimpleSearchCard(
              width: 350,
              showBorder: false,
              hintText: 'Search without border...',
            ),

            const SizedBox(height: 24),

            Text('Custom Height:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SimpleSearchCard(
              width: 300,
              height: 38,
              hintText: 'Smaller height...',
            ),
          ],
        ),
      ),
    );
  }
}
