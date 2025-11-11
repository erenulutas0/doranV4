import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/models/product_model.dart';
import '../../../../core/utils/price_formatter.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;

  const ProductGrid({
    super.key,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive grid: Mobil (2 sütun), Tablet/Desktop (3 sütun)
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final crossAxisCount = isMobile ? 2 : 3;
    final padding = isMobile ? 6.0 : 12.0;
    final childAspectRatio = isMobile ? 0.65 : 0.75; // Mobilde daha kompakt
    
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: padding,
          mainAxisSpacing: padding,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            return _ProductCard(product: product, isMobile: isMobile);
          },
          childCount: products.length,
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final bool isMobile;

  const _ProductCard({
    required this.product,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                Theme.of(context).brightness == Brightness.dark ? 0.3 : 0.05,
              ),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _buildCompactCard(context),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Product Image
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: product.imageUrl ?? 'https://via.placeholder.com/200',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    child: Icon(
                      Icons.image_not_supported,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        size: isMobile ? 12 : 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(
                        minWidth: isMobile ? 20 : 24,
                        minHeight: isMobile ? 20 : 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Product Info
        Expanded(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 4 : 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Category Badge
                if (product.category != null)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 3 : 4,
                      vertical: isMobile ? 1 : 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      product.category!.length > (isMobile ? 6 : 8)
                          ? product.category!.substring(0, isMobile ? 6 : 8) + '...'
                          : product.category!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: isMobile ? 7 : 8,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                SizedBox(height: isMobile ? 1 : 2),
                // Product Name
                Expanded(
                  child: Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: isMobile ? 10 : 11,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: isMobile ? 2 : 4),
                // Price and Add Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (product.discountPrice != null)
                            Text(
                              PriceFormatter.format(product.price),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                fontSize: isMobile ? 7 : 8,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          Text(
                            PriceFormatter.format(product.discountPrice ?? product.price),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: isMobile ? 10 : 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(isMobile ? 5 : 6),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: isMobile ? 12 : 14,
                        ),
                        onPressed: () {},
                        padding: EdgeInsets.all(isMobile ? 3 : 4),
                        constraints: BoxConstraints(
                          minWidth: isMobile ? 20 : 24,
                          minHeight: isMobile ? 20 : 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

