import 'dart:io';

import 'package:browser_launcher/core/widgets/popus/snackbars.dart';
import 'package:browser_launcher/core/widgets/w_scale.dart';
import 'package:browser_launcher/modules/browser/core/bloc/browser_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:open_file/open_file.dart';

class DirectoryFilesScreen extends StatelessWidget {
  final String parentFileName;
  const DirectoryFilesScreen({
    required this.parentFileName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(parentFileName)),
        body: BlocBuilder<BrowserBloc, BrowserState>(
          builder: (context, state) {
            if (state.fileStatus == FormzStatus.submissionInProgress) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state.fileStatus == FormzStatus.submissionSuccess) {
              return SingleChildScrollView(
                child: Wrap(
                  children: [
                    ...state.directoryFiles
                        .map(
                          (e) => WScaleAnimation(
                            onTap: () async {
                              try {
                                await OpenFile.open(File(e.path).path);
                              } catch (e) {
                                showErrorSnackBar(context, message: '$e');
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.file_present_outlined,
                                    size: 50,
                                  ),
                                  Text(
                                    e.path.split(Platform.pathSeparator).last,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ));
  }
}
