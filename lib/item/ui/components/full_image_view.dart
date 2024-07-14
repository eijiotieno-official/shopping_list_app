import 'dart:io';

import 'package:flutter/material.dart';

class FullImageView extends StatelessWidget {
  final String imagePath;
  const FullImageView({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Image.file(File(imagePath))),
    );
  }
}
