import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ShareButton extends StatelessWidget {
  final String bookTitle;
  final String bookAuthor;
  final String bookUrl;
  final double price;

  const ShareButton({
    super.key,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookUrl,
    required this.price,
  });

  Future<void> _shareContent(BuildContext context) async {
    final String shareText = '''

Title: $bookTitle
Author: $bookAuthor
Price: ₹$price

Download : $bookUrl

Shandy Notes - Your Digital Study Partner

''';

    try {
      await Share.share(
        shareText,
        subject: 'Check out $bookTitle on Shandy Notes!',
      );
    } catch (e) {
      // Fallback to copy to clipboard if sharing fails
      await Clipboard.setData(ClipboardData(text: shareText));
      _showSnackBar(context, 'Link copied to clipboard!');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Share this note',
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: IconButton(
          icon: const Icon(Icons.share_rounded),
          onPressed: () => _shareContent(context),
          color: Colors.deepPurpleAccent,
          tooltip: 'Share this note',
        ),
      ),
    );
  }
}
