import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kiosk_app/Models/saleItemModel.dart';
import 'package:kiosk_app/Widgets/Show_Addons.dart';
import 'package:kiosk_app/constants.dart';

class SingleKioskWidget extends StatefulWidget {
  const SingleKioskWidget(
      {super.key,
      required this.item,
      this.totalLength = -1,
      required this.index});
  final saleItem item;
  final int totalLength;
  final int index;
  @override
  State<SingleKioskWidget> createState() => _SingleKioskWidgetState();
}

class _SingleKioskWidgetState extends State<SingleKioskWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // SizedBox(),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return ShowAddonsWidget(
                  saleitem: widget.item,
                  isNew: true,
                  itemQuantity: 1,
                  index: 0,
                );
              },
            );
          },
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.005,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: size.height * 0.01),
                    width: widget.totalLength == -1
                        ? size.width * 0.211
                        : size.width * 0.221,
                    height: size.height * 0.16,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(size.height * 0.02),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 2,
                              color: Colors.grey.withOpacity(0.5),
                              offset: const Offset(2, 2),
                              spreadRadius: 1)
                        ]),
                    child: Column(children: [
                      SizedBox(
                        height: size.height * 0.1,
                        width: size.height * 0.1,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(size.height * 0.5),
                          child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: const AssetImage(
                                  'assets/food_placeholder_image.jpg'),
                              image: NetworkImage(
                                  widget.item.kioskData.imageUrls[0])),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.005,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: size.width * 0.2,
                        child: Text(
                          widget.item.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: size.width * 0.022,
                              color: Constants().primaryColor),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.001,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '\$ ${widget.item.salePrice.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: size.height * 0.013,
                                decoration: widget.item.kioskData.discounted
                                    ? widget.item.kioskData.discountPercentage >
                                            0
                                        ? TextDecoration.lineThrough
                                        : null
                                    : null),
                          ),
                          widget.item.kioskData.discounted
                              ? widget.item.kioskData.discountPercentage > 0
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          left: size.width * 0.02),
                                      child: Text(
                                        widget.item.kioskData.discountedPrice
                                            .toStringAsFixed(1),
                                        style: TextStyle(
                                            fontSize: size.height * 0.015),
                                      ),
                                    )
                                  : const SizedBox(
                                      height: 0,
                                      width: 0,
                                    )
                              : const SizedBox(
                                  height: 0,
                                  width: 0,
                                )
                        ],
                      ),
                    ]),
                  ),
                ],
              ),
              (widget.item.kioskData.discounted &&
                      widget.item.kioskData.discountPercentage > 0)
                  ? Positioned(
                      top: size.height * 0.003,
                      left: size.width * 0.01,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              SvgPicture.asset('assets/sale_tag_image.svg',
                                  height: size.height * 0.05,
                                  width: size.height * 0.04,
                                  color: Constants().primaryColor),
                            ],
                          ),
                          Positioned(
                            top: size.height * 0.002,
                            left: size.width * 0.025,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: size.height * 0.0045,
                                ),
                                Text(
                                  'Upto',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: size.height * 0.01),
                                ),
                                Text(
                                    '${widget.item.kioskData.discountPercentage.toStringAsFixed(0)}%',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height * 0.01)),
                                Text('Off',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height * 0.01))
                              ],
                            ),
                          )
                        ],
                      ))
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
