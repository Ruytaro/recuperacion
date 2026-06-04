import 'package:flutter/material.dart';

Padding edgePadding(Widget child) {
  return Padding(padding: EdgeInsetsGeometry.all(5), child: child);
}

Padding leftPadding(Widget child) {
  return Padding(
    padding: EdgeInsetsGeometry.directional(bottom: 5, top: 5, start: 5),
    child: child,
  );
}

Padding rightPadding(Widget child) {
  return Padding(
    padding: EdgeInsetsGeometry.directional(bottom: 5, top: 5, end: 5),
    child: child,
  );
}
