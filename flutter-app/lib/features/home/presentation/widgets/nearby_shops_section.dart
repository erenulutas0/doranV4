import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/models/shop_model.dart';

class NearbyShopsSection extends StatelessWidget {
  final List<ShopModel> shops;

  const NearbyShopsSection({
    super.key,
    required this.shops,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: shops.length,
        itemBuilder: (context, index) {
          final shop = shops[index];
          return _ShopCard(shop: shop);
        },
      ),
    );
  }
}

class _ShopCard extends StatelessWidget {
  final ShopModel shop;

  const _ShopCard({required this.shop});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF333333), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shop Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: AspectRatio(
              aspectRatio: 1.5,
              child: shop.displayImage.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: shop.displayImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: const Color(0xFF2C2C2C),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFCCFF00)),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: const Color(0xFF2C2C2C),
                        child: const Icon(Icons.store, size: 40, color: Colors.white70),
                      ),
                    )
                  : Container(
                      color: const Color(0xFF2C2C2C),
                      child: const Icon(Icons.store, size: 40, color: Colors.white70),
                    ),
            ),
          ),
          // Shop Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    shop.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Color(0xFFFFC107),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        shop.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (shop.city != null) ...[
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Color(0xFFB3B3B3),
                        ),
                        const SizedBox(width: 2),
                        Flexible(
                          child: Text(
                            shop.city!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFB3B3B3),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
