import 'package:pmu/domain/models/card.dart';

class HomeState {
  final List<CardData> items;
  final String query;
  final bool isLoading;
  final String? error;

  const HomeState({
    this.items = const <CardData>[],
    this.query = '',
    this.isLoading = false,
    this.error,
  });

  List<CardData> get filteredItems {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return items;

    return items
        .where((c) {
          final t = c.text.toLowerCase();
          final d = c.descriptionText.toLowerCase();
          return t.contains(q) || d.contains(q);
        })
        .toList(growable: false);
  }

  HomeState copyWith({List<CardData>? items, String? query, bool? isLoading, String? error}) {
    return HomeState(
      items: items ?? this.items,
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
