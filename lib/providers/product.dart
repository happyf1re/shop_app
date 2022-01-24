import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String title;
  final String? id;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.title,
    required this.id,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false});

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}

