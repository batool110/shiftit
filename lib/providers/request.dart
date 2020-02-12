import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class Request with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  // final String imageUrl;
  final String contactNumber;
  final String fromWhere;
  final String toWhere;
  final String cnicNumber;
  final String capasity;
  final String date;
  final String expectedTime;
  final double price;
  bool isFavorite;

  Request({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.price,
    // @required this.imageUrl,
    @required this.contactNumber,
    @required this.fromWhere,
    @required this.toWhere,
    @required this.cnicNumber,
    @required this.capasity,
    @required this.date,
    @required this.expectedTime,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://shift-it-ab63b.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
