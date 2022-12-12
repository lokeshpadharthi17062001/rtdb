import 'package:flutter/material.dart';

import 'constant.dart';

InputDecoration textFieldDecoration({String hintText=""}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.all(0),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      hintText: hintText,
      counterText: "",
      hintStyle: TextStyle(color: Constant().cursorColor));
}