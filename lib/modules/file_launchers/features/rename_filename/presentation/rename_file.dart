import 'dart:io';

import 'package:browser_launcher/core/widgets/popus/snackbars.dart';
import 'package:browser_launcher/core/widgets/w_button.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path;

class RenameFile extends StatefulWidget {
  final String fileName;
  const RenameFile({
    required this.fileName,
    Key? key,
  }) : super(key: key);

  @override
  State<RenameFile> createState() => _RenameFileState();
}

class _RenameFileState extends State<RenameFile> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: widget.fileName.split('/')[widget.fileName.split('/').length - 1],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Rename the file:',
          style: Theme.of(context).textTheme.headline4!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
        ),
        TextField(
          autofocus: true,
          controller: controller,
          onChanged: (value) {},
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: WButton(
                  onTap: () async {
                    try {
                      var lastSeparator =
                          widget.fileName.lastIndexOf(Platform.pathSeparator);
                      var newPath =
                          widget.fileName.substring(0, lastSeparator + 1) +
                              controller.text.trim();
                      final renamedFile =
                          await File(widget.fileName).rename(newPath);
                    } catch (e) {
                      Navigator.of(context).pop();
                      print('Error occured');
                      showErrorSnackBar(
                        context,
                        message: 'Cannot rename. Error: $e',
                      );
                    }
                    // var pathToAppDir = '';
                    // final baseDir = await path.getExternalStorageDirectory();
                    // if (baseDir != null) {
                    //   for (final folderName
                    //       in baseDir.path.split(Platform.pathSeparator)) {
                    //     if (folderName != 'Android') {
                    //       pathToAppDir += '/$folderName';
                    //     } else {
                    //       break;
                    //     }
                    //   }
                    //   Directory appDir =
                    //       await Directory('$pathToAppDir/BrowserLauncher')
                    //           .create(recursive: false);
                    // }
                  },
                  text: 'Save',
                  color: Colors.green,
                  textStyle: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: WButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  text: 'Discard',
                  color: Colors.red,
                  textStyle: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
