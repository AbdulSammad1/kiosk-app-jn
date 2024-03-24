import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiosk_app/Models/Order_Item_Model.dart';
import 'package:kiosk_app/Models/add_ons_model.dart';
import 'package:kiosk_app/Models/saleItemModel.dart';
import 'package:kiosk_app/Providers/Order_Item_Provider.dart';
import 'package:kiosk_app/Widgets/custom_button.dart';
import 'package:kiosk_app/Widgets/slider_widget_in_dialog.dart';
import 'package:kiosk_app/constants.dart';
import 'package:provider/provider.dart';

import '../Models/sale_item_component_model.dart';
import '../Models/selected_component_model.dart';
import '../Providers/saleItemProvider.dart';

class ShowAddonsWidget extends StatefulWidget {
  final saleItem saleitem;
  final bool isNew;
  final List<AddOnsModel>? existingAddons;
  final List<SelectedComponent>? existingComponents;
  final int itemQuantity;
  final int index;
  const ShowAddonsWidget(
      {super.key,
      required this.saleitem,
      required this.isNew,
      this.existingAddons,
      this.existingComponents,
      required this.itemQuantity,
      required this.index});
  @override
  State<ShowAddonsWidget> createState() => _ShowAddonsWidgetState();
}

class _ShowAddonsWidgetState extends State<ShowAddonsWidget> {
  List<AddOnsModel> filteredAddOns = [];
  List<AddOnsModel> initialAddons = [];
  List<AddOnsModel> oldAddonsList = [];

  List<SelectedComponent> oldComponents = [];
  List<SelectedComponent> selectedComponents = [];

  List<SaleItemComponent> requiredItems = [];
  List<SaleItemComponent> optionalItems = [];

  ScrollController scrollController = ScrollController();
  int itemQuantity = 0;
  num totalPrice = 0;

  void setRequiredAndOptionalItems() {
    for (var i = 0; i < widget.saleitem.components.length; i++) {
      if (widget.saleitem.components[i].isRequired == true) {
        requiredItems.add(widget.saleitem.components[i]);
      } else {
        optionalItems.add(widget.saleitem.components[i]);
      }
    }
  }

  bool areAllRequiredItemsSelected(List<SaleItemComponent> requiredItems,
      List<SelectedComponent> selectedComponents) {
    for (var requiredItem in requiredItems) {
      bool itemFound = false;
      for (var selectedItem in selectedComponents) {
        if (selectedItem.componentName == requiredItem.componentName) {
          itemFound = true;
          break;
        }
      }
      if (!itemFound) {
        return false; // At least one required item is not selected
      }
    }
    return true; // All required items are selected
  }

  num calculateTotalAmount(List<SelectedComponent> selectedComponents,
      List<AddOnsModel> initialAddons) {
    num totalAmount = widget.saleitem.salePrice;

    // Calculate total amount of selected components
    for (var selectedComponent in selectedComponents) {
      totalAmount += selectedComponent.item.salePrice;
    }

    // Calculate total amount of addons with quantity > 0
    for (var addon in initialAddons) {
      if (addon.quantity > 0) {
        totalAmount += addon.quantity * addon.salePrice;
      }
    }

    return totalAmount;
  }

  void updateSelectedComponent(
      List<SelectedComponent> list, SelectedComponent newItem) {
    final saleComponentProvider =
        Provider.of<SaleItemProvider>(context, listen: false);

    int existingIndex = list.indexWhere((item) => item.id == newItem.id);

    if (existingIndex != -1) {
      if (saleComponentProvider.findComponentById(newItem.id).selectionType ==
          "Multi Selection") {
        // If selection type is Multi Selection, allow multiple selections
        bool alreadyExists = list.any((item) =>
            item.id == newItem.id &&
            item.componentName == newItem.componentName &&
            item.item == newItem.item);

        if (!alreadyExists) {
          list.add(newItem);
        } else {
          list.removeWhere((item) =>
              item.id == newItem.id &&
              item.componentName == newItem.componentName &&
              item.item == newItem.item);
        }
      } else {
        // If selection type is not Multi Selection, replace the previous selection
        list[existingIndex] = newItem;
      }
    } else {
      list.add(newItem);
    }

    setState(() {});
  }

