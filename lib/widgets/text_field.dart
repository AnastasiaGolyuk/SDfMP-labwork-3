import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(
      {Key? key,
      required this.label,
      required this.controller,
      required this.isPasswordField})
      : super(key: key);

  final String label;
  final TextEditingController controller;
  final bool isPasswordField;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _passwordVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isPasswordField) {
      return TextFormField(
        controller: widget.controller,
        obscureText: !_passwordVisible,
        style: TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.white, fontSize: 15),
          labelText: widget.label,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
            ),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 3),
          ),
        ),
      );
    } else {
      return TextFormField(
        controller: widget.controller,
        style: TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          labelStyle: TextStyle(color: Colors.white, fontSize: 15),
          labelText: widget.label,
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
}
