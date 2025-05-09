import 'package:flutter/material.dart';
import 'package:stitchpal/models/saved_project.dart';
import 'package:stitchpal/services/project_service.dart';
import 'package:stitchpal/theme.dart';
import 'package:stitchpal/widgets/project_card.dart';
import 'package:stitchpal/widgets/yarn_chip.dart';

class SavedProjectsScreen extends StatefulWidget {
  const SavedProjectsScreen({super.key});

  @override
  State<SavedProjectsScreen> createState() => _SavedProjectsScreenState();
}

class _SavedProjectsScreenState extends State<SavedProjectsScreen> {
  late List<SavedProject> _projects;
  late List<SavedProject> _filteredProjects;
  final Set<String> _selectedTags = {};
  final Set<String> _allTags = {};

  @override
  void initState() {
    super.initState();
    // Load projects from the project service
    _projects = ProjectService().getAllProjects();
    _filteredProjects = List.from(_projects);
    
    // Extract all unique tags from projects
    for (final project in _projects) {
      _allTags.addAll(project.tags);
    }
  }

  // Filter projects based on selected tags
  void _filterProjects() {
    if (_selectedTags.isEmpty) {
      // If no tags selected, show all projects
      setState(() {
        _filteredProjects = List.from(_projects);
      });
    } else {
      // Filter projects that contain ANY of the selected tags
      setState(() {
        _filteredProjects = _projects.where((project) {
          return project.tags.any((tag) => _selectedTags.contains(tag));
        }).toList();
      });
    }
  }

  // Toggle tag selection
  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
      _filterProjects();
    });
  }

  // Delete a project
  void _deleteProject(SavedProject project) {
    // Delete from project service
    ProjectService().deleteProject(project.id);
    
    // Update local state
    setState(() {
      _projects = ProjectService().getAllProjects();
      _filterProjects();
      
      // Show a snackbar to confirm deletion
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${project.pattern.title} deleted'),
          backgroundColor: StitchPalTheme.primaryColor,
          action: SnackBarAction(
            label: 'Undo',
            textColor: StitchPalTheme.textColor,
            onPressed: () {
              // Add project back to service
              ProjectService().saveProject(project);
              
              // Update local state
              setState(() {
                _projects = ProjectService().getAllProjects();
                _filterProjects();
              });
            },
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StitchPalTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('My Projects'),
        backgroundColor: StitchPalTheme.primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter tags section
          if (_allTags.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'Filter by tag',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: _allTags.map((tag) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: YarnChip(
                      label: tag,
                      isSelected: _selectedTags.contains(tag),
                      onTap: () => _toggleTag(tag),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
          ],
          
          // Project count
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Text(
              '${_filteredProjects.length} project${_filteredProjects.length != 1 ? 's' : ''}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: StitchPalTheme.textColor.withOpacity(0.7),
                  ),
            ),
          ),
          
          // Projects list
          Expanded(
            child: _filteredProjects.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _filteredProjects.length,
                    itemBuilder: (context, index) {
                      return ProjectCard(
                        project: _filteredProjects[index],
                        onDelete: _deleteProject,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_dissatisfied,
            size: 64,
            color: StitchPalTheme.textColor.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No projects found',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: StitchPalTheme.textColor.withOpacity(0.7),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedTags.isEmpty
                ? 'Create a new project to get started'
                : 'Try selecting different tags',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: StitchPalTheme.textColor.withOpacity(0.5),
                ),
          ),
          if (_selectedTags.isNotEmpty) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedTags.clear();
                  _filterProjects();
                });
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ],
      ),
    );
  }
}
