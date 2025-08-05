import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import '../pages/login_page.dart';
import '../pages/profile_page.dart';
import '../services/user_service.dart';

class ModernNavBar extends StatelessWidget implements PreferredSizeWidget {
  const ModernNavBar({super.key});

  Future<void> _handleProfileTap(BuildContext context) async {
    final userService = UserService();
    final user = await userService.getCurrentUser();

    if (!context.mounted) return;

    if (user == null) {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );

      if (result == true && context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      }
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;
    final location = GoRouterState.of(context).uri.toString();

    return AppBar(
      iconTheme: const IconThemeData(color: Colors.deepPurpleAccent),
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.black12,
      surfaceTintColor: Colors.white,
      title: InkWell(
        onTap: () => context.go('/'),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 40,
              width: 40,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo.jpg'),
                ),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: Colors.deepPurpleAccent, width: 1),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              "Shandy Notes",
              style: GoogleFonts.kalam(
                fontSize: isMobile ? 24 : 30,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (!isMobile) ...[
          SizedBox(
            width: 150,
          ),
          _buildNavButton(
            context: context,
            icon: Iconsax.home,
            label: 'Home',
            route: '/',
          ),
          _buildNavButton(
            context: context,
            icon: Iconsax.shopping_bag,
            label: 'Shop',
            route: '/shop',
          ),
          _buildNavButton(
            context: context,
            icon: Iconsax.search_normal_1,
            label: 'Sooogle',
            route: '/sooogle',
          ),
          _buildNavButton(
            context: context,
            icon: Iconsax.book,
            label: 'Blog',
            route: '/blog',
          ),
          _buildNavButton(
            context: context,
            icon: Iconsax.info_circle,
            label: 'About Us',
            route: '/about-us',
          ),
          const SizedBox(width: 16),
        ],
        if (isMobile)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.deepPurple),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildNavButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
  }) {
    final isSelected = GoRouterState.of(context).uri.toString() == route;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: () => context.go(route),
        style: TextButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.deepPurpleAccent,
          backgroundColor:
              isSelected ? Colors.deepPurpleAccent : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Colors.deepPurpleAccent,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
