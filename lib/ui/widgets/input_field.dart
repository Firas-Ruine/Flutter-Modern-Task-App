
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app_with_dark/ui/theme.dart';

class InputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const InputField(
      {super.key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          title,
          style: titleStyle,
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.only(left: 14),
          height: 52,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [
            Expanded(
                child: TextFormField(
              readOnly: widget == null ? false : true,
              autofocus: false,
              cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
              controller: controller,
              style: subTitleStyle,
              decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: subTitleStyle,
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: context.theme.backgroundColor, width: 0))),
            )),
            widget == null
                ? Container()
                : Container(
                    child: widget,
                  )
          ]),
        )
      ]),
    );
  }
}
