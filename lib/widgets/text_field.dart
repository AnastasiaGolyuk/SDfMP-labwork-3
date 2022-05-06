import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key, required this.label, required this.controller,  required this.isPasswordField})
      : super(key: key);

  final String label;
  final TextEditingController controller;
  final bool isPasswordField;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPasswordField,
      style: TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.white, fontSize: 15),
        labelText: label,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 3),
        ),
      ),
    );
  }
}
