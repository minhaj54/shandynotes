import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/appbarWidgets.dart';
import '../widgets/navigationDrawer.dart';
import '../widgets/telegram_button.dart';

class SHandyNoteAiLandingPage extends StatelessWidget {
  const SHandyNoteAiLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ModernNavBar(),
      endDrawer: MediaQuery.of(context).size.width < 1100
          ? const MyNavigationDrawer()
          : null,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "Shandy AI",
                      style: GoogleFonts.kalam(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[700],
                      ),
                    ),
                  ),
                  // Coming Soon Banner
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upcoming, color: Colors.orange.shade800),
                        const SizedBox(width: 12),
                        Text(
                          "Coming Soon!!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // ai image section
                  Center(
                    child: Image.network(
                        height: 400,
                        "https://cloud.appwrite.io/v1/storage/buckets/67aa347e001cffd1d535/files/67ab85e9003a78202af9/view?project=6719d1d0001cf69eb622&mode=admin"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // Hero Section
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Smart Notes for Smart Students.",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "Transform your note-taking experience with AI-powered intelligence.",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Detailed AI Capabilities
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "What Our AI Can Do !!",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildCapabilityItem(
                                    Icons.auto_awesome,
                                    "Smart Note Generation",
                                    "Automatically generates well-structured notes from your input",
                                  ),
                                  _buildCapabilityItem(
                                    Icons.bar_chart,
                                    "Visual Analytics",
                                    "Creates graphs, charts, and infographics to visualize your data",
                                  ),
                                  _buildCapabilityItem(
                                    Icons.table_chart,
                                    "Table Organization",
                                    "Formats information into clear, readable tables",
                                  ),
                                  _buildCapabilityItem(
                                    Icons.account_tree,
                                    "Flow Visualization",
                                    "Generates flowcharts and diagrams to explain processes",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Features Section
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Features",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 40),
                        ModernFeatureGrid(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Center(
                    child: TelegramButton(
                      channelUrl:
                          'https://www.instagram.com/shandynotes?igsh=dXRndTd5MGhrbXoy&utm_source=qr', // Replace with your channel URL
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),

          // Footer
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              color: const Color(0xFF6B46C1),
              child: const Column(
                children: [
                  Text(
                    "© 2025 Shandy Notes",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilityItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF6B46C1), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ModernFeatureGrid extends StatelessWidget {
  const ModernFeatureGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        return Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            ModernFeatureCard(
              icon: Icons.auto_awesome,
              title: "AI-Powered",
              description: "Smart note generation with advanced AI",
              width: isWide
                  ? (constraints.maxWidth - 48) / 3
                  : constraints.maxWidth,
            ),
            ModernFeatureCard(
              icon: Icons.folder_special,
              title: "Organized",
              description: "Automatic categorization and tagging",
              width: isWide
                  ? (constraints.maxWidth - 48) / 3
                  : constraints.maxWidth,
            ),
            ModernFeatureCard(
              icon: Icons.share,
              title: "Collaborative",
              description: "Real-time team sharing and editing",
              width: isWide
                  ? (constraints.maxWidth - 48) / 3
                  : constraints.maxWidth,
            ),
          ],
        );
      },
    );
  }
}

class ModernFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final double width;

  const ModernFeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF6B46C1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF6B46C1),
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
