import 'package:flutter/material.dart';
import 'package:shandynotes/widgets/appbarWidgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../sections/footerSection.dart';
import '../widgets/navigationDrawer.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width to determine layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    const String instaPageUrl =
        "https://www.instagram.com/shandynotes?igsh=dXRndTd5MGhrbXoy&utm_source=qr";

    Future<void> launchInstagramPage() async {
      final Uri url = Uri.parse(instaPageUrl);
      try {
        if (!await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        )) {
          throw Exception('Could not launch $url');
        }
      } catch (e) {
        debugPrint('Error launching URL: $e');
      }
    }

    return Scaffold(
      appBar: const ModernNavBar(),
      endDrawer: MediaQuery.of(context).size.width < 900
          ? const MyNavigationDrawer()
          : null,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero section
            Container(
              height: isMobile ? 250 : 350,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.deepPurpleAccent, Colors.deepPurpleAccent],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome to Shandy Notes",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isMobile ? 24 : 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Making quality educational resources accessible to all students !",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 20,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Our Mission
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 40,
                horizontal: isMobile
                    ? 20
                    : isTablet
                        ? 60
                        : 120,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      "Our Mission",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "At Shandy Notes, we believe that quality education should be accessible to everyone. "
                    "Our platform was created with a simple goal: to provide students with free access to comprehensive "
                    "study materials/notes, whether for academic courses or competitive exams.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "We're a team of passionate individuals who understand the challenges students face "
                    "in finding reliable study resources. That's why we've built Shandy Notes as a "
                    "non-profit platform focused entirely on serving the student community.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            // What we offer
            Container(
              color: Colors.grey.shade100,
              padding: EdgeInsets.symmetric(
                vertical: 40,
                horizontal: isMobile
                    ? 20
                    : isTablet
                        ? 60
                        : 120,
              ),
              child: Column(
                children: [
                  const Text(
                    "What We Offer",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  const SizedBox(height: 30),
                  GridView.count(
                    crossAxisCount: isMobile
                        ? 1
                        : isTablet
                            ? 2
                            : 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: isMobile ? 1.5 : 1.2,
                    children: [
                      _buildOfferingCard(
                        "Academic Notes",
                        "Comprehensive notes for various subjects and courses to help you excel in your studies.",
                        Icons.school,
                      ),
                      _buildOfferingCard(
                        "Competitive Exam Notes",
                        "Well-structured study Notes/materials to help you prepare for competitive exams.",
                        Icons.assignment,
                      ),
                      _buildOfferingCard(
                        "Free Access",
                        "All resources are completely free. We believe in education without barriers.",
                        Icons.lock_open,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Our Story
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 40,
                horizontal: isMobile
                    ? 20
                    : isTablet
                        ? 60
                        : 120,
              ),
              child: Column(
                children: [
                  const Text(
                    "Our Story",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Shandy Notes was born from a shared vision among friends who experienced firsthand "
                    "the challenges of finding quality study materials during their academic journey. "
                    "Minhaj, Maniska, Shubham,Aftab and Abhinav came together with the commitment to create "
                    "a platform that would make educational resources more accessible.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "What started as a small project has now grown into a platform serving thousands of "
                    "students. We don't measure our success in profits but in the number of students "
                    "we help achieve their academic goals.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            // Meet the Team
            Container(
              color: Colors.grey.shade100,
              padding: EdgeInsets.symmetric(
                vertical: 40,
                horizontal: isMobile
                    ? 20
                    : isTablet
                        ? 60
                        : 120,
              ),
              child: Column(
                children: [
                  const Text(
                    "Meet Our Team",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Wrap(
                    spacing: 30,
                    runSpacing: 30,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildTeamMemberCard(
                        "Minhaj",
                        "Founder & Developer",
                        "https://fra.cloud.appwrite.io/v1/storage/buckets/67aa347e001cffd1d535/files/6825a617001e077e0341/view?project=6719d1d0001cf69eb622&mode=admin", // Replace with actual image path
                        context,
                        isMobile,
                      ),
                      _buildTeamMemberCard(
                        "Manishka",
                        "Content Manager",
                        "https://fra.cloud.appwrite.io/v1/storage/buckets/67aa347e001cffd1d535/files/6825a9ee001d5d4553cb/view?project=6719d1d0001cf69eb622&mode=admin", // Replace with actual image path
                        context,
                        isMobile,
                      ),
                      _buildTeamMemberCard(
                        "Shubham",
                        "Content Curator",
                        "https://fra.cloud.appwrite.io/v1/storage/buckets/67aa347e001cffd1d535/files/6825b43c0015213878c4/view?project=6719d1d0001cf69eb622&mode=admin", // Replace with actual image path
                        context,
                        isMobile,
                      ),
                      _buildTeamMemberCard(
                        "Abhinav",
                        "Content Curator",
                        "https://fra.cloud.appwrite.io/v1/storage/buckets/67aa347e001cffd1d535/files/6825ad860027e87f632c/view?project=6719d1d0001cf69eb622&mode=admin", // Replace with actual image path
                        context,
                        isMobile,
                      ),
                      _buildTeamMemberCard(
                        "Aftab",
                        "Social Media",
                        "https://fra.cloud.appwrite.io/v1/storage/buckets/67aa347e001cffd1d535/files/6825b44800102dceb4ae/view?project=6719d1d0001cf69eb622&mode=admin", // Replace with actual image path
                        context,
                        isMobile,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Join us CTA
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 60,
                horizontal: isMobile
                    ? 20
                    : isTablet
                        ? 60
                        : 120,
              ),
              child: Column(
                children: [
                  Text(
                    "Join Us in Our Mission",
                    style: TextStyle(
                      fontSize: isMobile ? 24 : 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "We're always looking for ways to improve and expand our resources. "
                    "If you'd like to contribute or have suggestions, we'd love to hear from you!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 16 : 18,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => launchInstagramPage(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text("Contact Us"),
                  ),
                ],
              ),
            ),

            // Footer
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferingCard(String title, String description, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.deepPurpleAccent,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMemberCard(String name, String role, String imagePath,
      BuildContext context, bool isMobile) {
    final cardWidth = isMobile ? double.infinity : 220.0;

    return Container(
      width: cardWidth,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 65,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: NetworkImage(imagePath),
                // If image fails to load, show the first letter of the name
                child: const Text(
                  "",
                  style: TextStyle(fontSize: 40, color: Colors.indigo),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                role,
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
