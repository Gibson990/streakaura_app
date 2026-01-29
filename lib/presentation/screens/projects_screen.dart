import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';
import '../../providers/project_provider.dart';
import '../../providers/habit_provider.dart';
import '../../data/models/project_model.dart';
import '../../features/habits/presentation/widgets/habit_list_item.dart';
import 'add_edit_habit_screen.dart';

class ProjectsScreen extends ConsumerWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsListProvider);
    final areas = ref.watch(areasProvider);
    final projectService = ref.read(projectServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddProjectDialog(context, ref),
          ),
        ],
      ),
      body: projects.isEmpty && areas.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_outlined,
                    size: 64,
                    color: Colors.white54,
                  ),
                  const Gap(16),
                  Text(
                    'No projects yet',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Gap(8),
                  Text(
                    'Create a project to organize your habits',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Areas Section
                if (areas.isNotEmpty) ...[
                  Text(
                    'Areas',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Gap(12),
                  ...areas.map((area) => _ProjectCard(
                        project: area,
                        onTap: () => _showProjectDetails(context, ref, area),
                        onEdit: () => _showEditProjectDialog(context, ref, area),
                        onDelete: () => projectService.deleteProject(area.id),
                      )),
                  const Gap(24),
                ],
                // Projects Section
                if (projects.isNotEmpty) ...[
                  Text(
                    'Projects',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Gap(12),
                  ...projects.map((project) => _ProjectCard(
                        project: project,
                        onTap: () => _showProjectDetails(context, ref, project),
                        onEdit: () => _showEditProjectDialog(context, ref, project),
                        onDelete: () => projectService.deleteProject(project.id),
                      )),
                ],
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProjectDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProjectDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final emojiController = TextEditingController(text: '📁');
    bool isArea = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isArea ? 'New Area' : 'New Project'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Work, Health, Personal...',
                ),
              ),
              const Gap(12),
              TextField(
                controller: emojiController,
                decoration: const InputDecoration(
                  labelText: 'Emoji',
                ),
                maxLength: 2,
              ),
              const Gap(12),
              SwitchListTile(
                value: isArea,
                onChanged: (v) => setState(() => isArea = v),
                title: const Text('This is an Area'),
                subtitle: const Text('Areas contain projects'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  final project = Project(
                    id: const Uuid().v4(),
                    name: nameController.text.trim(),
                    emoji: emojiController.text.trim().isEmpty
                        ? '📁'
                        : emojiController.text.trim(),
                    colorValue: Colors.blue.value,
                    createdAt: DateTime.now(),
                    isArea: isArea,
                  );
                  ref.read(projectServiceProvider).addProject(project);
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProjectDialog(
      BuildContext context, WidgetRef ref, Project project) {
    final nameController = TextEditingController(text: project.name);
    final emojiController = TextEditingController(text: project.emoji);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(project.isArea ? 'Edit Area' : 'Edit Project'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            const Gap(12),
            TextField(
              controller: emojiController,
              decoration: const InputDecoration(
                labelText: 'Emoji',
              ),
              maxLength: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                project.name = nameController.text.trim();
                project.emoji = emojiController.text.trim().isEmpty
                    ? '📁'
                    : emojiController.text.trim();
                ref.read(projectServiceProvider).updateProject(project);
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showProjectDetails(BuildContext context, WidgetRef ref, Project project) {
    final habits = ref.watch(habitsByProjectProvider(project.id));
    final habitService = ref.read(habitServiceProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    project.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Text(
                      project.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: habits.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'No habits in this ${project.isArea ? 'area' : 'project'}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Gap(16),
                          FilledButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const AddEditHabitScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add Habit'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: habits.length,
                      itemBuilder: (context, index) {
                        final habit = habits[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: HabitListItem(
                            habit: habit,
                            onToggle: () async {
                              await habitService.toggleCheckIn(habit);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProjectCard({
    required this.project,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final habitsCount = 0; // Will be calculated from provider

    return Card(
      child: ListTile(
        leading: Text(
          project.emoji,
          style: const TextStyle(fontSize: 32),
        ),
        title: Text(project.name),
        subtitle: Text('${habitsCount} ${habitsCount == 1 ? 'habit' : 'habits'}'),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('Edit'),
              onTap: onEdit,
            ),
            PopupMenuItem(
              child: const Text('Delete'),
              onTap: onDelete,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

