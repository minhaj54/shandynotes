import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shandynotes/admin/pages/admin_dashboard.dart';
import 'package:shandynotes/pages/about_us_page.dart';
import 'package:shandynotes/pages/blog_page.dart';
import 'package:shandynotes/pages/bookDetails.dart';
import 'package:shandynotes/pages/categoryPage.dart';
import 'package:shandynotes/pages/homePage.dart';
import 'package:shandynotes/pages/shop_page.dart';
import 'package:shandynotes/pages/store_page.dart';
import 'package:shandynotes/pages/url_error_page.dart';
import 'package:shandynotes/pdf%20search%20engine/shandy_search.dart';
import 'package:shandynotes/sHandy_ai/shandy_ai.dart';
import 'package:shandynotes/services/book_service.dart';

import 'mobile_app/yt_channel.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        StreamProvider<List<Map<String, dynamic>>>(
          create: (_) => BookService().streamBooks(),
          initialData: const [],
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// // this class is for admin panel dashboard
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Shandy Notes Admin',
//       //  theme: _buildTheme(),
//       home: const AdminDashboard(),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Shandy Notes',
      theme: _buildTheme(),
      routerConfig: _buildRouter(),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      primaryColor: Colors.deepPurpleAccent,
      useMaterial3: true,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        bodyLarge: GoogleFonts.inter(fontSize: 16),
        bodyMedium: GoogleFonts.inter(fontSize: 14),
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  GoRouter _buildRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: _buildRoutes(),
      errorBuilder: (context, state) => const UrlErrorPage(),
    );
  }

  List<GoRoute> _buildRoutes() {
    return [
      GoRoute(
        path: '/',
        builder: (context, state) => const Homepage(),
      ),
      GoRoute(
        path: '/shop',
        builder: (context, state) => const ShopPage(),
      ),
      GoRoute(
        path: '/blog',
        builder: (context, state) => const BlogPage(),
      ),
      GoRoute(
        path: '/about-us',
        builder: (context, state) => const AboutUsPage(),
      ),
      GoRoute(
        path: '/shandy-ai',
        builder: (context, state) => const SHandyNoteAiLandingPage(),
      ),
      GoRoute(
        path: '/sooogle',
        builder: (context, state) => SearchPage(),
      ),
      GoRoute(
        path: '/books',
        builder: (context, state) => BookStorePage(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => AdminDashboard(),
      ),
      GoRoute(
        path: '/book/:bookTitle',
        builder: (context, state) {
          final encodedTitle =
              state.pathParameters['bookTitle'] ?? 'Unknown-Note';
          final bookTitle = encodedTitle.replaceAll("-", " ");

          return FutureBuilder<Map<String, dynamic>?>(
            future: BookService().fetchBookDetails(bookTitle),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(child: Text('Error: ${snapshot.error}')),
                );
              }

              final book = snapshot.data;
              if (book == null) {
                return const Scaffold(
                  body: Center(child: Text('Notes not found')),
                );
              }

              return EbookDetailPage(book: book);
            },
          );
        },
      ),
      GoRoute(
        path: '/yt-channel',
        builder: (context, state) => const ChannelHomePage(),
      ),
      GoRoute(
        path: '/category/:categoryName',
        builder: (context, state) {
          final encodedCategory =
              state.pathParameters['categoryName'] ?? 'Unknown';
          final categoryName = encodedCategory.replaceAll("-", " "); // Decode

          final bannerUrl = state.uri.queryParameters['bannerUrl'] ??
              'https://static.vecteezy.com/system/resources/thumbnails/044/303/796/small/abstract-wrapping-paper-rolling-on-a-black-background-concept-of-gifts-and-celebrations-design-two-rolls-of-decorative-gift-paper-in-motion-video.jpg';

          return BooksByCategoryPage(
            // bannerUrl: bannerUrl,
            categoryName: categoryName,
          );
        },
      ),
    ];
  }
}
