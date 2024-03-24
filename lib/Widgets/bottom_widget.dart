import 'package:flutter/material.dart';
import 'package:kiosk_app/Widgets/custom_button.dart';
import 'package:kiosk_app/constants.dart';

class BottomWidget extends StatefulWidget {
  const BottomWidget({super.key});

  @override
  State<BottomWidget> createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          height: size.height * 0.14,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: size.height * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                  height: size.height * 0.045,
                  width: size.width * 0.45,
                  color: Colors.grey.shade200,
                  borderOn: true,
                  borderColor: Colors.grey.shade400,
                  borderWidth: 2,
                  borderRadius: size.height * 0.2,
                  child: Text(
                    'Empty Cart',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: size.height * 0.015,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {}),
              CustomButton(
                  height: size.height * 0.045,
                  width: size.width * 0.45,
                  color: Constants().primaryColor,
                  borderOn: false,
                  borderColor: Colors.grey.shade400,
                  borderWidth: 0,
                  borderRadius: size.height * 0.2,
                  child: Text('Proceed To Payment',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: size.height * 0.015,
                          fontWeight: FontWeight.bold)),
                  onPressed: () {})
            ],
          ),
        )
      ],
    );
  }
}
