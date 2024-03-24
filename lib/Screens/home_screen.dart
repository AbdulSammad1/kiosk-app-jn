import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kiosk_app/Models/kiosk_slider_items_model.dart';
import 'package:kiosk_app/Models/saleItemModel.dart';
import 'package:kiosk_app/Providers/Order_Item_Provider.dart';
import 'package:kiosk_app/Providers/admin_provider.dart';
import 'package:kiosk_app/Providers/kiosk_slider_items_provider.dart';
import 'package:kiosk_app/Providers/saleItemProvider.dart';
import 'package:kiosk_app/Screens/cart_screen.dart';
import 'package:kiosk_app/Screens/contact_admin.dart';
import 'package:kiosk_app/Widgets/avaiable_readers_dialog.dart';
import 'package:kiosk_app/Widgets/available_printers.dart';
import 'package:kiosk_app/Widgets/categories_list_widget.dart';
import 'package:kiosk_app/Widgets/sale_items_grid_widget.dart';
import 'package:kiosk_app/Widgets/slider_widget.dart';
import 'package:kiosk_app/constants.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home-screen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<saleItem> completeList = [];
  List<saleItem> filteredList = [];
  List<KioskSliderItemsModel> sliderList = [];
  String selectedCategoryId = 'All';
  int timer = 0;
  bool isLoading = true;

  void fetchData() async {
    try {
      final saleItemProvider =
          Provider.of<SaleItemProvider>(context, listen: false);
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      final kioskSliderProvider =
          Provider.of<KioskSliderItemsProvider>(context, listen: false);

      sliderList = kioskSliderProvider.sliderItems;
      timer = adminProvider.kioskSliderItemsTimer;
      completeList = saleItemProvider.saleItems
          .where((element) => element.kioskData.isKioskItem)
          .toList();
      await adminProvider.getTaxPercentage();
      filteredList = saleItemProvider.saleItems
          .where((element) => element.kioskData.isKioskItem)
          .toList();
    } catch (e) {
      Constants().showDialogBox(context, 'Data Load Failed', '$e');
      // TODO
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkValid();
    fetchData();
  }

   void checkValid() async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    try {
    String isValid = await adminProvider.checkValid();

    if(isValid == 'true')
    {
      print('status is true');
    }
    else {
      Navigator.of(context).pushNamedAndRemoveUntil(ContactAdmin.routeName, (route) => false);
    }
      
    } catch (e) {
      Constants().showDialogBox(context, 'Data Load Failed', 'Failed to check validity');
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: isLoading
              ? SizedBox(
                  height: size.height * 0.8,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      margin: const EdgeInsets.all(0),
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Row(
                          children: [
                            InkWell(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => deciderDialog(),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(size.width * 0.01),
                                  decoration: const BoxDecoration(
                                      color: Colors.transparent),
                                  alignment: Alignment.center,
                                  height: size.height * 0.14,
                                  width: size.width * 0.2,
                                  child: Image.asset('assets/logo.png'),)
                            ),
                            SizedBox(
                              // decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft:Radius.circular(size.height * 0.04))),
                              height: size.height * 0.14,
                              width: size.width * 0.8,
                              child: ImageCarouselSlider(
                                sliderItems: sliderList,
                                timer: timer,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.009,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topRight:
                                      Radius.circular(size.width * 0.03))),
                          elevation: 7,
                          color: Colors.white,
                          margin: const EdgeInsets.all(0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight:
                                        Radius.circular(size.width * 0.03))),
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.015),
                            height: size.height * 0.775,
                            width: size.width * 0.25,
                            child: CategoriesListWidget(
                                saleItems: completeList,
                                onCategorySelected: (id) {
                                  setState(() {
                                    selectedCategoryId = id;
                                  });
                                }),
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(size.width * 0.03))),
                          margin: const EdgeInsets.all(0),
                          elevation: 7,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft:
                                        Radius.circular(size.width * 0.03))),
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.02,
                                vertical: size.height * 0.0048),
                            height: size.height * 0.775,
                            width: size.width * 0.75,
                            child: SaleItemsGridWidget(
                                saleItems: completeList,
                                categoryId: selectedCategoryId),
                          ),
                        )
                      ],
                    ),
                    Consumer<OrderItemsProvider>(
                      builder: (context, value, child) => Card(
                        elevation: 50,
                        margin: EdgeInsets.zero,
                        child: Container(
                            height: size.height * 0.0545,
                            width: size.width,
                            padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.01),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: size.width * 0.33,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1,
                                              color: Colors.black38))),
                                  padding: EdgeInsets.all(size.height * 0.01),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Total: ',
                                        style: TextStyle(
                                            fontSize: size.width * 0.02,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        ' \$${value.totalAmount(context).toStringAsFixed(2)}',
                                        style: TextStyle(
                                            fontSize: size.width * 0.02,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: size.width * 0.33,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                              width: 1,
                                              color: Colors.black38))),
                                  padding: EdgeInsets.all(size.height * 0.01),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Total Items: ',
                                        style: TextStyle(
                                            fontSize: size.width * 0.02,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        '${value.orderItems.length}',
                                        style: TextStyle(
                                            fontSize:  size.width * 0.02,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                    width: size.width * 0.33,
                                    decoration: const BoxDecoration(),
                                    // padding: EdgeInsets.all(size.height * 0.01),
                                    child: InkWell(
                                      onTap: value.orderItems.isEmpty
                                          ? () {}
                                          : () {
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      CartScreen.routeName);
                                            },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: size.width * 0.02),
                                        decoration: BoxDecoration(
                                            // border: Border.all(width: 1),
                                            color: Constants().primaryColor),
                                        height: size.height * 0.5,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Icon(
                                              CupertinoIcons.cart,
                                              size: size.width * 0.04,
                                              color: Colors.white,
                                            ),
                                            Text(
                                              'Proceed to Cart',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: size.width * 0.024,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )),

                                // CustomButton(
                                //     height: size.height * 0.035,
                                //     width: size.width * 0.25,
                                //     color: Colors.black,
                                //     borderOn: true,
                                //     borderColor: Colors.grey.shade200,
                                //     borderWidth: 2,
                                //     borderRadius: size.height * 0.005,
                                //     onPressed: value.orderItems.isEmpty
                                //         ? () {}
                                //         : () {
                                //             Navigator.of(context)
                                //                 .pushReplacementNamed(
                                //                     CartScreen.routeName);
                                //           },
                                //     child: Text(
                                //       'Go To Cart',
                                //       style:
                                //           TextStyle(fontSize: size.height * 0.02),
                                //     ))
                              ],
                            )),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

   deciderDialog() {
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.height * 0.01)),
      title: Text(
        'Select scan option',
        style: TextStyle(fontSize: size.height * 0.02),
      ),
      content: SizedBox(
        width: size.width * 0.4,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();

              showDialog(
                context: context,
                builder: (context) => const AvailableReadersDialog(),
              );
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.height * 0.01)),
                backgroundColor: Constants().primaryColor),
            child: Text(
              'Scan Readers',
              style: TextStyle(fontSize: size.height * 0.015),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();

              showDialog(
                context: context,
                builder: (context) => const AvailablePrinters(),
              );
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.height * 0.01)),
                backgroundColor: Constants().primaryColor),
            child: Text(
              'Scan Printers',
              style: TextStyle(fontSize: size.height * 0.015),
            ),
          )
        ]),
      ),
    );
  }
}
