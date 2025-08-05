import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

class MyNavigationDrawer extends StatelessWidget {
  final Function(String route)? onItemSelected;
  const MyNavigationDrawer({super.key, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.deepPurpleAccent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(
                          'assets/images/logo.jpg',
                        ),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black)),
                ),
                const SizedBox(height: 8),
                Text(
                  "Shandy Notes",
                  style: GoogleFonts.kalam(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Iconsax.home,
              color: Colors.deepPurpleAccent,
            ),
            title: const Text(
              'Home',
              style: TextStyle(
                color: Colors.deepPurpleAccent,
              ),
            ),
            onTap: () => context.go('/'),
          ),
          ListTile(
            leading: const Icon(
              Iconsax.shopping_bag,
              color: Colors.deepPurpleAccent,
            ),
            title: const Text(
              'Shop',
              style: TextStyle(
                color: Colors.deepPurpleAccent,
              ),
            ),
            onTap: () => context.go('/shop'),
          ),
          ListTile(
            leading: const Icon(
              Iconsax.search_normal,
              color: Colors.deepPurpleAccent,
            ),
            title: const Text(
              'Sooogle',
              style: TextStyle(
                color: Colors.deepPurpleAccent,
              ),
            ),
            onTap: () => context.go('/sooogle'),
          ),
          ListTile(
            leading: const Icon(
              Iconsax.book,
              color: Colors.deepPurpleAccent,
            ),
            title: const Text(
              'Blog',
              style: TextStyle(
                color: Colors.deepPurpleAccent,
              ),
            ),
            onTap: () => context.go('/blog'),
          ),
          ListTile(
            leading: const Icon(
              Iconsax.info_circle,
              color: Colors.deepPurpleAccent,
            ),
            title: const Text(
              'About Us',
              style: TextStyle(
                color: Colors.deepPurpleAccent,
              ),
            ),
            onTap: () => context.go('/about-us'),
          )
        ],
      ),
    );
  }
}
