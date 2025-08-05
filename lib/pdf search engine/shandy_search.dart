import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:shandynotes/widgets/appbarWidgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/navigationDrawer.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<PDFResult> _results = [];
  bool _isLoading = false;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _hasMoreResults = false;

  // Replace with your own Google API Key and Search Engine ID
  final String apiKey = 'AIzaSyCFV2xooZdAOhlOcW8ayc0luSaDglE6FqI';
  final String searchEngineId = 'c7d8559bc201a420b';

  Future<void> _performSearch(String query, {int startIndex = 1}) async {
    if (query.isEmpty) return;

    setState(() {
      if (startIndex == 1) {
        _results = [];
      }
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final url = Uri.parse('https://www.googleapis.com/customsearch/v1?'
          'key=$apiKey&'
          'cx=$searchEngineId&'
          'q=${Uri.encodeComponent(query)}&'
          'fileType=pdf&'
          'start=$startIndex');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['items'] != null) {
          final List<PDFResult> newResults = [];

          for (var item in data['items']) {
            newResults.add(PDFResult(
              title: item['title'] ?? 'Unknown Title',
              description: item['snippet'] ?? 'No description available',
              url: item['link'] ?? '',
              displayUrl: item['formattedUrl'] ?? item['displayLink'] ?? '',
              fileSize: _extractFileSize(item),
              lastModified: _extractLastModified(item),
            ));
          }

          setState(() {
            if (startIndex == 1) {
              _results = newResults;
            } else {
              _results.addAll(newResults);
            }
            _hasMoreResults = data['queries'].containsKey('nextPage');
            _currentPage = (startIndex / 10).ceil();
          });
        } else {
          setState(() {
            if (startIndex == 1) {
              _errorMessage = 'No results found';
            } else {
              _hasMoreResults = false;
            }
          });
        }
      } else {
        setState(() {
          _errorMessage =
              'Error ${response.statusCode}: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _extractFileSize(Map<String, dynamic> item) {
    try {
      if (item['pagemap'] != null &&
          item['pagemap']['metatags'] != null &&
          item['pagemap']['metatags'].isNotEmpty) {
        final size = item['pagemap']['metatags'][0]['contentLength'] ??
            item['pagemap']['metatags'][0]['content-length'];
        if (size != null) {
          final sizeInt = int.tryParse(size);
          if (sizeInt != null) {
            if (sizeInt < 1024) return '$sizeInt B';
            if (sizeInt < 1024 * 1024)
              return '${(sizeInt / 1024).toStringAsFixed(1)} KB';
            return '${(sizeInt / (1024 * 1024)).toStringAsFixed(1)} MB';
          }
          return size;
        }
      }
    } catch (e) {
      // If there's any error, just return empty string
    }
    return '';
  }

  String _extractLastModified(Map<String, dynamic> item) {
    try {
      if (item['pagemap'] != null &&
          item['pagemap']['metatags'] != null &&
          item['pagemap']['metatags'].isNotEmpty) {
        return item['pagemap']['metatags'][0]['last-modified'] ??
            item['pagemap']['metatags'][0]['lastModified'] ??
            '';
      }
    } catch (e) {
      // If there's any error, just return empty string
    }
    return '';
  }

  void _loadMoreResults() {
    if (!_isLoading && _hasMoreResults) {
      final nextStartIndex = _currentPage * 10 + 1;
      _performSearch(_searchController.text, startIndex: nextStartIndex);
    }
  }

  Future<void> _openPdf(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Could not open the PDF file")));
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive design adjustments
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: const ModernNavBar(),
      endDrawer: MediaQuery.of(context).size.width < 900
          ? const MyNavigationDrawer()
          : null,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _loadMoreResults();
            return true;
          }
          return false;
        },
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
            child: ListView(
              controller: _scrollController,
              children: [
                // Search header with logo and description
                Column(
                  children: [
                    //       SizedBox(
                    //         height: 100,
                    //        child: Image.network(
                    //         'https://fra.cloud.appwrite.io/v1/storage/buckets/67aa347e001cffd1d535/files/67ab85e9003a78202af9/view?project=6719d1d0001cf69eb622&mode=admin',
                    //         fit: BoxFit.cover,
                    //        errorBuilder: (context, error, stackTrace) {
                    //         return Container(
                    //           color: Colors.grey[200],
                    //           child: const Icon(
                    //            Icons.book,
                    //            size: 24,
                    //           color: Colors.grey,
                    //       ),
                    //     );
                    //    },
                    //    ),
                    //  ),
                    const SizedBox(height: 12),
                    Text(
                      "Soooooogle",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Hii I am Sooogle and I can help you to find Notes from the whole Internet!!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Search input
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search Notes...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => _searchController.clear(),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).cardColor,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) =>
                            _performSearch(_searchController.text),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Results area
                if (_isLoading && _results.isEmpty)
                  Center(
                    child: SpinKitRing(
                      color: Theme.of(context).primaryColor,
                      size: 50.0,
                    ),
                  )
                else if (_errorMessage.isNotEmpty && _results.isEmpty)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline,
                            size: 48, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(_errorMessage),
                      ],
                    ),
                  )
                else if (_results.isEmpty)
                  const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Empty state UI (uncomment and fix if needed)
                        // Icon(Icons.search, size: 80, color: Colors.grey),
                        // SizedBox(height: 16),
                        // Text("Search Notes and Start Learning.."),
                      ],
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                        child: Text(
                          "Found ${_results.length} results",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _results.length + (_hasMoreResults ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _results.length) {
                            return Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Center(
                                child: SpinKitThreeBounce(
                                  color: Theme.of(context).primaryColor,
                                  size: 24.0,
                                ),
                              ),
                            );
                          }

                          final result = _results[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 1,
                              ),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => _openPdf(result.url),
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.picture_as_pdf,
                                          color: Colors.red[400],
                                          size: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            result.title,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      result.description,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            result.displayUrl,
                                            style: TextStyle(
                                              color: Colors.green[700],
                                              fontSize: 12,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (result.fileSize.isNotEmpty)
                                          Chip(
                                            label: Text(result.fileSize),
                                            backgroundColor: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1),
                                            labelStyle: TextStyle(fontSize: 12),
                                            padding: EdgeInsets.zero,
                                            visualDensity:
                                                VisualDensity.compact,
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _results.isNotEmpty
          ? FloatingActionButton(
              onPressed: _scrollToTop,
              mini: true, // Now implemented
              child: Icon(Icons.arrow_upward),
            )
          : null,
    );
  }
}

class PDFResult {
  final String title;
  final String description;
  final String url;
  final String displayUrl;
  final String fileSize;
  final String lastModified;

  PDFResult({
    required this.title,
    required this.description,
    required this.url,
    required this.displayUrl,
    required this.fileSize,
    required this.lastModified,
  });
}
