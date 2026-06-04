import 'package:flutter/material.dart';
import 'padding.dart';

Widget myElevatedButton(VoidCallback? callback, Widget label) {
  return edgePadding(ElevatedButton(onPressed: callback, child: label));
}
