
import 'package:flutter/material.dart';
import 'package:kiosk_app/Providers/Order_Item_Provider.dart';
import 'package:kiosk_app/Screens/home_screen.dart';
import 'package:kiosk_app/Widgets/custom_button.dart';
import 'package:kiosk_app/Widgets/enter_name_email_dialog.dart';
import 'package:kiosk_app/Widgets/single_order_item_widget.dart';
import 'package:kiosk_app/constants.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {

  static const routeName = '/cart-screen';

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Consumer<OrderItemsProvider>(
          builder: (context, value, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: size.height * 0.15,
                        width: size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.1),
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/food_placeholder_image.jpg'),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          color: Colors.black38,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.03,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              HomeScreen.routeName);
                                    },
                                    child: Container(
                                      height: size.height * 0.04,
                                      width: size.height * 0.04,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            size.height * 0.005),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.home_rounded,
                                          size: size.height * 0.025,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'CART',
                                style: TextStyle(
                                    fontSize: size.height * 0.035,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Row(
                                children: [
                                  const SizedBox(),
                                  SizedBox(
                                    width: size.width * 0.04,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1,
                    ),
                    child: Text(
                      'Review My Order',
                      style: TextStyle(
                          fontSize: size.height * 0.025,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.001,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.1,
                      ),
                      child: ListView.builder(
                        itemCount: value.orderItems.length,
                        itemBuilder: (context, index) => SingleOrderItemWidget(
                            orderItem: value.orderItems[index], index: index),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1,
                    ),
                    child: Container(
                        color: Colors.grey.shade300,
                        height: size.height * 0.12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: size.height * 0.02),
                              width: size.width * 0.75,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Order Subtotal',
                                        style: TextStyle(
                                            fontSize: size.height * 0.015,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        '\$${(value.totalAmount(context) - value.totalTaxAmount(context)).toStringAsFixed(2)}',
                                        style: TextStyle(
                                            fontSize: size.height * 0.015,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.01,),
                                  // Padding(
                                  //   padding: EdgeInsets.symmetric(
                                  //       vertical: size.height * 0.01),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       Text(
                                  //         'Discount',
                                  //         style: TextStyle(
                                  //             fontSize: size.height * 0.015,
                                  //             fontWeight: FontWeight.w600),
                                  //       ),
                                  //       Text(
                                  //         '\$${value.totalAmount().toStringAsFixed(1)}',
                                  //         style: TextStyle(
                                  //             fontSize: size.height * 0.015,
                                  //             fontWeight: FontWeight.w600),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Tax',
                                        style: TextStyle(
                                            fontSize: size.height * 0.015,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        '\$${value.totalTaxAmount(context).toStringAsFixed(2)}',
                                        style: TextStyle(
                                            fontSize: size.height * 0.015,
                                            fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                   SizedBox(height: size.height * 0.01,),
                                  const Divider(
                                    color: Colors.black,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total',
                                        style: TextStyle(
                                            fontSize: size.height * 0.02,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "\$${value.totalAmount(context).toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontSize: size.height * 0.02,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          left: size.width * 0.1,
                          right: size.width * 0.1,
                          top: size.height * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(
                              height: size.height * 0.035,
                              width: size.width * 0.34,
                              color: Constants().primaryColor,
                              borderOn: true,
                              borderColor: Constants().primaryColor,
                              borderWidth: 2,
                              borderRadius: size.height * 0.005,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                   Icon(Icons.shopping_bag_outlined, size: size.height * 0.022,),
                                  Text(
                                    'Continue Shopping',
                                    style: TextStyle(
                                        fontSize: size.height * 0.0165,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                 Navigator.of(context)
                                          .pushReplacementNamed(
                                              HomeScreen.routeName);
                              }),
                          CustomButton(
                              height: size.height * 0.035,
                              width: size.width * 0.225,
                              color: Constants().primaryColor,
                              borderOn: true,
                              borderColor: Constants().primaryColor,
                              borderWidth: 2,
                              borderRadius: size.height * 0.005,
                              child: Text(
                                'Proceed',
                                style: TextStyle(
                                    fontSize: size.height * 0.0165,
                                    color: Colors.white),
                              ),
                              onPressed: () async {
                                try {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const EnterNameEmailDialog());
                                } on Exception catch (e) {
                                  // TODO
                                  print(e);
                                } finally {
                                  // setState(() {
                                  //   orderItemProvider.clearList();
                                  // });
                                }
                              })
                        ],
                      )),
                  SizedBox(
                    height: size.height * 0.02,
                  )
                ],
              )),
    );
  }
}
