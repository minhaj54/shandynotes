import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuoteBox extends StatelessWidget {
  const QuoteBox({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      height: 270,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.deepPurpleAccent,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "The beautiful thing about learning is that no one can take it away from you !!",
              textAlign: TextAlign.center,
              style: GoogleFonts.kalam(
                  fontSize: isMobile ? 24 : 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              "-B.B.King",
              style: GoogleFonts.kalam(
                  fontSize: isMobile ? 18 : 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