  bool isItemPresentInList(
      List<SelectedComponent> list, SelectedComponent itemToCheck) {
    return list.any(
        (item) => item.id == itemToCheck.id && item.item == itemToCheck.item);
  }

  void setComponentsList(List<SelectedComponent> component) {
    if (widget.isNew == false) {
      oldComponents.addAll(component);

      selectedComponents.addAll(component);
    }
  }

  void filterAddons() {
    filteredAddOns
        .addAll(initialAddons.where((element) => element.quantity > 0));
  }

   num totalAmount(List<SelectedComponent> selectedComponents,
      List<AddOnsModel> initialAddons) {
    num totalAmount = widget.saleitem.salePrice;

    // Calculate total amount of selected components
    for (var selectedComponent in selectedComponents) {
      totalAmount += selectedComponent.item.salePrice;
    }

    // Calculate total amount of addons with quantity > 0
    for (var addon in initialAddons) {
      if (addon.quantity > 0) {
        totalAmount += addon.quantity * addon.salePrice;
      }
    }

    return totalAmount;
  }

  double dialogBoxHeight() {
    final size = MediaQuery.of(context).size;
    if (widget.saleitem.addOns.isEmpty && widget.saleitem.components.isEmpty) {
      return size.height * 0.35;
    }
    else if((widget.saleitem.addOns.isEmpty && widget.saleitem.components.isNotEmpty) || (widget.saleitem.addOns.isNotEmpty && widget.saleitem.components.isEmpty)) {
      return size.height * 0.6;
    }
    else{
       return size.height * 0.8;
    }
  }

  @override
  void initState() {
    super.initState();

    setRequiredAndOptionalItems();
    widget.existingComponents != null
        ? setComponentsList(widget.existingComponents!)
        : print('hello');

    itemQuantity = widget.itemQuantity;
    for (var element in widget.saleitem.addOns) {
      int index = widget.isNew
          ? 0
          : widget.existingAddons!
              .indexWhere((addon) => addon.id == element.id);
      initialAddons.add(AddOnsModel(
        id: element.id,
        barCode: element.barCode,
        title: element.title,
        quantity: widget.isNew
            ? 0
            : index == -1
                ? 0
                : widget.existingAddons![index].quantity,
        stockPrice: element.stockPrice,
        salePrice: element.salePrice,
        unit: element.unit,
        image: element.image,
      ));
      widget.isNew
          ? 0
          : index == -1
              ? 0
              : oldAddonsList.add(AddOnsModel(
                  id: element.id,
                  barCode: element.barCode,
                  title: element.title,
                  quantity: widget.existingAddons![index].quantity,
                  stockPrice: element.stockPrice,
                  salePrice: element.salePrice,
                  unit: element.unit,
                  image: element.image,
                ));
      calculateTotal();
    }
  }

