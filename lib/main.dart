import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kiosk_app/Providers/Order_Item_Provider.dart';
import 'package:kiosk_app/Providers/Order_Provider.dart';
import 'package:kiosk_app/Providers/admin_provider.dart';
import 'package:kiosk_app/Providers/customer_provider.dart';
import 'package:kiosk_app/Providers/kiosk_slider_items_provider.dart';
import 'package:kiosk_app/Providers/kiosk_user_provider.dart';
import 'package:kiosk_app/Providers/printer_provider.dart';
import 'package:kiosk_app/Providers/saleItemProvider.dart';
import 'package:kiosk_app/Screens/cart_screen.dart';
import 'package:kiosk_app/Screens/contact_admin.dart';
import 'package:kiosk_app/Screens/home_screen.dart';
import 'package:kiosk_app/Screens/touch_to_start_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );

  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<KioskSliderItemsProvider>(
          create: (context) => KioskSliderItemsProvider(),
        ),
        ChangeNotifierProvider<AdminProvider>(
          create: (context) => AdminProvider(),
        ),
        ChangeNotifierProvider<SaleItemProvider>(
          create: (context) => SaleItemProvider(),
        ),
        ChangeNotifierProvider<OrderItemsProvider>(
          create: (context) => OrderItemsProvider(),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (context) => OrderProvider(),
        ),
        ChangeNotifierProvider<KioskUserProvider>(
          create: (context) => KioskUserProvider(),
        ),
        ChangeNotifierProvider<PrinterProvider>(
          create: (context) => PrinterProvider(),
        ),
         ChangeNotifierProvider<CustomerProvider>(
          create: (context) => CustomerProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: false,
        ),
        debugShowCheckedModeBanner: false,
        home: const TouchToStartScreen(),
        routes: {
          CartScreen.routeName: (context) => const CartScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
          ContactAdmin.routeName: (context) => const ContactAdmin(),
        },
      ),
    );
  }
}
