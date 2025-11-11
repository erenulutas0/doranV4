import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../core/providers/product_provider.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/utils/price_formatter.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final product = productProvider.getProductById(productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Product Details')),
        body: const Center(child: Text('Product not found')),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: product.imageUrl ?? 'https://via.placeholder.com/400',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, color: Colors.black),
                ),
                onPressed: () {},
              ),
            ],
          ),

          // Product Details
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  if (product.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.category!,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),

                  // Product Name
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),

                  // Rating
                  if (product.rating != null)
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: product.rating!,
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${product.rating} (${product.reviewCount ?? 0} reviews)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),

                  // Price
                  Row(
                    children: [
                      if (product.discountPrice != null)
                        Text(
                          PriceFormatter.format(product.price),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      if (product.discountPrice != null) const SizedBox(width: 8),
                      Text(
                        PriceFormatter.format(product.discountPrice ?? product.price),
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  if (product.description != null) ...[
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Stock Info
                  if (product.stockQuantity != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: product.stockQuantity! > 0
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            product.stockQuantity! > 0
                                ? Icons.check_circle_outline
                                : Icons.cancel_outlined,
                            color: product.stockQuantity! > 0
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            product.stockQuantity! > 0
                                ? 'In Stock (${product.stockQuantity} available)'
                                : 'Out of Stock',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: product.stockQuantity! > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Add to Wishlist'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    return ElevatedButton(
                      onPressed: product.stockQuantity != null && product.stockQuantity! > 0
                          ? () {
                              cartProvider.addItem(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Product added to cart'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          : null,
                      child: const Text('Add to Cart'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

