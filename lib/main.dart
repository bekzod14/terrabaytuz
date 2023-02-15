import 'package:flutter/material.dart';
import 'package:terrabayt_uz/pages/home_page.dart';

import 'di/di_module.dart';

void main() {
  setUp();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}
