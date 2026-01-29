import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/models/tag_model.dart';
import '../data/repositories/tag_repository.dart';
import '../core/constants/app_constants.dart';
import 'habit_provider.dart';

// Repository Provider
final tagRepositoryProvider = Provider<TagRepository>((ref) {
  final localBox = Hive.box<Tag>(AppConstants.tagsBox);
  final firestore = null;
  final userId = null;
  
  return TagRepository(localBox, firestore: firestore, userId: userId);
});

// Tags Stream Provider
final tagsStreamProvider = StreamProvider<List<Tag>>((ref) {
  final repository = ref.watch(tagRepositoryProvider);
  return repository.watchTags();
});

// Tags List Provider
final tagsListProvider = Provider<List<Tag>>((ref) {
  return ref.watch(tagsStreamProvider).value ?? [];
});

// Tag Service Provider
final tagServiceProvider = Provider((ref) {
  final repository = ref.watch(tagRepositoryProvider);
  return TagService(repository);
});

class TagService {
  final TagRepository _repository;

  TagService(this._repository);

  Future<void> addTag(Tag tag) async {
    await _repository.addTag(tag);
  }

  Future<void> updateTag(Tag tag) async {
    await _repository.updateTag(tag);
  }

  Future<void> deleteTag(String id) async {
    await _repository.deleteTag(id);
  }

  int getTagUsageCount(String tagId, ref) {
    final habits = ref.read(habitsListProvider);
    return _repository.getTagUsageCount(tagId, habits);
  }
}

