import 'package:flutter/material.dart';
import 'package:kiosk_app/Models/Order_Item_Model.dart';

class SingleAddonWidget extends StatefulWidget {
  const SingleAddonWidget(
      {super.key, required this.orderitem, required this.index});
  final OrderItemModel orderitem;
  final int index;
  @override
  State<SingleAddonWidget> createState() => _SingleAddonWidgetState();
}

class _SingleAddonWidgetState extends State<SingleAddonWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: size.height * 0.01),
      height: size.height * 0.055,
      child: Row(
        children: [
          SizedBox(
            width: size.width * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.orderitem.addons[widget.index].title,
                  style: TextStyle(
                      fontSize: size.height * 0.015,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  widget.orderitem.addons[widget.index].salePrice
                      .toStringAsFixed(1),
                  style: TextStyle(
                      fontSize: size.height * 0.015,
                      fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$${(widget.orderitem.addons[widget.index].salePrice * widget.orderitem.quantity).toStringAsFixed(1)}',
                style: TextStyle(
                    fontSize: size.height * 0.015, fontWeight: FontWeight.w500),
              ),
              Text(
                widget.orderitem.addons[widget.index].quantity
                    .toStringAsFixed(1),
                style: TextStyle(
                    fontSize: size.height * 0.015, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ],
      ),
    );
  }
}
