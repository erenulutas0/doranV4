import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> banners = [
    {
      'title': 'Summer Sale',
      'subtitle': 'Up to 50% OFF',
      'color': const Color(0xFF6750A4),
    },
    {
      'title': 'New Arrivals',
      'subtitle': 'Latest Collection',
      'color': const Color(0xFF9575CD),
    },
    {
      'title': 'Free Shipping',
      'subtitle': 'On orders over \$100',
      'color': const Color(0xFF7D5260),
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final bannerHeight = isMobile ? 140.0 : 180.0;
    
    return Column(
      children: [
        SizedBox(
          height: bannerHeight,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        banner['color'] as Color,
                        (banner['color'] as Color).withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: (banner['color'] as Color).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          banner['title'] as String,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: isMobile ? 18 : 24,
                          ),
                        ),
                        SizedBox(height: isMobile ? 4 : 6),
                        Text(
                          banner['subtitle'] as String,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: isMobile ? 11 : 16,
                          ),
                        ),
                        SizedBox(height: isMobile ? 8 : 12),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to products
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: banner['color'] as Color,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 14 : 24,
                              vertical: isMobile ? 8 : 14,
                            ),
                            textStyle: TextStyle(
                              fontSize: isMobile ? 11 : 14,
                            ),
                          ),
                          child: const Text('Shop Now'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SmoothPageIndicator(
          controller: _pageController,
          count: banners.length,
          effect: WormEffect(
            dotColor: Theme.of(context).dividerColor,
            activeDotColor: Theme.of(context).colorScheme.primary,
            dotHeight: 8,
            dotWidth: 8,
            spacing: 8,
          ),
        ),
      ],
    );
  }
}

