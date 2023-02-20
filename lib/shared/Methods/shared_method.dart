import 'package:flutter/material.dart';

Future navigateTo(context, Widget screen) {
  return Navigator.push(context, MaterialPageRoute(builder: (context) {
    return screen;
  }));
}
