import 'package:flutter/material.dart';
import 'package:kiosk_app/Models/Order_Model.dart';
import 'package:kiosk_app/Models/customer_model.dart';
import 'package:kiosk_app/Providers/Order_Item_Provider.dart';
import 'package:kiosk_app/Providers/Order_Provider.dart';
import 'package:kiosk_app/Providers/kiosk_user_provider.dart';
import 'package:kiosk_app/Widgets/confirmation_dialog.dart';
import 'package:kiosk_app/Widgets/terminal_functions.dart';
import 'package:provider/provider.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  bool isLoading = true;
  bool confrimationStarted = false;
  @override
  void initState() {
    // TODO: implement initState
    initialize();
    super.initState();
  }

  void initialize() async {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final orderItemProvider =
        Provider.of<OrderItemsProvider>(context, listen: false);
    final kioskUserPorvider =
        Provider.of<KioskUserProvider>(context, listen: false);
    try {
      final orderItemsProvider =
          Provider.of<OrderItemsProvider>(context, listen: false);
      num temp = orderItemsProvider.totalAmount(context) * 100.00;

      int amount = temp.toInt();

      await TerminalFunctions.createPaymentIntent(
          TerminalFunctions.termianl_variable_terminal!, amount);
      setState(() {
        isLoading = false;
      });
      TerminalFunctions.collectPaymentMethod(
          TerminalFunctions.termianl_variable_terminal!,
          TerminalFunctions.termianl_variable_paymentIntent!,
      () {
        setState(() {});
      }, (value) async {
        await kioskUserPorvider
            .addOrUpdateKioskUser(kioskUserPorvider.tempUser!);
        String orderNumber = await orderProvider.getOrderNumber();
        final orderObject = OrderModel(
            id: '0',
            employeeName: 'employeeName',
            customer: CustomerModel(id: kioskUserPorvider.tempUser?.id ?? '', name: kioskUserPorvider.tempUser?.name ?? '', address:  '', apartment: '', city: '', zipCode: '', phoneNum: '', email: ''),
            orderItems: orderItemProvider.orderItems,
            orderType: 'Take away',
            orderClassification: 'KIOSK',
            remarks: 'remarks',
            date: DateTime.now(),
            completeTime: DateTime.now(),
            orderNumber: orderNumber,
            status: 'InProgress',
            loyaltyMoney: 0,
            loyaltyPoints: 0,
           
            totalPrice: orderItemProvider.totalAmount(context));
        await orderProvider.addOrder(orderObject);
        setState(() {
          confrimationStarted = false;

          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => ConfirmationDialog(orderObject: orderObject),
          );
        });
      }, () {
        setState(() {
          confrimationStarted = true;
        });
      });
    } on Exception catch (e) {
      print(e);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    final orderItemsProvider =
        Provider.of<OrderItemsProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(230, 214, 200, 1),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.1,
            ),
            Container(
              padding: EdgeInsets.only(
                  top: size.height * 0.015,
                  right: size.width * 0.1,
                  left: size.width * 0.1),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size.height * 0.02)),
              height: size.height * 0.2,
              width: size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Order Total:',
                    style: TextStyle(
                        fontSize: size.height * 0.028,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    children: [
                      Text(
                        'Subtotal:',
                        style: TextStyle(
                            fontSize: size.height * 0.0225,
                            fontWeight: FontWeight.w500),
                      ),
                      const Expanded(child: SizedBox()),
                      Text(
                        '\$${(orderItemsProvider.totalAmount(context) - orderItemsProvider.totalTaxAmount(context) ).toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: size.height * 0.0225,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Tax:',
                        style: TextStyle(
                            fontSize: size.height * 0.0225,
                            fontWeight: FontWeight.w500),
                      ),
                      const Expanded(child: SizedBox()),
                      Text(
                        '\$${orderItemsProvider.totalTaxAmount(context).toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: size.height * 0.0225,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.006,
                  ),
                  const Divider(
                    color: Color.fromRGBO(178, 160, 141, 1),
                  ),
                  SizedBox(
                    height: size.height * 0.006,
                  ),
                  Row(
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(
                            fontSize: size.height * 0.024,
                            fontWeight: FontWeight.w500),
                      ),
                      const Expanded(child: SizedBox()),
                      Text(
                        '\$${orderItemsProvider.totalAmount(context).toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: size.height * 0.024,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.015,
            ),
            Container(
              padding: EdgeInsets.only(
                  top: size.height * 0.015,
                  right: size.width * 0.1,
                  left: size.width * 0.1),
              height: size.height * 0.4,
              width: size.width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(size.height * 0.015)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: isLoading
                    ? [
                        const CircularProgressIndicator(),
                       
                      ]
                    : TerminalFunctions.termianl_variable_paymentStatus.name ==
                            'waitingForInput'
                        ? [
                            Text(
                              'Tap To Pay',
                              style: TextStyle(
                                  fontSize: size.height * 0.045,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: size.height * 0.015,
                            ),
                            SizedBox(
                              height: size.height * 0.2,
                              width: size.width * 0.55,
                              child: Image.asset(
                                'assets/tap_to_pay_image.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          ]
                        : confrimationStarted
                            ? [
                                const CircularProgressIndicator(),
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                Text(
                                  'Processing Payment',
                                  style:
                                      TextStyle(fontSize: size.height * 0.025),
                                )
                              ]
                            : [
                                SizedBox(
                                    height: size.height * 0.3,
                                    child: Center(
                                        child: isLoading
                                            ? const CircularProgressIndicator()
                                            : const Text('Transaction Successfull')))
                              ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
