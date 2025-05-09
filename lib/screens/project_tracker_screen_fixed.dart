import 'package:flutter/material.dart';
import 'package:stitchpal/models/saved_project.dart';
import 'package:stitchpal/theme.dart';
import 'package:stitchpal/widgets/project_timer.dart';
import 'package:stitchpal/widgets/skill_level_badge.dart';
import 'package:stitchpal/widgets/step_checklist_item.dart';
import 'package:stitchpal/widgets/stitch_counter.dart';

class ProjectTrackerScreen extends StatefulWidget {
  final SavedProject project;

  const ProjectTrackerScreen({
    super.key,
    required this.project,
  });

  @override
  State<ProjectTrackerScreen> createState() => _ProjectTrackerScreenState();
}

class _ProjectTrackerScreenState extends State<ProjectTrackerScreen> with SingleTickerProviderStateMixin {
  late SavedProject _project;
  late TabController _tabController;
  int _stitchCount = 0;
  int _timerSeconds = 0;
  int _currentStepIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _project = widget.project;
    _tabController = TabController(length: 3, vsync: this);
    
    // Find the first incomplete step to set as current
    _currentStepIndex = _project.completedSteps.indexWhere((completed) => !completed);
    if (_currentStepIndex == -1) {
      _currentStepIndex = 0; // If all steps are completed, start at the beginning
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateStepStatus(int index, bool completed) {
    setState(() {
      // Create a new list to avoid modifying the original
      final updatedSteps = List<bool>.from(_project.completedSteps);
      updatedSteps[index] = completed;
      
      // Calculate new progress
      final newProgress = updatedSteps.where((step) => step).length / updatedSteps.length;
      
      // Update the project with new completed steps and progress
      _project = _project.copyWith(
        completedSteps: updatedSteps,
        progress: newProgress,
      );
      
      // Update current step index if this step was marked as completed
      if (completed && index == _currentStepIndex) {
        // Find the next incomplete step
        final nextIncompleteIndex = updatedSteps.indexWhere((complete) => !complete, index + 1);
        if (nextIncompleteIndex != -1) {
          _currentStepIndex = nextIncompleteIndex;
        }
      }
    });
    
    // Here you would typically save the updated project to your storage
    // This would depend on how you're managing state in your app
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_project.pattern.title),
        backgroundColor: StitchPalTheme.primaryColor,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: StitchPalTheme.textColor,
          labelColor: StitchPalTheme.textColor,
          unselectedLabelColor: StitchPalTheme.textColor.withAlpha(
            (StitchPalTheme.textColor.alpha * 0.7).round()
          ),
          tabs: const [
            Tab(text: 'Pattern'),
            Tab(text: 'Progress'),
            Tab(text: 'Tools'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pattern tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProjectHeader(),
                const SizedBox(height: 16),
                _buildStepsTracker(),
              ],
            ),
          ),
          
          // Progress tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgressSection(),
                const SizedBox(height: 16),
                _buildStepChecklistView(),
              ],
            ),
          ),
          
          // Tools tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProjectTimer(
                  initialSeconds: _timerSeconds,
                  onTimerUpdate: (seconds) {
                    _timerSeconds = seconds;
                    // Here you would save the timer value
                  },
                ),
                const SizedBox(height: 16),
                StitchCounter(
                  initialCount: _stitchCount,
                  onCountChanged: (count) {
                    _stitchCount = count;
                    // Here you would save the stitch count
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project title and skill level
            Row(
              children: [
                Expanded(
                  child: Text(
                    _project.pattern.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SkillLevelBadge(level: _project.pattern.skillLevel),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Materials section
            Text(
              'Materials',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Materials list
            ...(_project.pattern.materials.map((material) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                      color: StitchPalTheme.accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          material.name,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          material.details,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ))).toList(),
            
            const SizedBox(height: 16),
            
            // Tags
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _project.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: StitchPalTheme.accentColor.withAlpha(
                      (StitchPalTheme.accentColor.alpha * 0.2).round()
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '#$tag',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: StitchPalTheme.textColor.withAlpha(
                        (StitchPalTheme.textColor.alpha * 0.7).round()
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Progress bar and percentage
            Row(
              children: [
                // Progress bar
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: _project.progress,
                        backgroundColor: StitchPalTheme.accentColor.withAlpha(
                          (StitchPalTheme.accentColor.alpha * 0.2).round()
                        ),
                        valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(_project.progress)),
                        borderRadius: BorderRadius.circular(2),
                        minHeight: 8,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        '${_project.completedSteps.where((step) => step).length} of ${_project.completedSteps.length} steps completed',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Percentage
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getProgressColor(_project.progress).withAlpha(
                      (_getProgressColor(_project.progress).alpha * 0.2).round()
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${(_project.progress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getProgressColor(_project.progress),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsTracker() {
    // Flatten all instructions into a single list for display
    final List<String> allSteps = [];
    final List<String> sectionTitles = [];
    final List<int> sectionStartIndices = [];
    
    int stepIndex = 0;
    for (final instruction in _project.pattern.instructions) {
      sectionTitles.add(instruction.sectionTitle);
      sectionStartIndices.add(stepIndex);
      
      for (final step in instruction.steps) {
        allSteps.add(step);
        stepIndex++;
      }
    }
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Instructions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Current step indicator
            if (_currentStepIndex < allSteps.length) ...[              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: StitchPalTheme.primaryColor.withAlpha(
                    (StitchPalTheme.primaryColor.alpha * 0.1).round()
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: StitchPalTheme.primaryColor,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Step',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      allSteps[_currentStepIndex],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () => _updateStepStatus(_currentStepIndex, true),
                          icon: const Icon(Icons.check),
                          label: const Text('Mark Complete'),
                          style: TextButton.styleFrom(
                            foregroundColor: StitchPalTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
            ],
            
            // Instruction sections
            ...List.generate(sectionTitles.length, (sectionIndex) {
              final sectionTitle = sectionTitles[sectionIndex];
              final startIndex = sectionStartIndices[sectionIndex];
              final endIndex = sectionIndex < sectionStartIndices.length - 1 
                  ? sectionStartIndices[sectionIndex + 1] - 1 
                  : allSteps.length - 1;
              
              return ExpansionTile(
                title: Text(
                  sectionTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: endIndex - startIndex + 1,
                    itemBuilder: (context, i) {
                      final stepIndex = startIndex + i;
                      final isCompleted = _project.completedSteps[stepIndex];
                      
                      return StepChecklistItem(
                        stepText: allSteps[stepIndex],
                        isCompleted: isCompleted,
                        isCurrent: stepIndex == _currentStepIndex,
                        onToggle: (completed) => _updateStepStatus(stepIndex, completed),
                      );
                    },
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStepChecklistView() {
    // Create a flat list of all steps for the checklist view
    final List<String> allSteps = [];
    
    for (final instruction in _project.pattern.instructions) {
      for (final step in instruction.steps) {
        allSteps.add(step);
      }
    }
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Step Checklist',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // List of all steps as a checklist
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: allSteps.length,
              itemBuilder: (context, index) {
                return StepChecklistItem(
                  stepText: 'Step ${index + 1}: ${allSteps[index]}',
                  isCompleted: _project.completedSteps[index],
                  isCurrent: index == _currentStepIndex,
                  onToggle: (completed) => _updateStepStatus(index, completed),
                );
              },
            ),
          ],
        ),
      ),
    );
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
}
