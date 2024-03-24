import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:kiosk_app/Models/add_ons_model.dart';
import 'package:kiosk_app/Models/categorieItem.dart';
import 'package:kiosk_app/Models/inventory_stock_model.dart';
import 'package:kiosk_app/Models/kiosk_data_model.dart';
import 'package:kiosk_app/Models/saleItemModel.dart';

import '../Models/sale_item_component_model.dart';

class SaleItemProvider with ChangeNotifier {
  List<saleItem> _saleItemList = [];

  List<saleItem> get saleItems => _saleItemList;

  final fireStoreInstance = FirebaseFirestore.instance;

  saleItem findById(String Id) {
    print(Id);
    return _saleItemList.firstWhere((product) => product.id == Id);
  }

  SaleItemComponent findComponentById(String componentId) {
    SaleItemComponent? foundComponent;
    for (var saleItem in _saleItemList) {
      for (var component in saleItem.components) {
        if (component.id == componentId) {
          foundComponent = component;
        }
      }
    }
    return foundComponent!;
  }

  Future<List<saleItem>> fetchDataByList() async {
    try {
      final collectionRef = fireStoreInstance.collection('saleItem');
      final data = await collectionRef.get();

      final List<saleItem> temp = [];

      for (var doc in data.docs) {
        final docData = doc.data();
        final categoryData = docData['category'] as Map<String, dynamic>;
        final category = categoryItem(
            id: categoryData['id'],
            title: categoryData['title'],
            imageUrl: categoryData['imageUrl'],
            itemColor: categoryData['color']);
        final kioskData = docData['kioskData'] as Map<String, dynamic>;
        final kiosk = KioskDataModel(
          isKioskItem: kioskData['isKioskItem'],
          discountPercentage: kioskData['discountPercentage'],
          discountedPrice: kioskData['discountedPrice'],
          discounted: kioskData['discounted'],
          featured: kioskData['featured'],
          description: kioskData['description'],
          imageUrls: List<String>.from(kioskData['imageUrls']),
        );

        temp.add(
          saleItem(
              id: doc.id,
              title: docData['title'],
              alias: docData['alias'],
              barCode: docData['barCode'],
              stockPrice: docData['costPrice'],
              salePrice: docData['salePrice'],
              taxAmount: docData['taxAmount'],
              imageUrl: docData['imageUrl'],
              itemColor: docData['imageColor'],
              category: category,
              ingredients: (docData['ingredients'] as List<dynamic>)
                  .map((e) => InventoryStockModel(
                      id: e['id'],
                      unit: e['measuringUnit'],
                      quantity: e['quantity'],
                      stockPrice: e['stockPrice'],
                      barCode: e['barCode'],
                      title: e['name'],
                      salePrice: e['salePrice'],
                      image: '1'))
                  .toList(),
              components: docData['components'] == null
                  ? []
                  : (docData['components'] as List<dynamic>)
                      .map((e) => SaleItemComponent(
                          id: e['id'],
                          componentName: e['componentName'],
                          selectionType: e['selectionType'] ?? '',
                          isRequired: e['isRequired'],
                          items: (e['items'] as List<dynamic>)
                              .map((e) => InventoryStockModel(
                                  id: e['id'],
                                  unit: e['measuringUnit'],
                                  quantity: e['quantity'],
                                  stockPrice: e['stockPrice'],
                                  barCode: e['barCode'],
                                  title: e['name'],
                                  salePrice: e['salePrice'],
                                  image: '1'))
                              .toList()))
                      .toList(),
              addOns: (docData['addOns'] as List<dynamic>)
                  .map((e) => AddOnsModel(
                      id: e['id'],
                      unit: e['measuringUnit'],
                      quantity: e['quantity'],
                      stockPrice: e['stockPrice'],
                      barCode: e['barCode'],
                      title: e['name'],
                      salePrice: e['salePrice'],
                      image: e['imageUrl']))
                  .toList(),
              kioskData: kiosk),
        );
      }
      print('hello');
      _saleItemList = temp;

      notifyListeners();

      return temp;
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  KioskDataModel getKioskDataById(String id) {
    try {
      final saleItem = _saleItemList.firstWhere((item) => item.id == id);
      return saleItem.kioskData;
    } catch (e) {
      print(e);
      // Return a default KioskDataModel or handle the exception as needed
      return KioskDataModel(
          isKioskItem: false,
          discountPercentage: 0,
          discountedPrice: 0,
          discounted: false,
          featured: false,
          imageUrls: [],
          description: '');
    }
  }
}
