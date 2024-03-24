import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Models/Inventory_Component.dart';

class InventoryComponentProvider with ChangeNotifier {
  List<InventoryComponent> _items = [];

  List<InventoryComponent> get items => _items;

  FirebaseFirestore fireInstance = FirebaseFirestore.instance;

  InventoryComponent findById(String Id) {
    return _items.firstWhere((product) => product.id == Id);
  }

  InventoryComponent findByBarcode(String barCode) {
    return _items.firstWhere(
      (product) => product.barcode == barCode,
    );
  }

  Future<List<InventoryComponent>> fethDataByList() async {
    try {
      final collectionref = fireInstance.collection('Inventory');
      final response = await collectionref.get();

      final List<InventoryComponent> temporary = [];
      for (var doc in response.docs) {
        final docData = doc.data();
        temporary.add(InventoryComponent(
          id: doc.id,
          measuringUnit: docData['measuringUnit'],
          numberOfUnits: docData['numberOfUnits'],
          stockPrice: docData['stockPrice'],
          barcode: docData['barcode'],
          descritpion: docData['descryption'],
          name: docData['name'],
          imageUrl: docData['imagePath'],
          salePrice: docData['salePrice'],
        ));
      }
      _items = temporary;

      notifyListeners();

      return temporary;
    } on Exception {
      rethrow;
    }
  }

  num calculateAverage(
      {required num oldQty,
      required newQty,
      required num newPrice,
      required oldPrice}) {
    return ((oldQty * oldPrice) + (newQty * newPrice)) / (newQty + oldQty);
  }
}
