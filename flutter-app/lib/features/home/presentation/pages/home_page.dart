import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/product_provider.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/category_chips.dart';
import '../widgets/product_grid.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/banner_carousel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    final productProvider = context.read<ProductProvider>();
    productProvider.fetchProducts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // App Bar
            SliverAppBar(
              floating: true,
              pinned: true,
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.surface,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              title: Text(
                'Shop',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              iconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              actions: [
                IconButton(
                  icon: Stack(
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      Consumer<CartProvider>(
                        builder: (context, cartProvider, child) {
                          if (cartProvider.itemCount > 0) {
                            return Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${cartProvider.itemCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                  onPressed: () => context.push('/cart'),
                ),
                IconButton(
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () {
                    // Bildirimler sayfası
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width < 600 ? 12 : 16,
                  vertical: MediaQuery.of(context).size.width < 600 ? 10 : 12,
                ),
                child: SearchBarWidget(controller: _searchController),
              ),
            ),

            // Banner Carousel
            SliverToBoxAdapter(
              child: BannerCarousel(),
            ),

            // Category Chips
            SliverToBoxAdapter(
              child: CategoryChips(
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                  context.read<ProductProvider>().filterByCategory(category);
                },
              ),
            ),

            // Products Grid
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.isLoading) {
                  return SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                }

                if (productProvider.error != null) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            productProvider.error!,
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadProducts,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final products = _selectedCategory == 'All'
                    ? productProvider.products
                    : productProvider.filteredProducts;

                if (products.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No products found',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ProductGrid(products: products);
              },
            ),

            // Bottom Padding
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                ],
              ),
            ),
            accountName: Text(
              authProvider.userName ?? 'User',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              authProvider.userEmail ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
              child: Text(
                authProvider.userName?.substring(0, 1).toUpperCase() ?? 'U',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home_outlined,
                  title: 'Home',
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/home');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.shopping_bag_outlined,
                  title: 'Orders',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/orders');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.shopping_cart_outlined,
                  title: 'Cart',
                  badge: context.watch<CartProvider>().itemCount,
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/cart');
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.person_outline,
                  title: 'Profile',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/profile');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.edit_outlined,
                  title: 'Edit Profile',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/profile/edit');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.location_on_outlined,
                  title: 'Addresses',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/profile/addresses');
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/profile/settings');
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/profile/help');
                  },
                ),
                const Divider(),
                _buildDrawerItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () {
                    Navigator.pop(context);
                    showAboutDialog(
                      context: context,
                      applicationName: 'E-Commerce App',
                      applicationVersion: '1.0.0',
                      applicationIcon: Icon(
                        Icons.shopping_bag,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Logout Button
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                authProvider.logout();
                context.go('/login');
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    int? badge,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: badge != null && badge > 0
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$badge',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.05,
            ),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              context.push('/orders');
              break;
            case 2:
              context.push('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

