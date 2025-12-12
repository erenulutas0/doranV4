import 'package:flutter/material.dart';

class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final crossAxisCount = isMobile ? 2 : 3;
    final horizontalPadding = isMobile ? 16.0 : 20.0;
    final gridSpacing = isMobile ? 10.0 : 16.0;
    final childAspectRatio = isMobile ? 0.75 : 0.78;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: gridSpacing,
          mainAxisSpacing: gridSpacing,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _SkeletonCard(),
          childCount: crossAxisCount * 3,
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);
    final baseColor = Theme.of(context).colorScheme.surfaceVariant;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: borderRadius,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.vertical(top: borderRadius.topLeft),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _line(baseColor, widthFactor: 0.8),
                const SizedBox(height: 6),
                _line(baseColor, widthFactor: 0.5),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _line(baseColor, width: 60, height: 12),
                    const Spacer(),
                    _circle(baseColor, size: 20),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(Color color, {double? width, double height = 12, double widthFactor = 1}) {
    return FractionallySizedBox(
      widthFactor: width == null ? widthFactor : null,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color.withOpacity(0.7),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }

  Widget _circle(Color color, {double size = 16}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.7),
        shape: BoxShape.circle,
      ),
    );
  }
}

