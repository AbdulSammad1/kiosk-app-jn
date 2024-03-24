import 'package:kiosk_app/Models/saleItemModel.dart';
import 'package:kiosk_app/Models/selected_component_model.dart';

import 'add_ons_model.dart';

class OrderItemModel {
  final saleItem item;
  final bool completed;
  final bool isPrinted;
  List<SelectedComponent> slectedComponents;
  List<AddOnsModel> addons;
  int quantity;
  String note;
  num totalPrice;
  OrderItemModel(
      {required this.item,
      required this.completed,
      required this.isPrinted,
      required this.slectedComponents,
      required this.addons,
      required this.quantity,
      required this.note,
      required this.totalPrice});
}
