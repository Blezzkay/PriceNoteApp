import 'package:uuid/uuid.dart';

class ProjectModel {
  String id;
  String title;
  String description;

  // ➕ Simplified Bank Details
  String bankDetails;

  // Optional brand image
  String? brandImageUrl;

  // Premium status
  bool isPremium;

  // ➕ Main project data (nullable for now)
  dynamic? projectData;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.bankDetails,
    this.brandImageUrl,
    this.isPremium = false,
    this.projectData,
  });

  /// Factory for creating a NEW project with auto-generated UUID
  factory ProjectModel.create({
    required String title,
    required String description,
    required String bankDetails,
    String? brandImageUrl,
    bool isPremium = false,
    dynamic? projectData,
  }) {
    return ProjectModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      bankDetails: bankDetails,
      brandImageUrl: brandImageUrl,
      isPremium: isPremium,
      projectData: projectData,
    );
  }

  /// Convert to Map for local storage or API
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'bankDetails': bankDetails,
      'brandImageUrl': brandImageUrl,
      'isPremium': isPremium,
      'projectData': projectData,
    };
  }

  /// Convert Map to ProjectModel
  factory ProjectModel.fromMap(Map<dynamic, dynamic> map) {
    return ProjectModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      bankDetails: map['bankDetails'] as String,
      brandImageUrl: map['brandImageUrl'] as String?,
      isPremium: map['isPremium'] as bool? ?? false,
      projectData: map['projectData'],
    );
  }
}
