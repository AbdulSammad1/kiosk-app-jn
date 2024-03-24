import 'package:flutter/material.dart';
import 'package:kiosk_app/Models/categorieItem.dart';
import 'package:kiosk_app/Models/saleItemModel.dart';
import 'package:kiosk_app/constants.dart';

class CategoriesListWidget extends StatefulWidget {
  final List<saleItem> saleItems;
  final Function(String id) onCategorySelected;

  const CategoriesListWidget(
      {super.key, required this.saleItems, required this.onCategorySelected});

  @override
  _CategoriesListWidgetState createState() => _CategoriesListWidgetState();
}

class _CategoriesListWidgetState extends State<CategoriesListWidget> {
  late List<categoryItem> categories;
  String selectedCategoryId = 'All';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Extract unique categories from saleItems
    
    categories = [
       categoryItem(
        title: 'All',
        id: 'All',
        imageUrl: 'assets/all_image.png', // Replace with your asset path
        itemColor: 'your_default_color', // Replace with your default color
      ),
      ...removeDuplicatesById(
          widget.saleItems.map((item) => item.category).toList()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ScrollbarTheme(
      data: ScrollbarThemeData(
          thumbColor:
              MaterialStateProperty.all<Color>(Constants().primaryColor)),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        interactive: true,
        radius: Radius.circular(size.height * 0.02),
        thickness: 10,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            categoryItem category = categories[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (selectedCategoryId == category.id) {
                    selectedCategoryId = 'All';
                  } else {
                    selectedCategoryId = category.id;
                  }
                });
                widget.onCategorySelected(selectedCategoryId);
              },
              child: Stack(
                children: [
                  Container(
                    width: size.width * 0.23,
                    height: size.height * 0.11,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(size.height * 0.02),
                          bottomRight: Radius.circular(size.height * 0.02)),
                    ),
                    margin: EdgeInsets.only(
                      right: size.width * 0.02,
                      top: category.id == 'All'
                          ? size.height * 0.0
                          : size.height * 0.01,
                    ),
                    // width: size.height * 0.11, // Set your desired width

                    child: SizedBox.expand(
                      child: category.id == 'All'
                          ? ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(size.height * 0.02),
                                  bottomRight:
                                      Radius.circular(size.height * 0.02)),
                              child: FadeInImage(
                                height: size.height * 0.06,
                                width: size.height * 0.06,
                                fit: BoxFit.cover,
                                placeholder: const AssetImage(
                                  'assets/food_placeholder_image.jpg',
                                ),
                                image:
                                    const AssetImage('assets/food_image1.webp'),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(size.height * 0.02),
                                  bottomRight:
                                      Radius.circular(size.height * 0.02)),
                              child: FadeInImage(
                                height: size.height * 0.06,
                                width: size.height * 0.06,
                                fit: BoxFit.cover,
                                placeholder: const AssetImage(
                                  'assets/food_placeholder_image.jpg',
                                ),
                                image: NetworkImage(
                                  category.imageUrl,
                                ),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      alignment: Alignment.center,
                      height: size.height * 0.03,
                      width: size.width * 0.23,
                      margin: EdgeInsets.only(
                        right: size.width * 0.02,
                        top: category.id == 'All'
                            ? size.height * 0.0
                            : size.height * 0.01,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            // topRight: Radius.circular(size.height * 0.02),
                            bottomRight: Radius.circular(size.height * 0.02)),
                        color: selectedCategoryId == category.id
                            ? Constants()
                                .primaryColor
                                .withOpacity(0.8) // Highlighted color
                            : const Color.fromRGBO(0, 0, 0,
                                0.4), // Adjust the alpha value for transparency
                      ),
                      child: Center(
                        child: Text(
                          category.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.023,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<categoryItem> removeDuplicatesById(List<categoryItem> items) {
    Set<String> uniqueIds = <String>{};
    List<categoryItem> uniqueItems = [];

    for (var item in items) {
      if (uniqueIds.add(item.id)) {
        uniqueItems.add(item);
      }
    }

    return uniqueItems;
  }
}
