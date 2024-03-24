
import 'package:kiosk_app/Models/inventory_stock_model.dart';

class SaleItemComponent {
  final String id;
  final String componentName;
   bool isRequired;
  final List<InventoryStockModel> items;
  final String selectionType;

  SaleItemComponent({required this.id,required this.componentName, required this.isRequired, required this.items, required this.selectionType});
}