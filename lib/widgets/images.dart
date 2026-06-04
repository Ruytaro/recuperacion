import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Image myImageFile(String path, double? size) {
  if (kIsWeb) {
    if (path == "images/avatar.png") {
      return Image.asset(path, width: size);
    }
    return Image.network(path, width: size);
  } else {
    if (path == "images/avatar.png") {
      return Image.asset("assets/$path", width: size);
    }

    File file = File(path);
    return Image.file(file, width: size);
  }
}
