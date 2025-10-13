import 'package:flutter/material.dart';
import '../models/food.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, int> _items = {}; // foodId -> quantity

  Map<String, int> get items => {..._items};

  void addItem(Food food) {
    if (_items.containsKey(food.id)) {
      _items[food.id] = _items[food.id]! + 1;
    } else {
      _items[food.id] = 1;
    }
    notifyListeners();
  }

  void removeSingle(String foodId) {
    if (!_items.containsKey(foodId)) return;
    if (_items[foodId]! > 1) {
      _items[foodId] = _items[foodId]! - 1;
    } else {
      _items.remove(foodId);
    }
    notifyListeners();
  }

  void removeAll(String foodId) {
    _items.remove(foodId);
    notifyListeners();
  }

  int quantity(String foodId) => _items[foodId] ?? 0;

  double totalAmount(List<Food> allFoods) {
    double total = 0.0;
    for (final entry in _items.entries) {
      final prod = allFoods.firstWhere((f) => f.id == entry.key);
      total += prod.price * entry.value;
    }
    return total;
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
