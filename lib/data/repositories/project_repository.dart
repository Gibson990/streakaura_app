import 'package:hive/hive.dart';

import '../models/project_model.dart';

class ProjectRepository {
  final Box<Project> _localBox;
  final dynamic firestore; // Use dynamic to avoid import error
  final String? userId;

  ProjectRepository(this._localBox, {this.firestore, this.userId});

  Stream<List<Project>> watchProjects() {
    return _localBox.watch().map((_) => _localBox.values.toList());
  }

  List<Project> getAllProjects() {
    return _localBox.values.toList();
  }

  List<Project> getAreas() {
    return _localBox.values.where((p) => p.isArea && !p.isArchived).toList();
  }

  List<Project> getProjects() {
    return _localBox.values.where((p) => !p.isArea && !p.isArchived).toList();
  }

  List<Project> getProjectsByArea(String areaId) {
    return _localBox.values
        .where((p) => !p.isArea && p.areaId == areaId && !p.isArchived)
        .toList();
  }

  Future<void> addProject(Project project) async {
    await _localBox.put(project.id, project);
    
    // Cloud sync skipped as Firebase is not initialized
    // if (firestore != null && userId != null) { ... }
  }

  Future<void> updateProject(Project project) async {
    await project.save();
    
    // Cloud sync skipped as Firebase is not initialized
    // if (firestore != null && userId != null) { ... }
  }

  Future<void> deleteProject(String id) async {
    await _localBox.delete(id);
    
    // Cloud sync skipped as Firebase is not initialized
    // if (firestore != null && userId != null) { ... }
  }

  Future<void> archiveProject(String id) async {
    final project = _localBox.get(id);
    if (project != null) {
      project.isArchived = true;
      await project.save();
    }
  }

  Future<void> unarchiveProject(String id) async {
    final project = _localBox.get(id);
    if (project != null) {
      project.isArchived = false;
      await project.save();
    }
  }

  Project? getProject(String id) {
    return _localBox.get(id);
  }

  Future<void> syncFromCloud() async {
    // Cloud sync skipped as Firebase is not initialized
    return;
  }
}

