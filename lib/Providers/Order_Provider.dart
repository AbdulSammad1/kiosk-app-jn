import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kiosk_app/Models/Order_Model.dart';
import 'package:mek_stripe_terminal/mek_stripe_terminal.dart';

class OrderProvider with ChangeNotifier {
  final List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;
  bool isLoading = false;
  static PaymentStatus termianl_variable_paymentStatus = PaymentStatus.notReady;

  String orderNumber = '';
  final collectionRef = FirebaseFirestore.instance.collection('Orders');

  Future<bool> addOrder(OrderModel newOrder) async {
    isLoading = true;
    try {
      final response = await collectionRef.add({
        'employeeName': newOrder.employeeName,
        'orderType': newOrder.orderType,
        'orderClassification': newOrder.orderClassification,
        'orderNumber': newOrder.orderNumber,
        'remarks': newOrder.remarks,
        'customerId': newOrder.customer.id,
        'completeTime': DateTime.now(),
        
        'date': newOrder.date,
        'status': newOrder.status,
        'loyaltyPoints': newOrder.loyaltyPoints,
        'loyaltyMoney': newOrder.loyaltyMoney,
        'totalPrice': newOrder.totalPrice,
        'orderItems': newOrder.orderItems.map((e) => {
              'saleItem': {
                'id': e.item.id,
                'title': e.item.title,
                'alias': e.item.alias,
                'salePrice': e.item.salePrice,
                'stockPrice': e.item.stockPrice,
                'categoryColor': e.item.category.itemColor,
                'kioskData': {
                  'discountPercentage': e.item.kioskData.discountPercentage,
                  'discountedPrice': e.item.kioskData.discountedPrice,
                  'discounted': e.item.kioskData.discounted,
                  'featured': e.item.kioskData.featured,
                  'isKioskItem': e.item.kioskData.isKioskItem,
                  'description': e.item.kioskData.description,
                  'imageUrls': e.item.kioskData.imageUrls
                },
                'selectedComponents': e.slectedComponents.map((e) => {
                      'id': e.id,
                      'componentName': e.componentName,
                      'item': {
                        'id': e.item.id,
                        'barCode': e.item.barCode,
                        'title': e.item.title,
                        'quantity': e.item.quantity,
                        'stockPrice': e.item.stockPrice,
                        'salePrice': e.item.salePrice,
                        'unit': e.item.unit,
                        'imageUrl': e.item.image
                      }
                    }),
                'ingredients': e.item.ingredients
                    .map((ingredient) => {
                          'id': ingredient.id,
                          'name': ingredient.title,
                          'barCode': ingredient.barCode,
                          'quantity': ingredient.quantity,
                          'stockPrice': ingredient.stockPrice,
                          'salePrice': ingredient.salePrice,
                          'measuringUnit': ingredient.unit,
                        })
                    .toList(),
              },
              'status': e.completed,
              'quantity': e.quantity,
              'note': e.note,
              'isPrinted': e.isPrinted,
              'totalPrice': e.totalPrice,
              'addons': e.addons.map((e) => {
                    'id': e.id,
                    'barCode': e.barCode,
                    'title': e.title,
                    'quantity': e.quantity,
                    'stockPrice': e.stockPrice,
                    'salePrice': e.salePrice,
                    'unit': e.unit,
                    'imageUrl': e.image
                  })
            })
      });
      updateInventoryQuantities(newOrder);
      _orders.add(OrderModel(
          employeeName: newOrder.employeeName,
          totalPrice: newOrder.totalPrice,
          id: response.id,
          orderItems: newOrder.orderItems,
          orderClassification: newOrder.orderClassification,
          completeTime: DateTime.now(),
          orderType: newOrder.orderType,
          remarks: newOrder.remarks,
          customer: newOrder.customer,
          date: DateTime.now(),
          orderNumber: newOrder.orderNumber,
          loyaltyMoney: newOrder.loyaltyMoney,
          status: 'inProgress',
          loyaltyPoints: newOrder.loyaltyPoints,
          ));
      notifyListeners();
      isLoading = false;
      return true;
    } catch (e) {
      print(e);
      isLoading = false;
      rethrow;
    }
  }

  // Future<void> updateOrderItemStatus(
  //     String orderId, int index, bool newStatus) async {
  //   final collectionRef = FirebaseFirestore.instance.collection('Orders');
  //   final orderDoc = await collectionRef.doc(orderId);
  //   print('id: $orderId');
  //   print('index: $index');
  //   String fieldPath = 'orderItems.$index.status';

  //   try {
  //     await orderDoc.update({
  //       FieldPath([fieldPath]): newStatus
  //     });
  //   } on Exception catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> updateOrderItemStatus(
  //     String orderId, int index, bool newStatus) async {
  //   final collectionRef = FirebaseFirestore.instance.collection('Orders');
  //   final orderDoc = collectionRef.doc(orderId);
  //   print(
  //       'Updating order with ID: $orderId, Index: $index, New Status: $newStatus');

  //   try {
  //     await orderDoc.update({'orderItems.$index.status': newStatus});
  //     print('Update successful');
  //   } catch (e) {
  //     print('Error updating order: $e');
  //   }
  // }

