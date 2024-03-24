import 'package:flutter/material.dart';
import 'package:kiosk_app/Models/saleItemModel.dart';
import 'package:kiosk_app/Widgets/single_kiosk_widget.dart';

class SaleItemsGridWidget extends StatefulWidget {
  final List<saleItem> saleItems;
  final String categoryId;

  const SaleItemsGridWidget(
      {super.key, required this.saleItems, required this.categoryId});

  @override
  State<SaleItemsGridWidget> createState() => _SaleItemsGridWidgetState();
}

class _SaleItemsGridWidgetState extends State<SaleItemsGridWidget> {
  late List<saleItem> displayedSaleItems;

  @override
  void initState() {
    super.initState();
  }

  double _calculateChildAspectRatio(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust these values as needed for your kiosk screen dimensions
    if (screenWidth >= 960) {
      return 0.75; // Larger screens can accommodate more items per row
    } else if (screenWidth >= 850) {
      return 0.95;
    } 
    // else if (screenWidth >= 800) {
    //   return 0.75;
    // } 
    else {
      return 0.843;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the selected category is 'All'
    if (widget.categoryId == 'All') {
      // Display all sale items without filtering
      displayedSaleItems = widget.saleItems;
    } else {
      // Filter sale items based on the provided category ID
      displayedSaleItems = widget.saleItems
          .where((saleItem) => saleItem.category.id == widget.categoryId)
          .toList();
    }
    return GridView.builder(
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 15.0,
          mainAxisSpacing: 0,
          childAspectRatio: _calculateChildAspectRatio(context)),
      itemCount: displayedSaleItems.length,
      itemBuilder: (context, index) {
        saleItem item = displayedSaleItems[index];
        return SingleKioskWidget(
          item: item,
          index: index,
          totalLength: displayedSaleItems.length,
        );
      },
    );
  }

}
