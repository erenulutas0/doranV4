class Product {
  final String id;
  final String name;
  final String? description;
  final double price;
  final double? discountPrice;
  final String? imageUrl;
  final String? category;
  final bool isActive;
  final int? stockQuantity;
  final double? rating;
  final int? reviewCount;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.discountPrice,
    this.imageUrl,
    this.category,
    this.isActive = true,
    this.stockQuantity,
    this.rating,
    this.reviewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      price: json['price'] is int 
          ? (json['price'] as int).toDouble()
          : (json['price'] ?? 0).toDouble(),
      discountPrice: json['discountPrice']?.toDouble(),
      imageUrl: json['imageUrl'],
      category: json['category'],
      isActive: json['isActive'] ?? true,
      stockQuantity: json['stockQuantity'] is int 
          ? json['stockQuantity'] as int
          : json['stockQuantity'] != null 
              ? int.tryParse(json['stockQuantity'].toString())
              : null,
      rating: json['rating']?.toDouble() ?? json['averageRating']?.toDouble(),
      reviewCount: json['reviewCount'] is int 
          ? json['reviewCount'] as int
          : json['reviewCount'] != null 
              ? int.tryParse(json['reviewCount'].toString())
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discountPrice': discountPrice,
      'imageUrl': imageUrl,
      'category': category,
      'isActive': isActive,
      'stockQuantity': stockQuantity,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? discountPrice,
    String? imageUrl,
    String? category,
    bool? isActive,
    int? stockQuantity,
    double? rating,
    int? reviewCount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      discountPrice: discountPrice ?? this.discountPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
}

