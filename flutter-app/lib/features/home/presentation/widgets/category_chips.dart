import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryChips({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<String> categories = const [
    'All',
    'Electronics',
    'Clothing',
    'Home & Garden',
    'Sports',
    'Books',
    'Toys',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isSmallMobile = screenWidth < 450;
    
    // Mobil için kısaltılmış kategori isimleri
    String getDisplayText(String category) {
      if (isSmallMobile) {
        // Çok küçük ekranlarda tek harf veya kısaltma
        switch (category) {
          case 'Home & Garden':
            return 'Home';
          case 'Electronics':
            return 'Elec';
          case 'Clothing':
            return 'Cloth';
          case 'Sports':
            return 'Sport';
          case 'Books':
            return 'Books';
          case 'Toys':
            return 'Toys';
          default:
            return category.length > 5 ? category.substring(0, 5) : category;
        }
      } else if (isMobile) {
        switch (category) {
          case 'Home & Garden':
            return 'Home';
          case 'Electronics':
            return 'Electronics';
          case 'Clothing':
            return 'Clothing';
          case 'Sports':
            return 'Sports';
          case 'Books':
            return 'Books';
          case 'Toys':
            return 'Toys';
          default:
            return category.length > 10 ? category.substring(0, 10) : category;
        }
      }
      return category;
    }
    
    return SizedBox(
      height: isSmallMobile ? 40 : isMobile ? 42 : 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          final displayText = getDisplayText(category);

          return Padding(
            padding: EdgeInsets.only(right: isMobile ? 4 : 8),
            child: FilterChip(
              label: Text(
                displayText,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
              selected: isSelected,
              onSelected: (selected) {
                onCategorySelected(category);
              },
              selectedColor: Theme.of(context).colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: isSmallMobile ? 9 : isMobile ? 10 : 14,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isSmallMobile ? 6 : isMobile ? 8 : 16,
                vertical: isSmallMobile ? 4 : isMobile ? 5 : 8,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isMobile ? 12 : 20),
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).dividerColor,
                  width: isMobile ? 1 : 1.5,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