  Future<int> getDocumentCountForCurrentDate() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final firestore = FirebaseFirestore.instance;
    final collection = firestore
        .collection('Orders'); // Replace with your actual collection name

    final query = collection
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThanOrEqualTo: endOfDay);

    final querySnapshot = await query.get();

    return querySnapshot.size;
  }

  Future<void> updateOrderItemStatus(
      String orderId, int index, bool newStatus) async {
    final collectionRef = FirebaseFirestore.instance.collection('Orders');
    final orderDoc = collectionRef.doc(orderId);

    try {
      // Fetch the current order document data
      final orderSnapshot = await orderDoc.get();
      final orderData = orderSnapshot.data();

      if (orderData != null) {
        // Update the status of the specific orderItem
        final orderItems =
            List<Map<String, dynamic>>.from(orderData['orderItems']);
        if (index >= 0 && index < orderItems.length) {
          orderItems[index]['status'] = newStatus;

          // Update the order document with the modified orderItems
          await orderDoc.update({'orderItems': orderItems});
          print('Update successful');
        } else {
          print('Invalid index');
        }
      } else {
        print('Order document not found');
      }
    } catch (e) {
      print('Error updating order: $e');
    }
  }

  Future<void> updateOrderItemPrintStatus(
      String orderId, List<int> indexes, bool newStatus) async {
    final collectionRef = FirebaseFirestore.instance.collection('Orders');
    final orderDoc = collectionRef.doc(orderId);

    try {
      // Fetch the current order document data
      final orderSnapshot = await orderDoc.get();
      final orderData = orderSnapshot.data();

      if (orderData != null) {
        // Update the status of the specific orderItem
        final orderItems =
            List<Map<String, dynamic>>.from(orderData['orderItems']);
        for (int index in indexes) {
          orderItems[index]['isPrinted'] = newStatus;

          // Update the order document with the modified orderItems
          await orderDoc.update({'orderItems': orderItems});
          print('Update successful');
        }
      } else {
        print('Order document not found');
      }
    } catch (e) {
      print('Error updating order: $e');
    }
  }

 Future<void> updateInventoryQuantities(OrderModel orderObject) async {
    final inventoryCollection =
        FirebaseFirestore.instance.collection('Inventory');
    final Map<String, int> quantityChanges = {};

    try {
      // Aggregate quantities locally for ingredients, addons, and selected components
      for (final orderItem in orderObject.orderItems) {
        // Ingredients
        for (final ingredient in orderItem.item.ingredients) {
          final quantityToDecrement =
              -1 * ingredient.quantity * orderItem.quantity;
          quantityChanges.update(ingredient.id,
              (value) => value.toInt() + quantityToDecrement.toInt(),
              ifAbsent: () => quantityToDecrement.toInt());
        }

        // Addons
        for (final addon in orderItem.addons) {
          final defaultAddon = orderItem.item.addOns
              .firstWhere((element) => element.id == addon.id);
          final quantityToDecrement =
              -1 * addon.quantity * defaultAddon.quantity * orderItem.quantity;
          quantityChanges.update(
              addon.id, (value) => value.toInt() + quantityToDecrement.toInt(),
              ifAbsent: () => quantityToDecrement.toInt());
        }

        // Selected Components
        for (final component in orderItem.slectedComponents) {
          final quantityToDecrement =
              -1 * component.item.quantity * orderItem.quantity;
          quantityChanges.update(component.item.id,
              (value) => value.toInt() + quantityToDecrement.toInt(),
              ifAbsent: () => quantityToDecrement.toInt());
        }
      }

      // Perform batch update for each inventory item
      final batch = FirebaseFirestore.instance.batch();
      for (final entry in quantityChanges.entries) {
        final inventoryDocRef = inventoryCollection.doc(entry.key);
        batch.update(inventoryDocRef,
            {'numberOfUnits': FieldValue.increment(entry.value)});
      }

      // Commit the batch update
      await batch.commit();
    } catch (e) {
      print('Error: $e');
      // Handle error accordingly
    }
  }

  List<OrderModel> getCompletedOrders() {
    final temp =
        orders.where((element) => element.status == 'Completed').toList();
    return temp;
  }

  Future<String> getOrderNumber() async {
    final currentDate = DateTime.now();
    final startOfDay =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    int orderLength = 0;

    try {
      final snapshot = await collectionRef
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .orderBy('date', descending: true)
          .get();

      for (var element in snapshot.docs) {
        String orderNumbers = element.data()['orderNumber'];
        if (!orderNumbers.startsWith('CO')) {
          orderLength++;
        }
      }

      final orderNumber = '${getCurrentDate()}0${orderLength + 1}';
      return orderNumber;
    } catch (e) {
      // Handle errors as needed
      print('Error fetching order number: $e');
      throw Exception('Failed to fetch order number');
    }
  }

  String getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('yyMMdd');
    return formatter.format(now);
  }

  List<OrderModel> getInProgressOrders() {
    final temp =
        orders.where((element) => element.status == 'InProgress').toList();
    return temp;
  }

  String calculateOrderNumber(String previousOrderNumber) {
    print('Calculating the orderNumber');

    final String orderNumber = '${int.parse(previousOrderNumber) + 1}';

    return orderNumber;
  }
}
