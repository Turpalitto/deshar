import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/word_entity.dart';
import 'asset_dictionary_parser.dart';

class AssetDictionaryDataSource {
  Future<List<WordEntity>> loadBundledDictionary() async {
    final curatedRaw = await rootBundle.loadString('assets/data/curated_vocabulary.json');
    final dictRaw = await rootBundle.loadString('assets/data/dictionary.json');

    return compute(parseBundledDictionaryIsolate, {
      'curated': curatedRaw,
      'dictionary': dictRaw,
    });
  }

  Future<List<Map<String, dynamic>>> loadLessonsJson() async {
    final raw = await rootBundle.loadString('assets/data/lessons.json');
    return List<Map<String, dynamic>>.from(jsonDecode(raw) as List);
  }

  Future<List<Map<String, dynamic>>> loadLearningPathJson() async {
    final raw = await rootBundle.loadString('assets/data/learning_path.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return List<Map<String, dynamic>>.from(data['units'] as List);
  }
}
