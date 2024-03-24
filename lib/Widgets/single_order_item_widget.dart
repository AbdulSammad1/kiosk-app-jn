import 'package:flutter/material.dart';
import 'package:kiosk_app/Models/Order_Item_Model.dart';
import 'package:kiosk_app/Providers/Order_Item_Provider.dart';
import 'package:kiosk_app/Widgets/Show_Addons.dart';
import 'package:kiosk_app/Widgets/custom_button.dart';
import 'package:kiosk_app/constants.dart';
import 'package:provider/provider.dart';

class SingleOrderItemWidget extends StatefulWidget {
  const SingleOrderItemWidget(
      {super.key, required this.orderItem, required this.index});
  final OrderItemModel orderItem;
  final int index;
  @override
  State<SingleOrderItemWidget> createState() => _SingleOrderItemWidgetState();
}

class _SingleOrderItemWidgetState extends State<SingleOrderItemWidget> {
  bool expanded = false;
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final orderItemProvider = Provider.of<OrderItemsProvider>(context);

    return Container(
        padding: EdgeInsets.only(bottom: size.height * 0.003),
        height: size.height * 0.17,
        margin: EdgeInsets.symmetric(vertical: size.height * 0.005),
        decoration: const BoxDecoration(
            // borderRadius: BorderRadius.circular(size.height * 0.02),
            border: Border(bottom: BorderSide(width: 1, color: Colors.black38))
            // color: Colors.white,
            ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.125,
                width: size.width * 0.2,
                child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder:
                        const AssetImage('assets/food_placeholder_image.jpg'),
                    image: NetworkImage(
                        widget.orderItem.item.kioskData.imageUrls[0])),
              ),
              SizedBox(
                width: size.width * 0.015,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.orderItem.item.title,
                    style: TextStyle(
                        fontSize: size.height * 0.02,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: size.width * 0.35,
                    height: size.height * 0.1,
                    child: Scrollbar(
                      controller: scrollController,
                          thumbVisibility: true,
                          thickness: size.width * 0.01,
                      child: ListView(
                        controller: scrollController,
                        children: [
                          widget.orderItem.slectedComponents.isEmpty
                              ? const SizedBox.shrink()
                              : Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: size.width * 0.02),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Components',
                                        style: TextStyle(
                                            fontSize: size.width * 0.025,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: size.width * 0.03),
                                      child: ListView.builder(

                                        // controller: scrollController,
                                        shrinkWrap: true,
                                        itemCount: widget
                                            .orderItem.slectedComponents.length,
                                        itemBuilder: (context, index) => Text(
                                          '${widget.orderItem.slectedComponents[index].item.quantity.toStringAsFixed(0)} x ${widget.orderItem.slectedComponents[index].item.title}',
                                          style: TextStyle(
                                              fontSize: size.height * 0.012,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          widget.orderItem.addons.isEmpty
                              ? const SizedBox.shrink()
                              : Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: size.width * 0.02),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Addons',
                                        style: TextStyle(
                                            fontSize: size.width * 0.025,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(
                                          left: size.width * 0.03),
                                      child: ListView.builder(
                                        // controller: scrollController,
                                        shrinkWrap: true,
                                        itemCount:
                                            widget.orderItem.addons.length,
                                        itemBuilder: (context, index) => Text(
                                          '${widget.orderItem.addons[index].quantity.toStringAsFixed(0)} x ${widget.orderItem.addons[index].title}',
                                          style: TextStyle(
                                              fontSize: size.height * 0.012,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const Expanded(child: SizedBox()),
              Text(
                '\$${orderItemProvider.orderItemTotal(context, widget.index).toStringAsFixed(2)}',
                style: TextStyle(
                    fontSize: size.height * 0.02, fontWeight: FontWeight.bold),
              )
            ],
          ),
          // const Expanded(
          //   child: SizedBox(),
          // ),
          SizedBox(
              child: Row(children: [
            SizedBox(
              width: size.width * 0.2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      orderItemProvider.updateQuantity(widget.index, false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.width * 0.25),
                          color: Constants().primaryColor),
                      height: size.height * 0.03,
                      width: size.height * 0.03,
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Consumer<OrderItemsProvider>(
                    builder: (context, value, child) => Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(size.width * 0.0025),
                            color: Colors.white),
                        height: size.height * 0.04,
                        width: size.height * 0.04,
                        child: Center(
                          child: Text(
                            widget.orderItem.quantity.toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: size.height * 0.025,
                            ),
                          ),
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      orderItemProvider.updateQuantity(widget.index, true);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.width * 0.25),
                          color: Constants().primaryColor),
                      height: size.height * 0.03,
                      width: size.height * 0.03,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            CustomButton(
                height: size.height * 0.03,
                width: size.width * 0.175,
                color: Colors.white,
                borderOn: true,
                borderColor: Constants().primaryColor,
                borderWidth: 2,
                borderRadius: size.height * 0.005,
                child: Text(
                  'EDIT',
                  style: TextStyle(
                      fontSize: size.height * 0.0125, color: Colors.black),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ShowAddonsWidget(
                        saleitem: widget.orderItem.item,
                        isNew: false,
                        itemQuantity: widget.orderItem.quantity,
                        existingAddons: widget.orderItem.addons,
                        existingComponents: widget.orderItem.slectedComponents,
                        index: widget.index),
                  );
                }),
            SizedBox(
              width: size.width * 0.015,
            ),
            CustomButton(
                height: size.height * 0.03,
                width: size.width * 0.175,
                color: Colors.white,
                borderOn: true,
                borderColor: Constants().primaryColor,
                borderWidth: 2,
                borderRadius: size.height * 0.005,
                child: Text(
                  'REMOVE',
                  style: TextStyle(
                      fontSize: size.height * 0.0125, color: Colors.black),
                ),
                onPressed: () {
                  orderItemProvider.deleteEntireProduct(widget.index);
                })
          ]))
        ]));
  }
}
