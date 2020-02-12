import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './request.dart';

class Requests with ChangeNotifier {
  List<Request> _items = [];
  // var _showFavoritesOnly = false;
  final String authToken;
  final String userId;

  Requests(this.authToken, this.userId, this._items);

  List<Request> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Request> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Request findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetRequests([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url =
        'https://shift-it-ab63b.firebaseio.com/request.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://shift-it-ab63b.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Request> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Request(
          id: prodId,
          name: prodData['name'],
          description: prodData['description'],
          price: prodData['price'],
          contactNumber: prodData['contactNumber'],
          fromWhere: prodData['fromWhere'],
          toWhere: prodData['toWhere'],
          capasity: prodData['capasity'],
          date: prodData['date'],
          expectedTime: prodData['expectedTime'],
          cnicNumber: prodData['cnicNumber'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
          // imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addRequest(Request request) async {
    final url =
        'https://shift-it-ab63b.firebaseio.com/request.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'name': request.name,
          'description': request.description,
          // 'imageUrl': request.imageUrl,
          'price': request.price,
          'contactNumber': request.contactNumber,
          'fromWhere': request.fromWhere,
          'toWhere': request.toWhere,
          'capasity': request.capasity,
          'date': request.date,
          'expectedTime': request.expectedTime,
          'creatorId': userId,
        }),
      );
      final newProduct = Request(
        name: request.name,
        description: request.description,
        price: request.price,
        // imageUrl: product.imageUrl,
        contactNumber: request.contactNumber,
        fromWhere: request.fromWhere,
        toWhere: request.toWhere,
        capasity: request.capasity,
        date: request.date,
        expectedTime: request.expectedTime,
        cnicNumber: request.cnicNumber,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateRequest(String id, Request newRequest) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shift-it-ab63b.firebaseio.com/request/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'name': newRequest.name,
            'description': newRequest.description,
            // 'imageUrl': newProduct.imageUrl,
            'price': newRequest.price,
            'contactNumber': newRequest.contactNumber,
            'fromWhere': newRequest.fromWhere,
            'toWhere': newRequest.toWhere,
            'capasity': newRequest.capasity,
            'date': newRequest.date,
            'expectedTime': newRequest.expectedTime,
            'cnicNumber' : newRequest.cnicNumber,
          }));
      _items[prodIndex] = newRequest;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteRequest(String id) async {
    final url =
        'https://shift-it-ab63b.firebaseio.com/request/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
