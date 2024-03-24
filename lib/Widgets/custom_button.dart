import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final bool borderOn;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final Widget child;
  final VoidCallback onPressed;

  const CustomButton({super.key, 
    required this.height,
    required this.width,
    required this.color,
    required this.borderOn,
    required this.borderColor,
    required this.borderWidth,
    required this.borderRadius,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: BorderSide(
                color: borderOn ? borderColor : Colors.transparent,
                width: borderOn ? borderWidth : 0,
              ),
            ),
          ),
          child: child),
    );
  }
}
