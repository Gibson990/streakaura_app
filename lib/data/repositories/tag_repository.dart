import 'package:hive/hive.dart';

import '../models/tag_model.dart';

class TagRepository {
  final Box<Tag> _localBox;
  final dynamic firestore; // Use dynamic to avoid import error
  final String? userId;

  TagRepository(this._localBox, {this.firestore, this.userId});

  Stream<List<Tag>> watchTags() {
    return _localBox.watch().map((_) => _localBox.values.toList());
  }

  List<Tag> getAllTags() {
    return _localBox.values.toList();
  }

  int getTagUsageCount(String tagId, List<dynamic> allHabits) {
    // Count how many habits use this tag
    // allHabits should be List<Habit> but using dynamic to avoid circular dependency
    return allHabits
        .where((habit) => (habit as dynamic).tags.contains(tagId))
        .length;
  }

  Future<void> addTag(Tag tag) async {
    await _localBox.put(tag.id, tag);
    
    // Cloud sync skipped as Firebase is not initialized
    // if (firestore != null && userId != null) { ... }
  }

  Future<void> updateTag(Tag tag) async {
    await tag.save();
    
    // Cloud sync skipped as Firebase is not initialized
    // if (firestore != null && userId != null) { ... }
  }

  Future<void> deleteTag(String id) async {
    await _localBox.delete(id);
    
    // Cloud sync skipped as Firebase is not initialized
    // if (firestore != null && userId != null) { ... }
  }

  Tag? getTag(String id) {
    return _localBox.get(id);
  }

  Future<void> syncFromCloud() async {
    // Cloud sync skipped as Firebase is not initialized
    return;
  }
}

