import 'package:flutter/foundation.dart';

class JobModel {
  final String id;
  final String ownerId;
  final String title;
  final String? description;
  final String category;
  final String jobType; // FULL_TIME, PART_TIME, CONTRACT, INTERNSHIP, REMOTE
  final String? companyName;
  final String? location;
  final String? city;
  final double? latitude;
  final double? longitude;
  final String? salaryRange;
  final bool? isRemote;
  final String? requirements;
  final String? benefits;
  final String? applicationUrl;
  final String? contactEmail;
  final bool? isPublished;
  final String? publishedAt;
  final String? expiresAt;
  final String? createdAt;
  final String? updatedAt;

  JobModel({
    required this.id,
    required this.ownerId,
    required this.title,
    this.description,
    required this.category,
    required this.jobType,
    this.companyName,
    this.location,
    this.city,
    this.latitude,
    this.longitude,
    this.salaryRange,
    this.isRemote,
    this.requirements,
    this.benefits,
    this.applicationUrl,
    this.contactEmail,
    this.isPublished,
    this.publishedAt,
    this.expiresAt,
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

  factory JobModel.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) {
      debugPrint('🔍 Job "${json['title']}": lat=${json['latitude']} (${json['latitude']?.runtimeType}), lng=${json['longitude']} (${json['longitude']?.runtimeType})');
    }
    return JobModel(
      id: json['id']?.toString() ?? '',
      ownerId: json['ownerId']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      category: json['category'] ?? '',
      jobType: json['jobType'] ?? 'FULL_TIME',
      companyName: json['companyName'],
      location: json['location'],
      city: json['city'],
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      salaryRange: json['salaryRange'],
      isRemote: json['isRemote'] ?? false,
      requirements: json['requirements'],
      benefits: json['benefits'],
      applicationUrl: json['applicationUrl'],
      contactEmail: json['contactEmail'],
      isPublished: json['isPublished'] ?? false,
      publishedAt: json['publishedAt'],
      expiresAt: json['expiresAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  String get displayLocation => isRemote == true 
      ? 'Remote' 
      : city ?? location ?? 'Location not specified';
  
  String get displayJobType {
    switch (jobType.toUpperCase()) {
      case 'FULL_TIME':
        return 'Full Time';
      case 'PART_TIME':
        return 'Part Time';
      case 'CONTRACT':
        return 'Contract';
      case 'INTERNSHIP':
        return 'Internship';
      case 'REMOTE':
        return 'Remote';
      default:
        return jobType;
    }
  }
}

