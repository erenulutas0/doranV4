import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black),
        onPressed: () {
          // Drawer açılacak
        },
      ),
      title: Text(
        'Shop',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () {
            // Cart sayfasına git
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Bildirimler
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

