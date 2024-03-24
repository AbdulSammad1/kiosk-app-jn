import 'package:kiosk_app/Models/categorieItem.dart';
import 'package:kiosk_app/Models/inventory_stock_model.dart';
import 'package:kiosk_app/Models/kiosk_data_model.dart';
import 'package:kiosk_app/Models/sale_item_component_model.dart';

import 'add_ons_model.dart';

class saleItem {
  final String id;
  final String title;
  final String barCode;
  final String alias;
  final num stockPrice;
  num salePrice;
  final num taxAmount;
  String imageUrl;
  String itemColor;
  List<InventoryStockModel> ingredients;
  List<SaleItemComponent> components;
  List<AddOnsModel> addOns;
  categoryItem category;
  KioskDataModel kioskData;
  saleItem(
      {required this.id,
      required this.title,
      required this.barCode,
      required this.alias,
      required this.stockPrice,
      required this.salePrice,
      required this.taxAmount,
      required this.imageUrl,
      required this.itemColor,
      required this.ingredients,
      required this.components,
      required this.addOns,
      required this.category,
      required this.kioskData});
}
