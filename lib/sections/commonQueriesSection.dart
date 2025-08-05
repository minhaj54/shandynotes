import 'package:flutter/material.dart';

class CommonQueries extends StatefulWidget {
  const CommonQueries({super.key});

  @override
  State<CommonQueries> createState() => _CommonQueriesState();
}

class _CommonQueriesState extends State<CommonQueries> {
  // Track which query is expanded
  int? expandedIndex;

  // Sample queries data - you can replace with your actual data
  final List<Map<String, String>> queries = [
    {
      'question': 'What types of notes can I find on Shandy Notes?',
      'answer':
          ' Shandy Notes offers a wide range of notes, including programming, technology, and competitive exams like JEE, NEET, UPSC, and more.',
    },
    {
      'question': 'Are the notes free to access?',
      'answer': 'Yes, here you will find free notes',
    },
    {
      'question': 'Can I upload my own notes to the platform?',
      'answer':
          'No, because if we allow this then the quality of notes can be compromised,',
    },
    {
      'question': 'Can I access Shandy Notes on my mobile device?',
      'answer':
          'Yes, Shandy Notes is fully responsive and works seamlessly on both mobile and desktop devices.',
    },
    {
      'question': 'Do I need to create an account to access the notes?',
      'answer':
          'No, we have created this platform very simple to use, we don\'t want to waste time of users in those authentication process, here just have to come->select notes->download and user will get his notes instantly.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : screenWidth * 0.1,
        vertical: 32,
      ),
      color: Colors.grey[50],
      child: Column(
        children: [
          // Header Section
          Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side content
                Expanded(
                  flex: isMobile ? 1 : 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FAQs',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Find quick answers to common questions about our notes, services etc.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black54,
                            ),
                      ),
                      const SizedBox(height: 32),
                      // Queries List
                      ...List.generate(
                        queries.length,
                        (index) => Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: ExpansionTile(
                              initiallyExpanded: index == expandedIndex,
                              onExpansionChanged: (isExpanded) {
                                setState(() {
                                  expandedIndex = isExpanded ? index : null;
                                });
                              },
                              title: Text(
                                queries[index]['question']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: Icon(
                                expandedIndex == index
                                    ? Icons.remove
                                    : Icons.add,
                                color: Colors.deepPurple,
                              ),
                              backgroundColor: Colors.white,
                              collapsedBackgroundColor: Colors.white,
                              childrenPadding: const EdgeInsets.all(16),
                              children: [
                                Text(
                                  queries[index]['answer']!,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Right side image (hidden on mobile)
                if (!isMobile) ...[
                  const SizedBox(
                    width: 30,
                  ),
                  // Expanded(
                  //   child: Image.network(
                  //     height: 450,
                  //     'https://cloud.appwrite.io/v1/storage/buckets/67aa347e001cffd1d535/files/67ab86a8001ec99a1c37/view?project=6719d1d0001cf69eb622&mode=admin',
                  //     fit: BoxFit.cover,
                  //     errorBuilder: (context, error, stackTrace) {
                  //       return Container(
                  //         color: Colors.grey.shade200,
                  //         child: const Icon(
                  //           Icons.error_outline,
                  //           color: Colors.grey,
                  //           size: 40,
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
