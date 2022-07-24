import 'dart:io';

import 'package:flutter/material.dart';

class UnknownFileHandlerScreen extends StatelessWidget {
  final String path;
  const UnknownFileHandlerScreen({
    required this.path,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'File name is: ${path.split(Platform.pathSeparator).last}',
              style: Theme.of(context).textTheme.headline1!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
