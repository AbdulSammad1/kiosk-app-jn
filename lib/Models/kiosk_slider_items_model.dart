class KioskSliderItemsModel {
  String id;
  String imageUrl;
  int sliderImageOrder;
  String promotion;
  DateTime startDate;
  DateTime endDate;
  String alignment;
  KioskSliderItemsModel(
      {required this.id,
      required this.imageUrl,
      required this.sliderImageOrder,
      required this.promotion,
      required this.startDate,
      required this.endDate,
      required this.alignment});
}
