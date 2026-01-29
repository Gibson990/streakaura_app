import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/project_provider.dart';
import '../../data/models/project_model.dart';

class ProjectSelector extends ConsumerWidget {
  final String? selectedProjectId;
  final Function(String?) onProjectSelected;

  const ProjectSelector({
    super.key,
    this.selectedProjectId,
    required this.onProjectSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsListProvider);
    final areas = ref.watch(areasProvider);
    final selectedProject = selectedProjectId != null
        ? ref.watch(projectRepositoryProvider).getProject(selectedProjectId!)
        : null;

    return Card(
      child: ListTile(
        leading: const Icon(Icons.folder_outlined, color: Colors.white70),
        title: const Text('Project'),
        subtitle: Text(
          selectedProject?.name ?? 'None',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white54),
        onTap: () => _showProjectPicker(context, ref, projects, areas),
      ),
    );
  }

  void _showProjectPicker(
    BuildContext context,
    WidgetRef ref,
    List<Project> projects,
    List<Project> areas,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('None'),
            leading: const Icon(Icons.close),
            onTap: () {
              onProjectSelected(null);
              Navigator.pop(context);
            },
          ),
          const Divider(),
          if (areas.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Areas',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            ...areas.map((area) => ListTile(
                  leading: Text(area.emoji, style: const TextStyle(fontSize: 24)),
                  title: Text(area.name),
                  trailing: selectedProjectId == area.id
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    onProjectSelected(area.id);
                    Navigator.pop(context);
                  },
                )),
            const Divider(),
          ],
          if (projects.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Projects',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            ...projects.map((project) => ListTile(
                  leading: Text(project.emoji, style: const TextStyle(fontSize: 24)),
                  title: Text(project.name),
                  trailing: selectedProjectId == project.id
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    onProjectSelected(project.id);
                    Navigator.pop(context);
                  },
                )),
          ],
        ],
      ),
    );
  }
}

