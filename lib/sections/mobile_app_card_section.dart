import 'package:flutter/material.dart';

class MobileAppCardSection extends StatelessWidget {
  const MobileAppCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth > 600
              ? _buildWideLayout()
              : _buildNarrowLayout();
        },
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _buildAppDetailsSection(),
        ),
        Expanded(
          flex: 1,
          child: _buildMobileScreenImage(),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        _buildAppDetailsSection(),
        _buildMobileScreenImage(),
      ],
    );
  }

// ... existing code ...
  Widget _buildAppDetailsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center the content
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Download Our Mobile App',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Experience seamless mobile experience with our app. Download now and enjoy features like real-time updates, personalized recommendations, and easy navigation.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5, // Center the text
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 20, // Added vertical spacing
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Add Android app store navigation logic
                },
                icon: const Icon(Icons.android),
                label: const Text('Download for Android'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green, // Android color
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Add iOS app store navigation logic
                  },
                  icon: const Icon(Icons.apple),
                  label: const Text('Download for iOS'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // iOS color
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// ... existing code ...
  Widget _buildMobileScreenImage() {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 600,
      width: 300,
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  'https://files.tecnoblog.net/wp-content/uploads/2019/07/app-store-700x428.png'))),
    );
  }
}
