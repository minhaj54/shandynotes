import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TelegramButton extends StatelessWidget {
  final String channelUrl;

  const TelegramButton({
    super.key,
    required this.channelUrl,
  });

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: _launchTelegramChannel,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6B46C1),
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Join Waitlist",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
