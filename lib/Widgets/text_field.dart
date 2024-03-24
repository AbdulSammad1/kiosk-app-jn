import 'package:flutter/material.dart';
import 'package:kiosk_app/constants.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController textController;
  final String? Function(String?)? validator;
  final bool showNumberPad;
  final int maxLines;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.textController,
    required this.validator,
    this.showNumberPad = false,
    required this.maxLines,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        maxLines: widget.maxLines,
        validator: widget.validator,
        controller: widget.textController,
        keyboardType:
            widget.showNumberPad ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: widget.labelText,
          // border:
          //     OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Constants().primaryColor)),
        ),
      ),
    );
  }
}

class CustomTextField2 extends StatefulWidget {
  final String labelText;
  final TextEditingController textController;
  final String? Function(String?)? validator;
  final bool showNumberPad;
  final int maxLines;
  final bool obscureText;
  final String? Function(String?)? onchanged;
  final bool noPadding;
  final double contentPadding;
  final double fontsize;
  const CustomTextField2(
      {Key? key,
      required this.labelText,
      required this.textController,
      required this.validator,
      this.showNumberPad = false,
      this.noPadding = false,
      required this.maxLines,
      this.contentPadding = 8,
      required this.fontsize,
      this.onchanged,
      this.obscureText = false})
      : super(key: key);

  @override
  State<CustomTextField2> createState() => _CustomTextField2State();
}

class _CustomTextField2State extends State<CustomTextField2> {
  bool hideText = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hideText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: widget.noPadding ? null : const EdgeInsets.all(8),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(fontSize: widget.fontsize),
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        maxLines: widget.maxLines,
        validator: widget.validator,
        controller: widget.textController,
        onChanged: widget.onchanged,
        obscureText: hideText,
        keyboardType:
            widget.showNumberPad ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: size.height * 0.015),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
              vertical: widget.contentPadding,
              horizontal: widget.contentPadding),
          suffixIcon: widget.obscureText
              ? InkWell(
                  onTap: () {
                    setState(() {
                      hideText = !hideText;
                    });
                  },
                  child: Icon(
                    hideText ? Icons.visibility : Icons.visibility_off,
                    color: Constants().primaryColor,
                  ))
              : null,
          hintText: widget.labelText,
          floatingLabelStyle: TextStyle(color: Constants().primaryColor),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Constants().primaryColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  BorderSide(width: 2.5, color: Constants().primaryColor)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  BorderSide(width: 2.5, color: Constants().primaryColor)),
        ),
      ),
    );
  }
}
