import 'package:flutter/material.dart';
import 'package:kiosk_app/Providers/admin_provider.dart';
import 'package:kiosk_app/Providers/kiosk_slider_items_provider.dart';
import 'package:kiosk_app/Providers/kiosk_user_provider.dart';
import 'package:kiosk_app/Providers/printer_provider.dart';
import 'package:kiosk_app/Providers/saleItemProvider.dart';
import 'package:kiosk_app/Screens/home_screen.dart';
import 'package:kiosk_app/Widgets/custom_button.dart';
import 'package:kiosk_app/Widgets/terminal_functions.dart';
import 'package:kiosk_app/constants.dart';
import 'package:mek_stripe_terminal/mek_stripe_terminal.dart';
import 'package:provider/provider.dart';

class TouchToStartScreen extends StatefulWidget {
  const TouchToStartScreen({super.key});

  @override
  State<TouchToStartScreen> createState() => _TouchToStartScreenState();
}

class _TouchToStartScreenState extends State<TouchToStartScreen> {
  bool touched = false;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

 
  void fetchData() async {
    if (Constants.kioskItmesLoaded == false) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      TerminalFunctions.termianl_variable_paymentStatus =
          PaymentStatus.notReady;
      TerminalFunctions.termianl_variable_paymentIntent = null;
      if (Constants.terminalInilized == false) {
        await TerminalFunctions.initTerminal(() {
          setState(() {});
        });
        Constants.terminalInilized = true;
      }

      final saleItemProvider =
          Provider.of<SaleItemProvider>(context, listen: false);
      final adminProvider = Provider.of<AdminProvider>(context, listen: false);
      final kioskSliderProvider =
          Provider.of<KioskSliderItemsProvider>(context, listen: false);
      final kioskUserProvider =
          Provider.of<KioskUserProvider>(context, listen: false);
      final printerProvider =
          Provider.of<PrinterProvider>(context, listen: false);
      if (Constants.kioskItmesLoaded == false) {
        await kioskUserProvider.fetchKioskUsers();
        await saleItemProvider.fetchDataByList();
        await kioskSliderProvider.fetchDataByList();
        await adminProvider.fetchKioskSliderTimer();
        await printerProvider.fetchPrinters();
        Constants.kioskItmesLoaded = true;
      }
    } catch (e) {
      Constants().showDialogBox(context, 'The error is', e.toString());
      // TODO
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : touched
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: size.height * 0.65,
                        width: size.width,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/fast_food_kiosk_background_image.jpg'))),
                      ),
                      Container(
                        color: const Color.fromRGBO(230, 215, 200, 1.0),
                        height: size.height * 0.35,
                        width: size.width,
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Text(
                              'Select Your Order Type',
                              style: TextStyle(
                                  fontSize: size.height * 0.038,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                    height: size.height * 0.165,
                                    width: size.height * 0.165,
                                    color: Constants().primaryColor,
                                    borderOn: false,
                                    borderColor: Colors.white,
                                    borderWidth: 0,
                                    borderRadius: size.width * 0.015,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.dinner_dining_rounded,
                                          size: size.height * 0.095,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          height: size.height * 0.005,
                                        ),
                                        Text(
                                          'Dine In',
                                          style: TextStyle(
                                              fontSize: size.height * 0.025,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              HomeScreen.routeName);
                                    }),
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                CustomButton(
                                    height: size.height * 0.165,
                                    width: size.height * 0.165,
                                    color: Constants().primaryColor,
                                    borderOn: false,
                                    borderColor: Colors.white,
                                    borderWidth: 0,
                                    borderRadius: size.width * 0.015,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.takeout_dining,
                                          size: size.height * 0.095,
                                          color: Colors.white,
                                        ),
                                        SizedBox(
                                          height: size.height * 0.005,
                                        ),
                                        Text(
                                          'Take Out',
                                          style: TextStyle(
                                              fontSize: size.height * 0.025,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        )
                                      ],
                                    ),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              HomeScreen.routeName);
                                    })
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(children: [
                    Container(
                      height: size.height * 0.8,
                      width: size.width,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/fast_food_kiosk_background_image.jpg'))),
                    ),
                    Container(
                      color: const Color.fromRGBO(230, 215, 200, 1.0),
                      height: size.height * 0.2,
                      width: size.width,
                      padding: EdgeInsets.only(
                          left: size.width * 0.2,
                          right: size.width * 0.2,
                          top: size.height * 0.05,
                          bottom: size.height * 0.07),
                      child: CustomButton(
                          height: size.height * 0.08,
                          width: size.width * 0.7,
                          color: Constants().primaryColor,
                          borderOn: false,
                          borderColor: Colors.white,
                          borderWidth: 0,
                          borderRadius: size.width * 0.01,
                          child: Text(
                            'Start Order',
                            style: TextStyle(
                                fontSize: size.height * 0.04,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(HomeScreen.routeName);
                          }),
                    ),
                  ]),
      ),
    );
  }
}
