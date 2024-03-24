class AddOnsModel {
  String id;
  String barCode;
  String title;
  num quantity;
  num stockPrice;
  num salePrice;
  String unit;
  String image;

  AddOnsModel({
    required this.id,
    required this.barCode,
    required this.title,
    required this.quantity,
    required this.stockPrice,
    required this.salePrice,
    required this.unit,
    required this.image,
  });
}
