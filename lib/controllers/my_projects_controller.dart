import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../ui/price_home_screen.dart';

class ProjectController extends GetxController {
  RxList<ProjectModel> projects = <ProjectModel>[].obs;

  final String _hiveBoxName = 'konvbox';
  final String _projectsKey = 'projects';

  // TextEditingControllers
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController bankDetailsController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProjects();
  }

  @override
  void onClose() {
    projectNameController.dispose();
    descriptionController.dispose();
    bankDetailsController.dispose();
    super.onClose();
  }

  /// Load projects from Hive
  Future<void> loadProjects() async {
    final box = Hive.box(_hiveBoxName);
    final raw = box.get(_projectsKey);
    if (raw == null) {
      projects.value = [];
      return;
    }

    final List loaded = raw as List;
    projects.value = loaded
        .map((e) => ProjectModel.fromMap(Map<dynamic, dynamic>.from(e)))
        .toList();
  }

  /// Save all projects to Hive
  Future<void> saveProjects() async {
    final box = Hive.box(_hiveBoxName);
    await box.put(_projectsKey, projects.map((e) => e.toMap()).toList());
  }

  /// Add a new project
  Future<void> addProject(ProjectModel project) async {
    projects.add(project);
    await saveProjects();
  }

  /// Edit a project at index
  Future<void> editProject(int index, ProjectModel updatedProject) async {
    projects[index] = updatedProject;
    await saveProjects();
  }

  /// Delete a project
  Future<void> deleteProject(int index) async {
    projects.removeAt(index);
    await saveProjects(); // ← was missing, so deletion was never persisted
  }

  /// Create a new project from controller values
  Future<void> createProject(BuildContext context,
      {String? brandImageUrl, bool isPremium = false}) async {
    final title = projectNameController.text.trim();
    final description = descriptionController.text.trim();
    final bankDetails = bankDetailsController.text.trim();

    if (title.isEmpty) {
      Get.snackbar(
        'Error',
        'Project name cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final newProject = ProjectModel.create(
      title: title,
      description: description,
      bankDetails: bankDetails,
      brandImageUrl: brandImageUrl,
      isPremium: isPremium,
    );

    // Add and save
    projects.add(newProject);
    await saveProjects();

    // Clear controllers
    projectNameController.clear();
    descriptionController.clear();
    bankDetailsController.clear();

    // Close bottom sheet
    Navigator.of(context).pop();

    // Navigate to Price Mode Screen
    Get.to(() => PriceHomeScreen(projectId: newProject.id));
  }

  /// ✅ Open a project by its ID
  void openProject(String projectId) {
    try {
      final project =
      projects.firstWhere((proj) => proj.id == projectId, orElse: () => throw Exception('Project not found'));

      // Print project title
      print('Opening project: ${project.title}');

      // Navigate to PriceHomeScreen
      Get.to(() => PriceHomeScreen(projectId: project.id));
    } catch (e) {
      Get.snackbar(
        'Error',
        'Project not found',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
