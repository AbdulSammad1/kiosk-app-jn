import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiosk_app/Models/categorieItem.dart';

class categoryItemProvider with ChangeNotifier {
  List<categoryItem> _categories = [];

  List<categoryItem> get categories => _categories;

  void addNewCategory(categoryItem product) async {
    try {
      final fireInsctance = FirebaseFirestore.instance;
      final collectionRef = fireInsctance.collection('category');
      final response = await collectionRef.add({
        'title': product.title,
        'imageUrl': product.imageUrl,
        'color': product.itemColor
      });
      _categories.add(categoryItem(
          id: response.id,
          title: product.title,
          imageUrl: product.imageUrl,
          itemColor: product.itemColor));

      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> fetchData() async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('category');
      final response = await collectionRef.get();

      List<categoryItem> temp = [];

      for (var doc in response.docs) {
        final docData = doc.data();
        temp.add(categoryItem(
            id: doc.id,
            title: docData['title'],
            imageUrl: docData['imageUrl'],
            itemColor: docData['color']));
      }
      _categories = temp;
      print(_categories.length);
      print(categories.length);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<List<categoryItem>> fetchDataByList() async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('category');
      final response = await collectionRef.get();

      List<categoryItem> temp = [];

      for (var doc in response.docs) {
        final docData = doc.data();
        temp.add(categoryItem(
            id: doc.id,
            title: docData['title'],
            imageUrl: docData['imageUrl'],
            itemColor: docData['color']));
      }
      _categories = temp;
      notifyListeners();
      return temp;
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  categoryItem findCategoryById(String id) {
    return _categories.firstWhere((element) => element.id == id);
  }

  void deleteUnit(String id) async {
    try {
      final fireInsctance = FirebaseFirestore.instance;
      final collectionRef = fireInsctance.collection('category').doc(id);
      await collectionRef.delete();
      _categories.removeWhere(
        (element) => element.id == id,
      );
      notifyListeners();
    } on Exception {}
  }

  void updateUnit(categoryItem product) async {
    try {
      print('the newly generated url ${product.imageUrl}');
      final fireInsctance = FirebaseFirestore.instance;
      final collectionRef =
          fireInsctance.collection('category').doc(product.id);
      await collectionRef.update({
        'title': product.title,
        'imageUrl': product.imageUrl,
        'color': product.itemColor
      });
      final index =
          _categories.indexWhere((element) => element.id == product.id);
      _categories[index] = product;
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }
}
