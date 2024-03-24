import 'package:kiosk_app/Models/inventory_stock_model.dart';

class SelectedComponent {
  final String id;
  final String componentName;
  final InventoryStockModel item;

  SelectedComponent({required this.id,required this.componentName, required this.item});
}