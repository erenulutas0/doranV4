import 'package:flutter/foundation.dart';

class HobbyGroupModel {
  final String id;
  final String creatorId;
  final String name;
  final String? description;
  final String category;
  final String? location;
  final double? latitude;
  final double? longitude;
  final List<String>? tags;
  final String? rules;
  final String? imageId;
  final String? imageUrl;
  final int? maxMembers;
  final int? memberCount;
  final String status; // ACTIVE, INACTIVE, ARCHIVED
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;

  HobbyGroupModel({
    required this.id,
    required this.creatorId,
    required this.name,
    this.description,
    required this.category,
    this.location,
    this.latitude,
    this.longitude,
    this.tags,
    this.rules,
    this.imageId,
    this.imageUrl,
    this.maxMembers,
    this.memberCount,
    required this.status,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      return parsed;
    }
    try {
      return double.parse(value.toString());
    } catch (e) {
      return null;
    }
  }

  factory HobbyGroupModel.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) {
      debugPrint('🔍 Hobby Group "${json['name']}": lat=${json['latitude']} (${json['latitude']?.runtimeType}), lng=${json['longitude']} (${json['longitude']?.runtimeType})');
    }
    return HobbyGroupModel(
      id: json['id']?.toString() ?? '',
      creatorId: json['creatorId']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      category: json['category'] ?? '',
      location: json['location'],
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      tags: json['tags'] != null ? (json['tags'] is List ? List<String>.from(json['tags']) : null) : null,
      rules: json['rules'],
      imageId: json['imageId']?.toString(),
      imageUrl: json['imageUrl'],
      maxMembers: json['maxMembers'] is int ? json['maxMembers'] : (json['maxMembers'] != null ? int.tryParse(json['maxMembers'].toString()) : null),
      memberCount: json['memberCount'] is int ? json['memberCount'] : (json['memberCount'] != null ? int.tryParse(json['memberCount'].toString()) ?? 0 : 0),
      status: json['status']?.toString() ?? 'ACTIVE',
      isActive: json['isActive'] is bool ? json['isActive'] : (json['isActive'] != null ? json['isActive'].toString().toLowerCase() == 'true' : null),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  bool get isFull => maxMembers != null && memberCount != null && memberCount! >= maxMembers!;
  int get currentMembers => memberCount ?? 0;
  int get maxMembersCount => maxMembers ?? 0;
}

