import 'package:flutter/material.dart';
import 'package:kiosk_app/Models/kiosk_user.dart';
import 'package:kiosk_app/Providers/customer_provider.dart';
import 'package:kiosk_app/Providers/kiosk_user_provider.dart';
import 'package:kiosk_app/Screens/check_out_screen.dart';
import 'package:kiosk_app/Widgets/custom_button.dart';
import 'package:kiosk_app/Widgets/text_field.dart';
import 'package:kiosk_app/constants.dart';
import 'package:provider/provider.dart';

class EnterNameEmailDialog extends StatefulWidget {
  const EnterNameEmailDialog({super.key});

  @override
  State<EnterNameEmailDialog> createState() => _EnterNameEmailDialogState();
}

class _EnterNameEmailDialogState extends State<EnterNameEmailDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final kioskUserProvider =
        Provider.of<KioskUserProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    final customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size.height * 0.01)),
      backgroundColor: const Color.fromARGB(255, 247, 234, 221),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Text(
            'Customer Info',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: size.height * 0.035, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.cancel,
              size: size.height * 0.035,
            ),
          )
        ],
      ),
      content: SizedBox(
          height: size.height * 0.35,
          width: size.width * 0.8,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  SizedBox(
                      height: size.height * 0.1,
                      width: size.width * 0.7,
                      child: CustomTextField2(
                          fontsize: size.height * 0.025,
                          contentPadding: size.height * 0.02,
                          labelText: 'Name',
                          textController: nameController,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Please enter name';
                            }
                            return null;
                          },
                          maxLines: 1)),
                  SizedBox(
                    height: size.height * 0.012,
                  ),
                  SizedBox(
                      height: size.height * 0.1,
                      width: size.width * 0.7,
                      child: CustomTextField2(
                          fontsize: size.height * 0.025,
                          contentPadding: size.height * 0.02,
                          labelText: 'Phone Number',
                          textController: phoneNumberController,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Please enter phone number';
                            }
                            return null;
                          },
                          maxLines: 1)),
                  SizedBox(
                    height: size.height * 0.012,
                  ),
                  SizedBox(
                      height: size.height * 0.1,
                      width: size.width * 0.7,
                      child: CustomTextField2(
                          fontsize: size.height * 0.025,
                          contentPadding: size.height * 0.02,
                          labelText: 'Email',
                          textController: emailController,
                          validator: (value) {
                            // if (value!.trim().isEmpty) {
                            //   return 'Please enter email';
                            // }
                            // else if(!(value.trim().endsWith('com')))
                            // {
                            //   return 'Please enter a valid email';
                            // }
                            //  else if(!(value.trim().contains('@')))
                            // {
                            //   return 'Please enter a valid email';
                            // }
                            return null;
                          },
                          maxLines: 1)),
                ],
              ),
            ),
          )),
      actions: [
        Padding(
          padding: EdgeInsets.only(
              bottom: size.height * 0.05, right: size.width * 0.07),
          child: CustomButton(
              height: size.height * 0.065,
              width: size.width * 0.3,
              color: Colors.grey.shade100,
              borderOn: true,
              borderColor: Constants().primaryColor,
              borderWidth: 2,
              borderRadius: size.height * 0.01,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Proceed',
                    style: TextStyle(
                        fontSize: size.height * 0.022, color: Colors.black),
                  ),
                  SizedBox(
                    width: size.width * 0.01,
                  ),
                  Icon(Icons.arrow_circle_right_outlined,
                      color: Colors.black, size: size.height * 0.022),
                ],
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  kioskUserProvider.setTempUser(KioskUser(
                      id: '',
                      name: nameController.text,
                      email: emailController.text,
                      phoneNumber: phoneNumberController.text,
                      numberOfOrders: 1));
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CheckOutScreen()));
                }
              }),
        )
      ],
    );
  }
}
