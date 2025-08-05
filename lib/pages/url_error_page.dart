import 'package:flutter/material.dart';

class UrlErrorPage extends StatelessWidget {
  const UrlErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
        "Page not found!!",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      )),
    );
  }
}
