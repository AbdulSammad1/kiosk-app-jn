
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kiosk_app/Models/kiosk_slider_items_model.dart';

class KioskSliderItemsProvider with ChangeNotifier {
  List<KioskSliderItemsModel> _sliderItems = [];
  List<KioskSliderItemsModel> get sliderItems => _sliderItems;

  final collectionRef =
      FirebaseFirestore.instance.collection('KioskSliderItems');

  Future<void> addSliderItem(KioskSliderItemsModel sliderItem) async {
    try {
      final response = await collectionRef.add({
        'imageUrl': sliderItem.imageUrl,
        'sliderImageOrder': sliderItem.sliderImageOrder,
        'promotion': sliderItem.promotion,
        'startDate': sliderItem.startDate,
        'endDate': sliderItem.endDate,
        'alignment': sliderItem.alignment
      });
      _sliderItems.add(KioskSliderItemsModel(
          id: response.id,
          imageUrl: sliderItem.imageUrl,
          sliderImageOrder: sliderItem.sliderImageOrder,
          promotion: sliderItem.promotion,
          startDate: sliderItem.startDate,
          endDate: sliderItem.endDate,
          alignment: sliderItem.alignment));

      notifyListeners();
    } on Exception {
      // TODO
    }
  }

  Future<void> updateSliderItem(KioskSliderItemsModel sliderItem) async {
    try {
      print('to update id: ${sliderItem.id}');
      print('to update imageUrl: ${sliderItem.imageUrl}');
      await collectionRef.doc(sliderItem.id).update({
        'imageUrl': sliderItem.imageUrl,
        'sliderImageOrder': sliderItem.sliderImageOrder,
        'promotion': sliderItem.promotion,
        'startDate': sliderItem.startDate,
        'endDate': sliderItem.endDate,
        'alignment': sliderItem.alignment
      });
      int index =
          _sliderItems.indexWhere((element) => sliderItem.id == element.id);

      _sliderItems[index] = sliderItem;

      notifyListeners();
    } on Exception {
      // TODO
    }
  }

  Future<List<KioskSliderItemsModel>> fetchDataByList() async {
    try {
      List<KioskSliderItemsModel> temp = [];

      final docsRef = await collectionRef.orderBy('sliderImageOrder').get();

      for (var doc in docsRef.docs) {
        final docData = doc.data();
        temp.add(
          KioskSliderItemsModel(
              id: doc.id,
              imageUrl: docData['imageUrl'],
              sliderImageOrder: docData['sliderImageOrder'],
              promotion: docData['promotion'],
              startDate: (docData['startDate'] as Timestamp).toDate(),
              endDate: (docData['endDate'] as Timestamp).toDate(),
              alignment: docData['alignment']),
        );
      }

      // Sort the items based on SliderImageOrder without changing the order in the list
      temp.sort((a, b) => a.sliderImageOrder.compareTo(b.sliderImageOrder));

      _sliderItems = temp;
      notifyListeners();
      return temp;
    } on Exception {
      // TODO
      rethrow;
    }
  }

  Future<void> updateSliderImageOrderOnBackend(
      List<KioskSliderItemsModel> items) async {
    final batch = FirebaseFirestore.instance.batch();
    for (int i = 0; i < items.length; i++) {
      final docRef = collectionRef.doc(items[i].id);
      batch.update(docRef, {'sliderImageOrder': i});
    }

    await batch.commit();
    for (int i = 0; i < items.length; i++) {
      int index =
          _sliderItems.indexWhere((element) => element.id == items[i].id);
      _sliderItems[index].sliderImageOrder = items[i].sliderImageOrder;
    }

    _sliderItems
        .sort((a, b) => a.sliderImageOrder.compareTo(b.sliderImageOrder));
    notifyListeners();
  }

  void updateSliderImageOrderLocally() {
    for (int i = 0; i < _sliderItems.length; i++) {
      _sliderItems[i].sliderImageOrder = i;
    }
    updateSliderImageOrderOnBackend(_sliderItems);
    notifyListeners();
  }

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      final itemToReorder = _sliderItems.removeAt(oldIndex);
      _sliderItems.insert(newIndex, itemToReorder);
    } else {
      final itemToReorder = _sliderItems.removeAt(oldIndex);
      _sliderItems.insert(newIndex, itemToReorder);
    }

    for (int i = 0; i < _sliderItems.length; i++) {
      _sliderItems[i].sliderImageOrder = i;
    }
    // updateSliderImageOrderLocally();
    notifyListeners();
  }
}
