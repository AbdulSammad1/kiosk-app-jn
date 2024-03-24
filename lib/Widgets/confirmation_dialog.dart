import 'package:flutter/material.dart';
import 'package:kiosk_app/Models/Order_Model.dart';
import 'package:kiosk_app/Providers/Order_Item_Provider.dart';
import 'package:kiosk_app/Screens/touch_to_start_screen.dart';
import 'package:kiosk_app/Widgets/custom_button.dart';
import 'package:kiosk_app/Widgets/printer_class.dart';
import 'package:provider/provider.dart';

class ConfirmationDialog extends StatefulWidget {
  const ConfirmationDialog({super.key, required this.orderObject});
  final OrderModel orderObject;
  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final orderitemsProvider =
        Provider.of<OrderItemsProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.height * 0.02)),
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size.height * 0.02)),
        height: size.height * 0.55,
        width: size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * 0.1,
            ),
            Icon(
              Icons.check_circle_outline_outlined,
              size: size.height * 0.15,
              color: Colors.green,
            ),
            SizedBox(
              height: size.height * 0.015,
            ),
            Text(
              '\$${orderitemsProvider.totalAmount(context).toStringAsFixed(2)}',
              style: TextStyle(
                  fontSize: size.height * 0.038, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Text(
              'Payment Successful',
              style: TextStyle(
                  fontSize: size.height * 0.03,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                      height: size.height * 0.06,
                      width: size.width * 0.3,
                      color: Colors.black,
                      borderOn: false,
                      borderColor: Colors.white,
                      borderWidth: 0,
                      borderRadius: size.height * 0.01,
                      onPressed: isLoading ?  () {} : () async {
                        setState(() {
                          isLoading= true;
                        });
                        await PrinterClass.printReceipt(widget.orderObject);
                         setState(() {
                          isLoading= false;
                        });
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const TouchToStartScreen(),
                        ));
                        orderitemsProvider.clearList();
                      },
                      child: isLoading ?  const Center(child: CircularProgressIndicator(color: Colors.white,),) : Text(
                        'Print Reciept',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.0225),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            )
          ],
        ),
      ),
    );
  }
}
