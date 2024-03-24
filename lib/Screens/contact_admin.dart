import 'package:flutter/material.dart';


class ContactAdmin extends StatelessWidget {
  static const routeName = '/contact-admin';
  const ContactAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(child: Image.asset('assets/error_image.png', width: size.width * 1, height: size.width * 1,),),
    );
  }
}