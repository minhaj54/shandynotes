import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.deepPurpleAccent),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return const DesktopFooter();
          } else {
            return const MobileFooter();
          }
        },
      ),
    );
  }
}

class DesktopFooter extends StatelessWidget {
  const DesktopFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '© 2025 Shandy Notes. All rights reserved.',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(
              width: 15,
            ),
            Row(
              children: [
                _buildSocialIcon(
                  Iconsax.instagram,
                  () => _launchInstagramPage(),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class MobileFooter extends StatelessWidget {
  const MobileFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        // Copyright and Social Icons

        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '© 2025 Shandy Notes',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            const SizedBox(width: 10),
            _buildSocialIcon(
              Iconsax.instagram,
              () => _launchInstagramPage(),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

Widget _buildFooterTitle(String title) {
  return Text(
    title,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  );
}

Widget _buildFooterLink(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: InkWell(
      onTap: () {},
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    ),
  );
}

Widget _buildContactItem(IconData icon, String text) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 18, color: Colors.deepPurple[100]),
      const SizedBox(width: 8),
      Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
    ],
  );
}

const String channelUrl = "https://t.me/shandynotes";
const String instaPageUrl =
    "https://www.instagram.com/shandynotes?igsh=dXRndTd5MGhrbXoy&utm_source=qr";

Future<void> _launchTelegramChannel() async {
  final Uri url = Uri.parse(channelUrl);
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

Future<void> _launchInstagramPage() async {
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

Widget _buildSocialIcon(IconData icon, VoidCallback onTap) {
  return Container(
    margin: const EdgeInsets.only(right: 16),
    child: InkWell(
      onTap: onTap,
      child: Icon(
        icon,
        color: Colors.white,
        size: 24,
      ),
    ),
  );
}
