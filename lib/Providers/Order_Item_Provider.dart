import 'package:flutter/material.dart';
import 'package:kiosk_app/Models/Order_Item_Model.dart';
import 'package:kiosk_app/Models/add_ons_model.dart';
import 'package:kiosk_app/Models/selected_component_model.dart';
import 'package:kiosk_app/Providers/admin_provider.dart';
import 'package:provider/provider.dart';

class OrderItemsProvider with ChangeNotifier {
  final List<OrderItemModel> _orderItems = [];
  List<OrderItemModel> get orderItems => _orderItems;

  void findOrderItem(
      BuildContext context,
      OrderItemModel itemToAdd,
      List<AddOnsModel> oldAddons,
      List<SelectedComponent> oldComponents,
      bool isNew) {
    bool addonResponse = true;
    bool componentResponse = true;

    for (int i = 0; i < _orderItems.length; i++) {
      final item = _orderItems[i];
      if (item.item.id == itemToAdd.item.id) {
        if (item.addons.length == oldAddons.length) {
          addonResponse = true;
          for (final oldAddon in oldAddons) {
            if (!item.addons.any((addon) =>
                addon.id == oldAddon.id &&
                addon.quantity == oldAddon.quantity)) {
              addonResponse = false;
              break;
            }
          }
        } else {
          addonResponse = false;
        }

        if (item.slectedComponents.length == oldComponents.length) {
          print('came here');
          componentResponse = true;
          for (final oldComponent in oldComponents) {
            if (!item.slectedComponents.any((component) =>
                component.id == oldComponent.id &&
                component.item == oldComponent.item)) {
              componentResponse = false;
              break;
            }
          }
        } else {
          componentResponse = false;
        }

        if (addonResponse && componentResponse) {
          _orderItems[i] = OrderItemModel(
            isPrinted: item.isPrinted,
            item: item.item,
            slectedComponents: itemToAdd.slectedComponents,
            addons: itemToAdd.addons,
            quantity: isNew ? item.quantity + 1 : item.quantity,
            note: item.note,
            completed: item.completed,
            totalPrice: orderItemTotal(context, i),
          );
          return;
        }
      }
    }

    if (isNew) {
      _orderItems.add(itemToAdd);
    }
  }

  void addNote(String note, int index) {
    _orderItems[index].note = note;

    notifyListeners();
  }

  void deleteEntireProduct(int index) {
    if (index != -1) {
      _orderItems.removeAt(index);
    }
    notifyListeners();
  }

  void addOrderItem(
      BuildContext context,
      OrderItemModel itemtoadd,
      List<AddOnsModel> oldAddOns,
      List<SelectedComponent> oldComponents,
      bool isNew) {
    final index = _orderItems
        .indexWhere((element) => element.item.id == itemtoadd.item.id);

    if (index == -1) {
      _orderItems.add(itemtoadd);
    } else {
      findOrderItem(context, itemtoadd, oldAddOns, oldComponents, isNew);
    }

    print(_orderItems);
    notifyListeners();
  }

  void clearOrderItems() {
    _orderItems.clear();
  }

  num orderItemTotal(BuildContext context, int index) {
    num total = _orderItems[index].quantity * _orderItems[index].item.salePrice;
    for (final item in _orderItems[index].addons) {
      total += _orderItems[index].quantity * item.quantity * item.salePrice;
    }
    for (final item in _orderItems[index].slectedComponents) {
      total += _orderItems[index].quantity * item.item.salePrice;
    }

    // total += itemTaxCalculation(context, index);

    _orderItems[index].totalPrice = total;

    return total;
  }

   num calculateTax(num itemAmount, num taxPercentage) {
  // Calculate tax amount
  double taxAmount = (itemAmount * taxPercentage) / 100;
  
  return taxAmount;
}

  num itemTaxCalculation(BuildContext context, int index) {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    num total = _orderItems[index].item.taxAmount == 1 ?  (_orderItems[index].quantity * _orderItems[index].item.salePrice) : 0;

    var taxAmount = calculateTax(total, adminProvider.taxAmount);

    return taxAmount;
  }

  num totalTaxAmount(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    num total = 0.0;

    for (final item1 in _orderItems) {

      var itemTax = item1.item.taxAmount == 1 ? (item1.quantity * item1.item.salePrice) : 0;

       var taxAmount = calculateTax(itemTax, adminProvider.taxAmount);

        total+= taxAmount;
      
    }

    return total;
  }

  num totalAmount(BuildContext context) {
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    num total = 0.0;

    for (final item1 in _orderItems) {
      total += item1.quantity * item1.item.salePrice;

      var itemTax = item1.item.taxAmount == 1 ? (item1.quantity * item1.item.salePrice) : 0;

       var taxAmount = calculateTax(itemTax, adminProvider.taxAmount);

        total+= taxAmount;
      for (final item2 in item1.addons) {
        total += item1.quantity * item2.quantity * item2.salePrice;
      }
    }

    return total;
  }

  int totalOrderItems() {
    return orderItems.length;
  }

  int totalSaleitems() {
    int totalproducts = 0;
    for (final item in _orderItems) {
      totalproducts += item.quantity;
    }

    return totalproducts;
  }

  void updateQuantity(int index, bool add) {
    add ? _orderItems[index].quantity++ : _orderItems[index].quantity--;
    _orderItems[index].quantity == 0 ? _orderItems.removeAt(index) : null;
    notifyListeners();
  }

  void clearList() {
    _orderItems.clear();
    notifyListeners();
  }

  void updateOrderItem(int index, OrderItemModel updatedItem) {
    if (index >= 0 && index < _orderItems.length) {
      _orderItems[index] = updatedItem;
      notifyListeners();
    }
  }
}
