import 'package:flutter/material.dart';

class PdfReaderScreen extends StatefulWidget {
  final String path;
  const PdfReaderScreen({
    required this.path,
    Key? key,
  }) : super(key: key);

  @override
  State<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends State<PdfReaderScreen> {
  @override
  Widget build(BuildContext context) {
    return Align(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Oups.. \nLooks like we cannot open this file yet!\nFile path is: ${widget.path}',
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