  void calculateTotal() {
    totalPrice = (widget.saleitem.kioskData.discountPercentage > 0 &&
            widget.saleitem.kioskData.discounted == true)
        ? widget.saleitem.kioskData.discountedPrice * itemQuantity
        : widget.saleitem.salePrice * itemQuantity;
    for (final addon in initialAddons) {
      totalPrice += addon.salePrice * addon.quantity * itemQuantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(
        'Product Details',
        textAlign: TextAlign.start,
        style:
            TextStyle(fontSize: size.width * 0.04, fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: size.width * 0.75,
        height: dialogBoxHeight(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: size.height * 0.2,
                  width: size.width * 0.75,
                  child: SliderWidgetInDialog(
                      imageUrls: widget.saleitem.kioskData.imageUrls),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Center(
                  child: Text(
                    widget.saleitem.title,
                    style: TextStyle(
                        fontSize: size.width * 0.035,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.00025,
                ),
                Center(
                  child: Text(
                    '\$${widget.saleitem.kioskData.discounted == true && widget.saleitem.kioskData.discountPercentage > 0 ? widget.saleitem.kioskData.discountedPrice : widget.saleitem.salePrice}',
                    style: TextStyle(
                        fontSize: size.width * 0.025,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Container(
                  padding: EdgeInsets.only(left: size.width * 0.02),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Description',
                    style: TextStyle(
                        fontSize: size.width * 0.03,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                   padding: EdgeInsets.only(left: size.width * 0.01),
                  decoration: const BoxDecoration(color: Colors.white),
                  constraints: BoxConstraints(
                    maxHeight: size.height * 0.085,
                  ),
                  width: size.width * 0.7,
                  child: Text(
                    widget.saleitem.kioskData.description,
                    style: TextStyle(fontSize: size.width * 0.02),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                (widget.saleitem.components.isEmpty)
                    ? const SizedBox.shrink()
                    : Container(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.all(size.width * 0.01),
                          decoration: BoxDecoration(
                              color: Constants().primaryColor,
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.014)),
                          child: Text(
                            'Standard Options',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: size.width * 0.025,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                SizedBox(height: size.height * 0.01),
                widget.saleitem.components.isEmpty
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          SizedBox(height: size.height * 0.01),
                          Container(
                            margin: EdgeInsets.only(left: size.width * 0.025),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              controller: scrollController,
                              itemCount: widget.saleitem.components.length,
                              itemBuilder: (context, index) {
                                var item = widget.saleitem.components[index];
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        item.componentName,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: size.width * 0.023,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: MediaQuery.of(context)
                                                .size
                                                .width /
                                            (MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10), // Adjust this value as needed
                                        // crossAxisSpacing: size.width *
                                        //     0.01, // Adjust spacing as needed
                                        // mainAxisSpacing: size.width * 0.01,
                                      ), // Adjust this value as needed
                                      shrinkWrap: true,

                                      itemCount: item.items.length,
                                      itemBuilder: (context, index) {
                                        var items = item.items[index];
                                        return Row(
                                          children: [
                                            Transform.scale(
                                              scale:
                                                  1.5, // Adjust the value for desired size increase
                                              child: Checkbox(
                                                activeColor:Constants().primaryColor,
                                                visualDensity: VisualDensity
                                                    .adaptivePlatformDensity,
                                                onChanged: (val) {
                                                  updateSelectedComponent(
                                                    selectedComponents,
                                                    SelectedComponent(
                                                      id: item.id,
                                                      componentName:
                                                          item.componentName,
                                                      item: items,
                                                    ),
                                                  );
                                                },
                                                value: isItemPresentInList(
                                                  selectedComponents,
                                                  SelectedComponent(
                                                    id: item.id,
                                                    componentName:
                                                        item.componentName,
                                                    item: items,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width * 0.002,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  items.title,
                                                  // overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.width * 0.023),
                                                ),
                                                Text(
                                                  '\$ ${items.salePrice.toStringAsFixed(2)}',
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                widget.saleitem.addOns.isNotEmpty
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Container(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.all(size.width * 0.01),
                          decoration: BoxDecoration(
                              color: Constants().primaryColor,
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.014)),
                          child: Text(
                            'Addons',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: size.width * 0.025,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                            SizedBox(
                              height: size.height * 0.004,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.03),
                              child: GridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: MediaQuery.of(context)
                                          .size
                                          .width /
                                      (MediaQuery.of(context).size.height / 8),
                                  crossAxisSpacing: size.width * 0.04,
                                  mainAxisSpacing: size.width * 0.01,
                                ),
                                shrinkWrap: true,
                                controller: scrollController,
                                itemCount: initialAddons.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(
                                      initialAddons[index].title,
                                      style: TextStyle(
                                          fontSize: size.width * 0.02),
                                    ),
                                    subtitle: Text(
                                      '\$ ${initialAddons[index].salePrice.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          fontSize: size.width * 0.02),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              initialAddons[index].quantity > 0
                                                  ? initialAddons[index]
                                                      .quantity -= 1
                                                  : null;
                                            });
                                          },
                                          child: Icon(
                                            CupertinoIcons.minus,
                                            size: size.width * 0.04,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.01,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.01,
                                            vertical: size.width * 0.01,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: 1,
                                              color: Constants().primaryColor,
                                            ),
                                          ),
                                          child: Text(
                                            '${initialAddons[index].quantity.toInt()}',
                                            style: TextStyle(
                                                fontSize: size.width * 0.025),
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.01,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              initialAddons[index].quantity +=
                                                  1;
                                            });
                                          },
                                          child: Icon(
                                            CupertinoIcons.add,
                                            size: size.width * 0.04,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ])
                    : const SizedBox.shrink(),
                // SizedBox(
                //   width: size.width * 0.7,
                //   height: size.height * 0.05,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       InkWell(
                //         onTap: () {
                //           setState(() {
                //             itemQuantity > 1 ? itemQuantity -= 1 : null;
                //             calculateTotal();
                //           });
                //         },
                //         child: Container(
                //           decoration: const BoxDecoration(
                //               color: Colors.redAccent, shape: BoxShape.circle),
                //           padding: EdgeInsets.all(size.width * 0.013),
                //           child: Icon(
                //             CupertinoIcons.minus,
                //             size: size.width * 0.04,
                //             color: Colors.white,
                //           ),
                //         ),
                //       ),
                //       SizedBox(
                //         width: size.width * 0.015,
                //       ),
                //       Container(
                //         padding: EdgeInsets.symmetric(
                //             horizontal: size.width * 0.02,
                //             vertical: size.height * 0.01),
                //         decoration: BoxDecoration(
                //             border: Border.all(
                //                 width: 1, color: Constants().primaryColor)),
                //         child: Text(
                //           '${itemQuantity.toInt()}',
                //           style: TextStyle(fontSize: size.width * 0.025),
                //         ),
                //       ),
                //       SizedBox(
                //         width: size.width * 0.015,
                //       ),
                //       InkWell(
                //         onTap: () {
                //           setState(() {
                //             itemQuantity += 1;
                //             calculateTotal();
                //           });
                //         },
                //         child: Container(
                //           padding: EdgeInsets.all(size.width * 0.013),
                //           decoration: const BoxDecoration(
                //               color: Colors.blueAccent, shape: BoxShape.circle),
                //           child: Icon(
                //             CupertinoIcons.add,
                //             size: size.width * 0.04,
                //             color: Colors.white,
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 0.03,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      itemQuantity > 1 ? itemQuantity -= 1 : null;
                      calculateTotal();
                    });
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.redAccent, shape: BoxShape.circle),
                    padding: EdgeInsets.all(size.width * 0.013),
                    child: Icon(
                      CupertinoIcons.minus,
                      size: size.width * 0.04,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.015,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.02,
                      vertical: size.height * 0.01),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, color: Constants().primaryColor)),
                  child: Text(
                    '${itemQuantity.toInt()}',
                    style: TextStyle(fontSize: size.width * 0.025),
                  ),
                ),
                SizedBox(
                  width: size.width * 0.015,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      itemQuantity += 1;
                      calculateTotal();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(size.width * 0.013),
                    decoration: const BoxDecoration(
                        color: Colors.blueAccent, shape: BoxShape.circle),
                    child: Icon(
                      CupertinoIcons.add,
                      size: size.width * 0.04,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            CustomButton(
                onPressed: () {
                  filterAddons();
                  widget.isNew
                      ? Provider.of<OrderItemsProvider>(context, listen: false)
                          .addOrderItem(
                              context,
                              OrderItemModel(
                                  isPrinted: false,
                                  totalPrice: 0.0,
                                  completed: false,
                                  quantity: itemQuantity,
                                  item: widget.saleitem,
                                  slectedComponents: selectedComponents,
                                  addons: filteredAddOns,
                                  note: ''),
                              filteredAddOns,
                              selectedComponents,
                              widget.isNew)
                      : Provider.of<OrderItemsProvider>(context, listen: false)
                          .updateOrderItem(
                              widget.index,
                              OrderItemModel(
                                  isPrinted: false,
                                  totalPrice: 0.0,
                                  completed: false,
                                  quantity: itemQuantity,
                                  item: widget.saleitem,
                                  addons: filteredAddOns,
                                  slectedComponents: selectedComponents,
                                  note: ''));

                  Navigator.of(context).pop();
                },
                borderOn: false,
                borderColor: Colors.white,
                borderRadius: size.width * 0.03,
                borderWidth: 0,
                color: Constants().primaryColor,
                height: size.height * 0.04,
                width: size.width * 0.3,
                child: Text(
                  'Confirm : \$${totalAmount(selectedComponents, initialAddons).toStringAsFixed(2)}',
                  style: TextStyle(
                      color: Colors.white, fontSize: size.width * 0.025),
                )),
          ],
        ),
      ],
    );
  }
}
