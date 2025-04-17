import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.color,
    this.margin,
    this.width,
    this.height,
    this.fontSize,
    this.icon,
    this.radius, Center? child,
  });

  final String title;
  final VoidCallback onTap;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final double? fontSize;
  final IconData? icon;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 10.0),
        height: height ?? 50.0,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: color ?? kPrimaryColor,
          borderRadius: BorderRadius.circular(radius ?? 15.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Icon(
                      icon,
                      color: Colors.white,
                    ),
                  )
                : const SizedBox.shrink(),
            AutoSizeText(
              title,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'SF-Pro', fontSize: fontSize ?? 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
