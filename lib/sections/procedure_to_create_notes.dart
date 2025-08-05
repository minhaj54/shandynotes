import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProcedureToCreateNotes extends StatelessWidget {
  const ProcedureToCreateNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 15),
                child: Text(
                  "How do we create notes? ",
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 24),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildProcedureStep(
                                  stepNumber: 1,
                                  title: 'Understanding the Topic',
                                  description:
                                      'We thoroughly research and analyze the topic to ensure we have a clear understanding of its core concepts etc.',
                                  icon: Icons.app_registration,
                                ),
                                _buildVerticalLine(),
                                _buildProcedureStep(
                                  stepNumber: 2,
                                  title: 'Gathering Reliable Sources',
                                  description:
                                      'Our team curates information from trusted textbooks, academic journals, expert lectures, and other credible resources to ensure accuracy.',
                                  icon: Icons.manage_search,
                                ),
                                _buildVerticalLine(),
                                _buildProcedureStep(
                                  stepNumber: 3,
                                  title: 'Structuring the Content',
                                  description:
                                      'We organize the material into a clear and logical format, breaking it down into chapters, sections, and subtopics for easy navigation.',
                                  icon: Icons.category,
                                ),
                                _buildVerticalLine(),
                                _buildProcedureStep(
                                  stepNumber: 4,
                                  title: 'Writing Simplified Notes',
                                  description:
                                      'We summarize complex information into concise, easy-to-understand points, using simple language without losing the essence.',
                                  icon: Icons.edit_note,
                                ),
                                _buildVerticalLine(),
                                _buildProcedureStep(
                                    stepNumber: 5,
                                    title: 'Adding Visual Aids',
                                    description:
                                        'To enhance understanding, we incorporate diagrams, charts, infographics, and tables wherever necessary.',
                                    icon: Icons.save,
                                    isLastStep: true),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 24),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildVerticalLine(),
                                _buildProcedureStep(
                                  stepNumber: 6,
                                  title: 'Highlighting Key Points',
                                  description:
                                      'Important concepts, definitions, and takeaways are highlighted using bold text, color codes, and icons to make them stand out.',
                                  icon: Icons.highlight,
                                ),
                                _buildVerticalLine(),
                                _buildProcedureStep(
                                  stepNumber: 7,
                                  title: 'Ensuring Clarity and Accuracy',
                                  description:
                                      'Each note undergoes a thorough review to ensure it is free from errors and aligned with the topic’s objective.',
                                  icon: Iconsax.tag_right,
                                ),
                                _buildVerticalLine(),
                                _buildProcedureStep(
                                  stepNumber: 8,
                                  title: 'Organizing by Categories',
                                  description:
                                      'Notes are categorized into relevant sections like Programming, Technology, JEE, NEET and more, so users can easily find what they need.',
                                  icon: Icons.clear_all,
                                ),
                                _buildVerticalLine(),
                                _buildProcedureStep(
                                  stepNumber: 9,
                                  title: 'Regular Updates',
                                  description:
                                      'We periodically update our notes to include the latest information, trends, and discoveries in the field.',
                                  icon: Icons.browser_updated_rounded,
                                ),
                                _buildVerticalLine(),
                                _buildProcedureStep(
                                  stepNumber: 10,
                                  title: 'Feedback Integration',
                                  description:
                                      'We listen to user feedback to improve and refine our notes, ensuring they are always user-friendly and comprehensive.',
                                  icon: Icons.feed_rounded,
                                  isLastStep: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 15),
                        child: Text(
                          "How do we create notes? ",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildVerticalLine(),
                      _buildProcedureStep(
                        stepNumber: 1,
                        title: 'Understanding the Topic',
                        description:
                            'We thoroughly research and analyze the topic to ensure we have a clear understanding of its core concepts etc.',
                        icon: Icons.app_registration,
                      ),
                      _buildVerticalLine(),
                      _buildProcedureStep(
                        stepNumber: 2,
                        title: 'Gathering Reliable Sources',
                        description:
                            'Our team curates information from trusted textbooks, academic journals, expert lectures, and other credible resources to ensure accuracy.',
                        icon: Icons.manage_search,
                      ),
                      _buildVerticalLine(),
                      _buildProcedureStep(
                        stepNumber: 3,
                        title: 'Structuring the Content',
                        description:
                            'We organize the material into a clear and logical format, breaking it down into chapters, sections, and subtopics for easy navigation.',
                        icon: Icons.category,
                      ),
                      _buildVerticalLine(),
                      _buildProcedureStep(
                        stepNumber: 4,
                        title: 'Writing Simplified Notes',
                        description:
                            'We summarize complex information into concise, easy-to-understand points, using simple language without losing the essence.',
                        icon: Icons.edit_note,
                      ),
                      _buildVerticalLine(),
                      _buildProcedureStep(
                        stepNumber: 5,
                        title: 'Adding Visual Aids',
                        description:
                            'To enhance understanding, we incorporate diagrams, charts, infographics, and tables wherever necessary.',
                        icon: Icons.save,
                      ),
                      _buildVerticalLine(),
                      _buildProcedureStep(
                        stepNumber: 6,
                        title: 'Highlighting Key Points',
                        description:
                            'Important concepts, definitions, and takeaways are highlighted using bold text, color codes, and icons to make them stand out.',
                        icon: Icons.highlight,
                      ),
                      _buildVerticalLine(),
                      _buildProcedureStep(
                        stepNumber: 7,
                        title: 'Ensuring Clarity and Accuracy',
                        description:
                            'Each note undergoes a thorough review to ensure it is free from errors and aligned with the topic’s objective.',
                        icon: Iconsax.tag_right,
                      ),
                      _buildVerticalLine(),
                      _buildProcedureStep(
                        stepNumber: 8,
                        title: 'Organizing by Categories',
                        description:
                            'Notes are categorized into relevant sections like Programming, Technology, JEE, NEET and more, so users can easily find what they need.',
                        icon: Icons.clear_all,
                      ),
                      _buildVerticalLine(),
                      _buildProcedureStep(
                        stepNumber: 9,
                        title: 'Regular Updates',
                        description:
                            'We periodically update our notes to include the latest information, trends, and discoveries in the field.',
                        icon: Icons.browser_updated_rounded,
                      ),
                      _buildVerticalLine(),
                      _buildProcedureStep(
                        stepNumber: 10,
                        title: 'Feedback Integration',
                        description:
                            'We listen to user feedback to improve and refine our notes, ensuring they are always user-friendly and comprehensive.',
                        icon: Icons.feed_rounded,
                        isLastStep: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildProcedureStep({
    required int stepNumber,
    required String title,
    required String description,
    required IconData icon,
    bool isLastStep = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$stepNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (!isLastStep)
                Container(
                  width: 2,
                  height: 100,
                  color: Colors.blue.shade200,
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: Colors.deepPurpleAccent,
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Center(
        child: Container(
          width: 2,
          height: 50,
          color: Colors.blue.shade200,
        ),
      ),
    );
  }
}
