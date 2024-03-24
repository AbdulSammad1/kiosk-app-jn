import 'package:flutter/cupertino.dart';

import '../Models/add_ons_model.dart';

class AddOnsProvider with ChangeNotifier {
  Map<String, AddOnsModel> _items = {};

  Map<String, AddOnsModel> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  num get totalAmount {
    var total = 0.0;

    _items.forEach((key, inventoryItem) {
      total += inventoryItem.stockPrice * inventoryItem.quantity;
    });

    return total;
  }

  num get totalQuantity {
    num total = 0;

    _items.forEach((key, inventoryItem) {
      total += inventoryItem.quantity;
    });

    return total;
  }

  void addItem(String productId, String barCode, num stockPrice, num salePrice,
      String title, String image, String unit) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingValue) => AddOnsModel(
            id: existingValue.id,
            barCode: existingValue.barCode,
            title: existingValue.title,
            quantity: existingValue.quantity + 1,
            stockPrice: existingValue.stockPrice,
            salePrice: existingValue.salePrice,
            unit: existingValue.unit,
            image: existingValue.image),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => AddOnsModel(
          id: productId,
          barCode: barCode,
          title: title,
          quantity: 1,
          stockPrice: stockPrice,
          salePrice: salePrice,
          unit: unit,
          image: image,
        ),
      );
    }
    notifyListeners();
  }

  void addItemsList(List<AddOnsModel> itemList) {
    for (var item in itemList) {
      if (_items.containsKey(item.id)) {
        _items.update(
          item.id,
          (existingValue) => AddOnsModel(
            id: existingValue.id,
            barCode: existingValue.barCode,
            title: existingValue.title,
            quantity: existingValue.quantity + item.quantity,
            stockPrice: existingValue.stockPrice,
            salePrice: existingValue.salePrice,
            unit: existingValue.unit,
            image: existingValue.image,
          ),
        );
      } else {
        _items.putIfAbsent(
          item.id,
          () => AddOnsModel(
            id: item.id,
            barCode: item.barCode,
            title: item.title,
            quantity: item.quantity,
            stockPrice: item.stockPrice,
            salePrice: item.salePrice,
            unit: item.unit,
            image: item.image,
          ),
        );
      }
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (existingValue) => AddOnsModel(
            id: existingValue.id,
            barCode: existingValue.barCode,
            title: existingValue.title,
            quantity: existingValue.quantity - 1,
            stockPrice: existingValue.stockPrice,
            salePrice: existingValue.salePrice,
            unit: existingValue.unit,
            image: existingValue.image),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void updateItemQuantity(String productId, num quantity) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (quantity <= 0) {
      // If the quantity is zero or negative, remove the item
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (existingValue) => AddOnsModel(
            id: existingValue.id,
            barCode: existingValue.barCode,
            title: existingValue.title,
            quantity: quantity,
            stockPrice: existingValue.stockPrice,
            salePrice: existingValue.salePrice,
            unit: existingValue.unit,
            image: existingValue.image),
      );
    }
    notifyListeners();
  }

  void updateItemPrice(String productId, num price) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (price <= 0) {
      // If the quantity is zero or negative, remove the item
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (existingValue) => AddOnsModel(
            id: existingValue.id,
            barCode: existingValue.barCode,
            title: existingValue.title,
            quantity: existingValue.quantity,
            stockPrice: price,
            salePrice: existingValue.salePrice,
            unit: existingValue.unit,
            image: existingValue.image),
      );
    }
    notifyListeners();
  }

  void updateSaleItemPrice(String productId, num price) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (price <= 0) {
      // If the quantity is zero or negative, remove the item
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (existingValue) => AddOnsModel(
            id: existingValue.id,
            barCode: existingValue.barCode,
            title: existingValue.title,
            quantity: existingValue.quantity,
            stockPrice: existingValue.stockPrice,
            salePrice: price,
            unit: existingValue.unit,
            image: existingValue.image),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
