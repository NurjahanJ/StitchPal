import 'package:flutter/material.dart';
import 'package:stitchpal/models/saved_project.dart';
import 'package:stitchpal/screens/project_tracker_screen.dart';
import 'package:stitchpal/theme.dart';
import 'package:stitchpal/widgets/skill_level_badge.dart';

class ProjectCard extends StatelessWidget {
  final SavedProject project;
  final Function(SavedProject) onDelete;

  const ProjectCard({
    super.key,
    required this.project,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: StitchPalTheme.accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to project tracker screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectTrackerScreen(project: project),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title, skill level, and delete button
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project.pattern.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  SkillLevelBadge(level: project.pattern.skillLevel),
                  const SizedBox(width: 4),
                  // Delete button
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    color: Colors.red.shade300,
                    onPressed: () => _showDeleteDialog(context),
                    tooltip: 'Delete project',
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Progress and date in one row
              Row(
                children: [
                  // Progress indicator (circular)
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: Stack(
                      children: [
                        CircularProgressIndicator(
                          value: project.progress,
                          backgroundColor: StitchPalTheme.accentColor.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getProgressColor(project.progress),
                          ),
                          strokeWidth: 5,
                        ),
                        Center(
                          child: Text(
                            '${(project.progress * 100).toInt()}%',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Project info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date and steps
                        Text(
                          'Started ${_formatDate(project.savedDate)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: StitchPalTheme.textColor.withOpacity(0.7),
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${project.completedStepCount}/${project.totalSteps} steps completed',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: StitchPalTheme.textColor.withOpacity(0.7),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // Tags
              if (project.tags.isNotEmpty) ...[  
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: project.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: StitchPalTheme.accentColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#$tag',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: StitchPalTheme.textColor.withOpacity(0.7),
                              fontSize: 10,
                            ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Format date to "Month Day" format
  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  // Get color based on progress
  Color _getProgressColor(double progress) {
    if (progress < 0.3) {
      return Colors.orange;
    } else if (progress < 0.7) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  // Show delete confirmation dialog
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Project?'),
          content: Text(
            'Are you sure you want to delete "${project.pattern.title}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete(project);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
