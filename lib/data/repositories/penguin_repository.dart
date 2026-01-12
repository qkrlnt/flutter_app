import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pmu/domain/models/card.dart';

import 'api_interface.dart';

class PenguinRepository extends ApiInterface {
  static const String _baseUrl = 'https://penguin.sjsharivker.workers.dev/api';

  // По README API (species параметр).
  static const List<String> _species = <String>[
    'emperor',
    'chinstrap',
    'magellanic',
    'humboldt',
    'royal',
  ];

  static const Map<String, String> _ruNames = <String, String>{
    'emperor': 'Императорский пингвин',
    'chinstrap': 'Антарктический пингвин',
    'magellanic': 'Магелланов пингвин',
    'humboldt': 'Гумбольдтов пингвин',
    'royal': 'Королевский пингвин',
    'erect_crested': 'Хохлатый пингвин',
  };

  static const Map<String, String> _facts = <String, String>{
    'emperor': 'Крупнейший вид. Обитает в Антарктике.',
    'chinstrap': 'Узнаваем по «ремешку» под подбородком.',
    'magellanic': 'Живёт у берегов Южной Америки.',
    'humboldt': 'Обитает у берегов Перу и Чили.',
    'royal': 'Похож на императорского, но меньше.',
    'erect_crested': 'Хохлатый, с яркими перьями на голове.',
  };

  static IconData _iconFor(String species) {
    return switch (species) {
      'emperor' => Icons.ac_unit,
      'chinstrap' => Icons.landscape,
      'magellanic' => Icons.waves,
      'humboldt' => Icons.public,
      'royal' => Icons.emoji_events,
      'erect_crested' => Icons.star,
      _ => Icons.pets,
    };
  }

  String? _lastFailure;

  @override
  Future<List<CardData>?> loadData() async {
    _lastFailure = null;

    final items = <CardData>[];

    // последовательно — проще и стабильнее
    for (final s in _species) {
      final one = await _fetchOne(species: s);
      if (one != null) items.add(one);
    }

    // Фоллбек: один случайный
    if (items.isEmpty) {
      final randomOne = await _fetchOne(species: null);
      if (randomOne != null) return [randomOne];
    }

    if (items.isEmpty) {
      throw Exception(_lastFailure ?? 'API не вернул данных');
    }

    return items;
  }

  Future<CardData?> _fetchOne({String? species}) async {
    final uri = Uri.parse(
      _baseUrl,
    ).replace(queryParameters: {if (species != null && species.isNotEmpty) 'species': species});

    try {
      final response = await http
          .get(uri, headers: const {'accept': 'application/json', 'user-agent': 'Mozilla/5.0'})
          .timeout(const Duration(seconds: 10));

      // ✅ принимаем любой 2xx (у вас как раз 201)
      if (response.statusCode < 200 || response.statusCode >= 300) {
        _lastFailure = 'HTTP ${response.statusCode} для $uri';
        debugPrint('[PenguinRepository] $_lastFailure; body=${response.body}');
        return null;
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        _lastFailure = 'Неверный JSON для $uri';
        debugPrint('[PenguinRepository] $_lastFailure; body=${response.body}');
        return null;
      }

      final img = decoded['img'] as String?;
      final sp = (decoded['species'] as String?) ?? species ?? 'penguin';

      if (img == null || img.isEmpty) {
        _lastFailure = 'Пустое поле img для $uri';
        debugPrint('[PenguinRepository] $_lastFailure; body=${response.body}');
        return null;
      }

      final normalized = sp.trim();

      return CardData(
        _ruNames[normalized] ?? 'Пингвин ($normalized)',
        descriptionText: _facts[normalized] ?? 'Случайный пингвин из PenguinImageAPI.',
        icon: _iconFor(normalized),
        imageUrl: img,
      );
    } catch (e) {
      _lastFailure = 'Ошибка запроса для $uri: $e';
      debugPrint('[PenguinRepository] $_lastFailure');
      return null;
    }
  }
}
