import 'dart:html' as html;
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  BlogPageState createState() => BlogPageState();
}

class BlogPageState extends State<BlogPage> {
  static const String baseUrl =
      'https://v2-embednotion.com/Shandy-Notes-Blog-1f47aeae217a4d5c80e2920f064c93ea';

  // Use late final for values that won't change after initialization
  late final html.IFrameElement _iframe;
  bool _isLoading = true;
  String? _errorMessage;

  // Memoize the URL to prevent unnecessary rebuilds
  late final String _forumUrl =
      '$baseUrl?refresh=${math.Random().nextInt(100000)}';

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _initializeIframe();
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      _iframe.remove();
    }
    super.dispose();
  }

  void _initializeIframe() {
    try {
      _iframe = html.IFrameElement()
        ..src = _forumUrl
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.border = 'none';

      // Use a safer way to handle load events
      _iframe.onLoad.listen(
        (event) {
          if (mounted) {
            setState(() => _isLoading = false);
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Failed to load content';
            });
          }
        },
      );

      // // Register view factory only once during initialization
      // ui.platformViewRegistry.registerViewFactory(
      //   'iframe-${_forumUrl.hashCode}',
      //   (int viewId) => _iframe,
      // );
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to initialize iframe';
      });
    }
  }

  Widget _buildWebContent() {
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    return Stack(
      children: [
        HtmlElementView(
          viewType: 'iframe-${_forumUrl.hashCode}',
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  Widget _buildNonWebContent() {
    return const Center(
      child: Text('WebView not supported on this platform'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Removed elevation for modern flat design
        shadowColor: Colors.black12, // Subtle shadow
        surfaceTintColor: Colors.white,
        title: InkWell(
          onTap: () => context.go('/'),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage(
                        'assets/images/logo.jpg',
                      ),
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black, width: 2)),
              ),
              const SizedBox(width: 20),
              Text(
                "Shandy Notes",
                style: GoogleFonts.kalam(
                  fontSize: isMobile ? 24 : 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ],
          ),
        ),
      ),
      body: kIsWeb ? _buildWebContent() : _buildNonWebContent(),
    );
  }
}
