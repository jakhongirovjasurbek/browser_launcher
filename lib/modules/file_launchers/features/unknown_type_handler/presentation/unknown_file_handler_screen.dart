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
          Text(
            'Oups.. \nLooks like we cannot open this file yet!\nFile path is: $path',
            style: Theme.of(context).textTheme.headline1!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
