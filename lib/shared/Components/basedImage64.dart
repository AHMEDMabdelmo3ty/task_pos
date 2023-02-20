import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class Base64ImageWidget extends StatelessWidget {
  final String base64String;

  const Base64ImageWidget(this.base64String, {super.key});

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64.decode(base64String);

    return Image.memory(
      bytes,
      fit: BoxFit.cover,
    );
  }
}
