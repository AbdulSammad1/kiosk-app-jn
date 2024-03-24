class InventoryComponent {
  final String id;
  final String barcode;
  final String name;
  String measuringUnit;
  final String descritpion;
  num numberOfUnits;
  num stockPrice;
  num salePrice;
  String imageUrl;

  InventoryComponent({
    required this.id,
    required this.measuringUnit,
    required this.numberOfUnits,
    required this.stockPrice,
    required this.barcode,
    required this.descritpion,
    required this.name,
    this.imageUrl = '',
    required this.salePrice,
  });
}
