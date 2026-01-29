import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/project_model.dart';
import '../data/repositories/project_repository.dart';
import '../core/constants/app_constants.dart';

// Repository Provider
final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  final localBox = Hive.box<Project>(AppConstants.projectsBox);
  final firestore = null;
  final userId = null;
  
  return ProjectRepository(localBox, firestore: firestore, userId: userId);
});

// Projects Stream Provider
final projectsStreamProvider = StreamProvider<List<Project>>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return repository.watchProjects();
});

// Projects List Provider
final projectsListProvider = Provider<List<Project>>((ref) {
  return ref.watch(projectsStreamProvider).value ?? [];
});

// Areas Provider
final areasProvider = Provider<List<Project>>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return repository.getAreas();
});

// Projects (non-areas) Provider
final projectsOnlyProvider = Provider<List<Project>>((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return repository.getProjects();
});

// Project Service Provider
final projectServiceProvider = Provider((ref) {
  final repository = ref.watch(projectRepositoryProvider);
  return ProjectService(repository);
});

class ProjectService {
  final ProjectRepository _repository;

  ProjectService(this._repository);

  Future<void> addProject(Project project) async {
    await _repository.addProject(project);
  }

  Future<void> updateProject(Project project) async {
    await _repository.updateProject(project);
  }

  Future<void> deleteProject(String id) async {
    await _repository.deleteProject(id);
  }

  Future<void> archiveProject(String id) async {
    await _repository.archiveProject(id);
  }

  Future<void> unarchiveProject(String id) async {
    await _repository.unarchiveProject(id);
  }
}

