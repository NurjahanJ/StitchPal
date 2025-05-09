import 'package:stitchpal/models/saved_project.dart';

/// Service for managing saved crochet projects
class ProjectService {
  // Singleton instance
  static final ProjectService _instance = ProjectService._internal();
  factory ProjectService() => _instance;
  ProjectService._internal();

  // In-memory storage for saved projects (in a real app, this would use shared preferences or a database)
  final List<SavedProject> _savedProjects = [];

  // Initialize with sample projects for demo purposes
  void initialize() {
    if (_savedProjects.isEmpty) {
      _savedProjects.addAll(SavedProject.getSampleProjects());
    }
  }

  // Get all saved projects
  List<SavedProject> getAllProjects() {
    return List.unmodifiable(_savedProjects);
  }

  // Save a new project
  void saveProject(SavedProject project) {
    // Check if project with same ID already exists
    final existingIndex = _savedProjects.indexWhere((p) => p.id == project.id);
    
    if (existingIndex >= 0) {
      // Update existing project
      _savedProjects[existingIndex] = project;
    } else {
      // Add new project
      _savedProjects.add(project);
    }
  }

  // Delete a project
  void deleteProject(String projectId) {
    _savedProjects.removeWhere((p) => p.id == projectId);
  }

  // Update project progress
  void updateProgress(String projectId, List<bool> completedSteps) {
    final index = _savedProjects.indexWhere((p) => p.id == projectId);
    if (index >= 0) {
      final project = _savedProjects[index];
      final progress = completedSteps.where((isCompleted) => isCompleted).length / 
                       completedSteps.length;
      
      _savedProjects[index] = project.copyWith(
        progress: progress,
        completedSteps: completedSteps,
      );
    }
  }

  // Add tag to project
  void addTag(String projectId, String tag) {
    final index = _savedProjects.indexWhere((p) => p.id == projectId);
    if (index >= 0) {
      final project = _savedProjects[index];
      final tags = List<String>.from(project.tags);
      
      if (!tags.contains(tag)) {
        tags.add(tag);
        _savedProjects[index] = project.copyWith(tags: tags);
      }
    }
  }

  // Remove tag from project
  void removeTag(String projectId, String tag) {
    final index = _savedProjects.indexWhere((p) => p.id == projectId);
    if (index >= 0) {
      final project = _savedProjects[index];
      final tags = List<String>.from(project.tags);
      
      tags.remove(tag);
      _savedProjects[index] = project.copyWith(tags: tags);
    }
  }
}
