class KioskDataModel {
  bool isKioskItem;
  num discountPercentage;
  num discountedPrice;
  bool discounted;
  bool featured;
  String description;
  List<String> imageUrls;
  KioskDataModel(
      {required this.isKioskItem,
      required this.discountPercentage,
      required this.discountedPrice,
      required this.discounted,
      required this.featured,
      required this.description,
      required this.imageUrls});
}
