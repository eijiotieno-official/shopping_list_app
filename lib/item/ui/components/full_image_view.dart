import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullImageView extends StatelessWidget {
  final Uint8List imageData;
  const FullImageView({super.key, required this.imageData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: Image.memory(imageData)),
    );
  }
}
