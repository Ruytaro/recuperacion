import 'package:flutter/material.dart';
import 'padding.dart';
import 'package:recuperacion/utils/validators.dart';

Widget myFormField(
  Function updateCallback,
  String label, {
  bool obscure = false,
  validator = validateNotEmpty,
}) {
  return edgePadding(
    TextFormField(
      obscureText: obscure,
      onChanged: (value) => updateCallback(value),
      validator: (value) => validator(label, value),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        constraints: BoxConstraints(maxWidth: 300),
      ),
    ),
  );
}
