import 'dart:io';

import 'package:flutter/material.dart';

class ImageOpenerScreen extends StatelessWidget {
  final String path;
  const ImageOpenerScreen({
    Key? key,
    required this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: const BoxDecoration(),
      child: Image.file(
        File(path),
        fit: BoxFit.cover,
      ),
    );
  }
}
