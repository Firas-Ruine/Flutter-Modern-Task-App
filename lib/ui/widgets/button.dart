// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:todo_app_with_dark/ui/theme.dart';

class Button extends StatelessWidget {
//Initialize button fields
  final String label;
  final Function()? onTap;
  const Button({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 100,
          height: 60,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: primaryClr),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ));
  }
}
