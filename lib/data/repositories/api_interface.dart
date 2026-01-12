import 'package:pmu/domain/models/card.dart';

abstract class ApiInterface {
  Future<List<CardData>?> loadData();
}
