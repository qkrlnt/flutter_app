import 'package:pmu/domain/models/card.dart';
import 'api_interface.dart';
import 'package:flutter/material.dart';

class MockRepository extends ApiInterface {
  @override
  Future<List<CardData>?> loadData() async {
    return [
      CardData(
        'Freeze',
        descriptionText: 'so cold..',
        imageUrl:
            'https://www.skedaddlewildlife.com/wp-content/uploads/2018/09/depositphotos_22425309-stock-photo-a-lonely-raccoon-in-winter.jpg',
      ),
      CardData(
        'Hi',
        descriptionText: 'pretty face',
        icon: Icons.hail,
        imageUrl:
            'https://www.thesprucepets.com/thmb/nKNaS4I586B_H7sEUw9QAXvWM_0=/2121x0/filters:no_upscale():strip_icc()/GettyImages-135630198-5ba7d225c9e77c0050cff91b.jpg',
      ),
      CardData(
        'Orange',
        descriptionText: 'I like autumn',
        icon: Icons.warning_amber,
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTo1Q3BZYep-V8uaUzhKBRwkZHernvssV55eQ&s',
      ),
    ];
  }
}
