import 'package:flutter/material.dart';
import 'package:kiosk_app/Screens/cart_screen.dart';
import 'package:kiosk_app/Screens/home_screen.dart';
import 'package:kiosk_app/constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    // Replace these with your actual widgets for "Menu" and "Cart"
    const HomeScreen(),
    const CartScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final heightOfBottomBar = size.height * 0.047;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _pages[_selectedIndex],
            const Expanded(
              child: SizedBox(),
            ),
            Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 4, // Blur radius
                    offset: const Offset(0, 2), // Offset
                  )
                ]),
                height: heightOfBottomBar,
                width: size.width,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_selectedIndex == 1) {
                          setState(() {
                            _selectedIndex = 0;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: _selectedIndex == 0
                                ? Constants().primaryColor
                                : Colors.white),
                        height: heightOfBottomBar,
                        width: size.width * 0.5,
                        child: Center(
                            child: Text(
                          'MENU',
                          style: TextStyle(
                              fontSize: size.height * 0.02,
                              fontWeight: FontWeight.bold,
                              color: _selectedIndex == 0
                                  ? Colors.white
                                  : Colors.black),
                        )),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_selectedIndex == 0) {
                          setState(() {
                            _selectedIndex = 1;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: _selectedIndex == 1
                                ? Constants().primaryColor
                                : Colors.white),
                        height: heightOfBottomBar,
                        width: size.width * 0.5,
                        child: Center(
                            child: Text(
                          'CART',
                          style: TextStyle(
                              fontSize: size.height * 0.02,
                              fontWeight: FontWeight.bold,
                              color: _selectedIndex == 1
                                  ? Colors.white
                                  : Colors.black),
                        )),
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
